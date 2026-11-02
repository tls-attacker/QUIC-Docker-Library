# Quick Start

Easily set up and run the latest QUIC client implementations in our library using the provided Docker Compose file. Follow these steps:

1. Build the Docker images:  

    ```bash
    docker compose build
    ```

2. Start a container:  

    ```bash
    docker compose up [SERVICE]
    ```

**Important:**

- Each client is pre-configured to connect to 127.0.0.1:4433 (excluding msquic).
- Where supported, the clients verify the server certificate against the CA certificate of this project (`certs/ca.crt`/`certs/ca.der`), which is created by the [generateCerts.sh](../certs/generateCerts.sh) script. Some clients do not support certificate verification at all. See the compose file and the README files of the individual libraries for details.
- Some clients require specific algorithms or extensions for the handshake. See the README files of the individual libraries for details.
