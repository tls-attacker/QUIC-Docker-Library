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
- Some clients require specific algorithms or extensions for the handshake. See the README files of the individual libraries for details.
