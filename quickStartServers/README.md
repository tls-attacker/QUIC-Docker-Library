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

**Important:** Before starting, ensure you generate the required certificates and keys by executing the [generateCerts.sh](../certs/generateCerts.sh) script located in the [certs](certs) directory. These certificates and keys will be mounted as a volume and used by the containers.

## Available Implementations

The table below lists the QUIC server implementations that can be built and started using the provided Docker Compose setup. Each server is pre-configured to run on its respective port.

**Important:** Some servers require specific algorithms or extensions for the handshake. See the README files of the individual libraries for details.

| Implementation                   | Port     |
|----------------------------------|----------|
| aioquic                          | 8000     |
| kwik                             | 8001     |
| lsquic                           | 8002     |
| msquic                           | 8003     |
| neqo                             | 8004     |
| ngtcp2                           | 8005     |
| picoquic                         | 8006     |
| proxygen-mvfst                   | 8007     |
| quic-go                          | 8008     |
| quiche-cloudflare                | 8009     |
| quicly                           | 8010     |
| quinn                            | 8011     |
| s2n-quic                         | 8012     |
| xquic (babassl)                  | 8013     |
| xquic (boringssl)                | 8014     |
| openssl                          | 8015     |
| quiche-google                    | 8016     |
