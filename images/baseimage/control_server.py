#!/usr/bin/env python3
"""
Control server wrapper for QUIC Docker containers.

Manages a QUIC process lifecycle and exposes an HTTP control API on port 8090.

Environment variables:
    QUIC_CMD      - The base command to run (e.g. "python3 examples/http3_server.py")
    CONTROL_MODE  - "server" (auto-restart on exit) or "client" (wait for /trigger)

Any extra CLI arguments are appended to QUIC_CMD.

Endpoints:
    POST /kill    - SIGKILL the running process
    POST /trigger - Start the process (client mode)
    GET  /status  - Report process state
"""

import json
import os
import shlex
import signal
import subprocess
import sys
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler

proc = None
proc_lock = threading.Lock()
mode = os.environ.get("CONTROL_MODE", "server")
quic_cmd = None
shutdown_event = threading.Event()


def build_command():
    base = os.environ.get("QUIC_CMD", "")
    if not base:
        print("ERROR: QUIC_CMD environment variable is not set", file=sys.stderr)
        sys.exit(1)
    base = os.path.expandvars(base)
    parts = shlex.split(base)
    parts.extend(sys.argv[1:])
    return parts


def start_process():
    global proc
    with proc_lock:
        if proc and proc.poll() is None:
            return False
        proc = subprocess.Popen(quic_cmd)
        print(f"Started process PID {proc.pid}: {' '.join(quic_cmd)}", flush=True)
        return True


def kill_process():
    global proc
    with proc_lock:
        if proc and proc.poll() is None:
            pid = proc.pid
            proc.kill()
            proc.wait()
            print(f"Killed process PID {pid}", flush=True)
            return True
        return False


def monitor_loop():
    """Watch the subprocess; auto-restart in server mode."""
    global proc
    while not shutdown_event.is_set():
        with proc_lock:
            p = proc
        if p is not None:
            p.wait()
            if shutdown_event.is_set():
                break
            if mode == "server":
                print("Process exited, restarting (server mode)...", flush=True)
                start_process()
            else:
                print("Process exited (client mode), waiting for /trigger", flush=True)
        shutdown_event.wait(0.5)


class Handler(BaseHTTPRequestHandler):
    def _respond(self, code, body):
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(body).encode())

    def do_POST(self):
        if self.path == "/kill":
            if kill_process():
                self._respond(200, {"status": "killed"})
            else:
                self._respond(404, {"status": "not_running"})
        elif self.path == "/trigger":
            if start_process():
                self._respond(200, {"status": "started"})
            else:
                self._respond(409, {"status": "already_running"})
        else:
            self._respond(404, {"error": "not_found"})

    def do_GET(self):
        if self.path == "/status":
            with proc_lock:
                p = proc
            if p and p.poll() is None:
                self._respond(200, {"status": "running", "pid": p.pid})
            else:
                self._respond(200, {"status": "stopped", "pid": None})
        else:
            self._respond(404, {"error": "not_found"})

    def log_message(self, format, *args):
        print(f"[control] {args[0]}", flush=True)


def graceful_shutdown(signum, frame):
    print(f"Received signal {signum}, shutting down...", flush=True)
    shutdown_event.set()
    kill_process()
    sys.exit(0)


def main():
    global quic_cmd
    quic_cmd = build_command()

    signal.signal(signal.SIGTERM, graceful_shutdown)
    signal.signal(signal.SIGINT, graceful_shutdown)

    # Start the process immediately
    start_process()

    # Start monitor thread
    monitor = threading.Thread(target=monitor_loop, daemon=True)
    monitor.start()

    # Start HTTP control server
    port = int(os.environ.get("CONTROL_PORT", "8090"))
    server = HTTPServer(("0.0.0.0", port), Handler)
    print(f"Control server listening on :{port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        shutdown_event.set()
        kill_process()
        server.server_close()


if __name__ == "__main__":
    main()
