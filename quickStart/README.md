# Quick Start

Easily set up and run the latest QUIC server implementations in our library using the provided Docker Compose file. Follow these steps:

1. Build the Docker images:  

    ```bash
    docker compose build
    ```

2. Start the containers:  

    ```bash
    docker compose up
    ```

**Important:** Before starting, ensure you generate the required certificates and keys by executing the `generateCerts.sh` script located in the `certs` directory. These certificates and keys will be mounted as a volume and used by the containers.

## Available Implementations

The table below lists the QUIC server implementations that can be built and started using the provided Docker Compose setup. Each server is pre-configured to run on its respective port.

**Important:** Some servers require specific algorithms or extensions for the handshake. See the README files of the individual libraries for details.

| Implementation                   | Version           | Port     |
|----------------------------------|-------------------|----------|
| aioquic                          | latest            | 8000     |
| kwik                             | 0.8.11            | 8001     |
| lsquic                           | 4.2.0             | 8002     |
| msquic                           | 2.4.7             | 8003     |
| neqo                             | 0.11.0            | 8004     |
| ngtcp2                           | 1.12.0            | 8005     |
| picoquic                         | latest            | 8006     |
| proxygen-mvfst                   | 2025.02.10.00     | 8007     |
| quic-go                          | 0.51.0            | 8008     |
| quiche-cloudflare                | 0.20.1            | 8009     |
| quicly                           | latest            | 8010     |
| quinn                            | 0.10.4            | 8011     |
| s2n-quic                         | 1.58.0            | 8012     |
| xquic                            | 1.8.3             | 8013     |
| openssl                          | 3.5.1             | 8014     |
