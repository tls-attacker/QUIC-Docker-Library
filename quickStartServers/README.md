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

**Important:** Before starting, ensure you generate the required certificates and keys by executing the [generateCerts.sh](../certs/generateCerts.sh) script. These certificates and keys will be mounted as a volume and used by the containers.

## Available Implementations

The table below lists the QUIC server implementations that can be built and started using the provided Docker Compose setup. Each server is pre-configured to run on its respective port.

**Important:** Some servers require specific algorithms or extensions for the handshake. See the README files of the individual libraries for details.

| Implementation                   | Port     |
|----------------------------------|----------|
| aioquic                          | 8000     |
| kwik                             | 8001     |
| lsquic                           | 8002     |
| msquic (openssl)                 | 8003     |
| msquic (quictls)                 | 8004     |
| neqo                             | 8005     |
| ngtcp2                           | 8006     |
| picoquic                         | 8007     |
| proxygen-mvfst                   | 8008     |
| quic-go                          | 8009     |
| quiche-cloudflare                | 8010     |
| quicly                           | 8011     |
| quinn                            | 8012     |
| s2n-quic (s2n-tls)               | 8013     |
| s2n-quic (rustls)                | 8014     |
| xquic (babassl)                  | 8015     |
| xquic (boringssl)                | 8016     |
| openssl                          | 8017     |
| quiche-google                    | 8018     |
