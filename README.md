# QUIC-Docker-Library

This project provides Dockerfiles for various QUIC implementations, supporting both client and server setups.

## Generating Certificates and Keys

To generate certificates and keys, use the [generateCerts.sh](certs/generateCerts.sh) script located in the [certs](certs) directory. This script uses [OpenSSL](https://github.com/openssl/openssl).

## Building QUIC Implementations

1. Navigate to the [images/baseimage](images/baseimage) directory and build the base images using Docker Compose:

    ```bash
    docker compose build
    ```

2. Navigate to the directory for the desired QUIC implementation.

3. List the available versions of the implementation:

    ```bash
    docker compose config --services
    ```

4. Build a specific version of the implementation:

    ```bash
    docker compose build [SERVICE]
    ```

    Alternatively, build all available versions:

    ```bash
    docker compose build
    ```

## Running a QUIC Implementation

After building the images, start the selected service with:

```bash
docker run --rm -v [PATH_TO_CERTS_FOLDER]:/certs rub-nds/quic/[SERVICE] [FLAGS]
```

- Replace `[PATH_TO_CERTS_FOLDER]` with the path to your local `certs` directory.
- Replace `[SERVICE]` with the desired implementation.
- Replace `[FLAGS]` with any additional flags required.

## Quick Start

For fast setup of the newest implementations, see the [quickStartClients](quickStartClients/) and [quickStartServers](quickStartServers/) directories.

## Control Server

Each container runs a control server that exposes an HTTP API for managing the QUIC process at runtime. This allows you to check the process status, kill or restart it, and modify command parameters without rebuilding the container. See the [base image README](images/baseimage/README.md) for available endpoints and usage examples.

## Publication

This project is introduced in the following USENIX Security '26 publication:

> Nurullah Erinola, Marcel Maehren, Marcus Brinkmann, and Jörg Schwenk. 2026. Breaking the Boundaries: Analyzing QUIC Frame-Packet Interactions With QUIC-Attacker. In 35th USENIX Security Symposium (USENIX Security '26). <https://www.usenix.org/conference/usenixsecurity26/presentation/erinola>
