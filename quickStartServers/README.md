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
| ngtcp2 (boringssl)               | 8006     |
| ngtcp2 (awslc)                   | 8007     |
| ngtcp2 (quictls)                 | 8008     |
| ngtcp2 (libressl)                | 8009     |
| ngtcp2 (openssl)                 | 8010     |
| ngtcp2 (gnutls)                  | 8011     |
| ngtcp2 (wolfssl)                 | 8012     |
| ngtcp2 (picotls)                 | 8013     |
| picoquic                         | 8014     |
| proxygen-mvfst                   | 8015     |
| quic-go                          | 8016     |
| quiche-cloudflare                | 8017     |
| quicly                           | 8018     |
| quinn                            | 8019     |
| s2n-quic (s2n-tls)               | 8020     |
| s2n-quic (rustls)                | 8021     |
| xquic (babassl)                  | 8022     |
| xquic (boringssl)                | 8023     |
| openssl                          | 8024     |
| quiche-google                    | 8025     |
