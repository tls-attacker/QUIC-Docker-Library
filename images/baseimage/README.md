# Base Image

The base image includes a control server that wraps the QUIC process and exposes an HTTP API for managing its lifecycle.

## Control API Endpoints

### Process Management

```bash
# Check process status
curl http://localhost:8090/status

# Kill the running process
curl -X POST http://localhost:8090/kill

# Start the process (client mode only)
curl -X POST http://localhost:8090/trigger
```

### Configuration

View or modify the command parameters at runtime via `GET /config`.

```bash
# View current command and parameters
curl http://localhost:8090/config
```

**Set a flag value** — replace the value following a flag:

```bash
# Change the value after -p from its current value to 5678
curl "http://localhost:8090/config?setFlag=-p&setTo=5678"
```

**Substring replace within a flag value** — modify part of a flag's value:

```bash
# Within the value of -p, replace 1234 with 5678
curl "http://localhost:8090/config?setFlag=-p&replace=1234&replaceWith=5678"
```

**Global substring replace** — replace a substring anywhere in the command:

```bash
curl "http://localhost:8090/config?replace=1234&replaceWith=5678"
```

Append `&restart=true` to any modification to automatically restart the process with the updated parameters.
