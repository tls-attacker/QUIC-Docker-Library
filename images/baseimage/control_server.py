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
    GET  /config  - View or modify command parameters
                    Query params: setFlag, setTo, replace, replaceWith, restart
"""

import json
import os
import shlex
import signal
import subprocess
import sys
import threading
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs

proc = None
proc_lock = threading.Lock()
mode = os.environ.get("CONTROL_MODE", "server")
quic_cmd = None
shutdown_event = threading.Event()


def build_command():
    base = os.environ.get("QUIC_CMD", "")
    if not base:
        print("[Control-Script] ERROR: QUIC_CMD environment variable is not set", file=sys.stderr)
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
        print(f"[Control-Script] Started process PID {proc.pid}: {' '.join(quic_cmd)}", flush=True)
        return True


def kill_process():
    global proc
    with proc_lock:
        if proc and proc.poll() is None:
            pid = proc.pid
            proc.kill()
            proc.wait()
            print(f"[Control-Script] Killed process PID {pid}", flush=True)
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
                print("[Control-Script] Process exited, restarting (server mode)...", flush=True)
                start_process()
            else:
                with proc_lock:
                    proc = None
                print("[Control-Script] Process exited (client mode), waiting for /trigger", flush=True)
        shutdown_event.wait(0.5)


class Handler(BaseHTTPRequestHandler):
    def _respond(self, code, body):
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(body).encode())

    def _handle_config(self, params):
        global quic_cmd
        set_flag = params.get("setFlag", [None])[0]
        set_to = params.get("setTo", [None])[0]
        replace = params.get("replace", [None])[0]
        replace_with = params.get("replaceWith", [None])[0]
        do_restart = params.get("restart", ["false"])[0].lower() == "true"

        has_modification = set_flag is not None or replace is not None

        # Read-only: no modification params
        if not has_modification:
            with proc_lock:
                cmd = list(quic_cmd)
            self._respond(200, {"command": " ".join(cmd), "parts": cmd})
            return

        with proc_lock:
            if set_flag is not None and set_to is not None:
                # setFlag + setTo: replace the value after the flag
                try:
                    idx = quic_cmd.index(set_flag)
                except ValueError:
                    self._respond(400, {"error": f"flag '{set_flag}' not found in command"})
                    return
                if idx + 1 >= len(quic_cmd):
                    self._respond(400, {"error": f"flag '{set_flag}' has no value after it"})
                    return
                quic_cmd[idx + 1] = set_to

            elif set_flag is not None and replace is not None and replace_with is not None:
                # setFlag + replace + replaceWith: substring replace within flag's value
                try:
                    idx = quic_cmd.index(set_flag)
                except ValueError:
                    self._respond(400, {"error": f"flag '{set_flag}' not found in command"})
                    return
                if idx + 1 >= len(quic_cmd):
                    self._respond(400, {"error": f"flag '{set_flag}' has no value after it"})
                    return
                quic_cmd[idx + 1] = quic_cmd[idx + 1].replace(replace, replace_with)

            elif replace is not None and replace_with is not None:
                # Global string replace on entire command
                full = " ".join(quic_cmd)
                full = full.replace(replace, replace_with)
                quic_cmd = shlex.split(full)

            else:
                self._respond(400, {"error": "incomplete parameters: setFlag requires setTo, replace requires replaceWith"})
                return

            cmd = list(quic_cmd)

        restarted = False
        if do_restart:
            kill_process()
            start_process()
            restarted = True

        print(f"[Control-Script] Config updated: {' '.join(cmd)}", flush=True)
        self._respond(200, {"status": "updated", "command": " ".join(cmd), "restarted": restarted})

    def _handle_request(self):
        parsed = urlparse(self.path)
        path = parsed.path

        if path == "/kill":
            if kill_process():
                self._respond(200, {"status": "killed"})
            else:
                self._respond(404, {"status": "not_running"})
        elif path == "/trigger":
            if start_process():
                self._respond(200, {"status": "started"})
            else:
                self._respond(409, {"status": "already_running"})
        elif path == "/status":
            with proc_lock:
                p = proc
            if p and p.poll() is None:
                self._respond(200, {"status": "running", "pid": p.pid})
            else:
                self._respond(200, {"status": "stopped", "pid": None})
        elif path == "/config":
            self._handle_config(parse_qs(parsed.query))
        else:
            self._respond(404, {"error": "not_found"})

    def do_GET(self):
        self._handle_request()

    def do_POST(self):
        self._handle_request()

    def log_message(self, format, *args):
        print(f"[Control-Script] {args[0]}", flush=True)


def graceful_shutdown(signum, frame):
    print(f"[Control-Script] Received signal {signum}, shutting down...", flush=True)
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
    print(f"[Control-Script] Control server listening on :{port}", flush=True)
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
