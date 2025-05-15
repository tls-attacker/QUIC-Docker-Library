# QUIC-Docker-Library

This project provides Dockerfiles for various QUIC implementations, supporting both client and server setups.

## Generating Certificates and Keys

To generate certificates and keys, use the `generateCerts.sh` script located in the `certs` folder. This script uses [OpenSSL](https://github.com/openssl/openssl).

## Building QUIC Implementations

1. Navigate to the folder of your desired QUIC implementation.
2. List the available versions of the implementation:

    ```bash
    docker compose config --services
    ```

3. Build a specific version:

    ```bash
    docker compose build [SERVICE]
    ```

    Or build all versions:

    ```bash
    docker compose build
    ```

## Running a QUIC Implementation

Once built, start the selected service with:

```bash
docker run --rm -v [PATH_TO_CERTS_FOLDER]:/certs rub-nds/quic/[SERVICE] [FLAGS]
```

- Replace `[PATH_TO_CERTS_FOLDER]` with the path to your local `certs` folder.
- Replace `[SERVICE]` with the desired implementation.
- Replace `[FLAGS]` with any additional flags required.
