# ngtcp2

## Source:

[https://github.com/ngtcp2/ngtcp2/](https://github.com/ngtcp2/ngtcp2/)

## Supported Versions:

1.10.0

## Building the Docker Image
```
docker build --build-arg VERSION=1.6.0 --no-cache -t ngtcp2-server:1.10.0 .
```

## Starting the Docker Container
```
docker run -p 8443:8443/udp ngtcp2-server:1.10.0
```

Note that QUIC address validation is enforced by default in this docker image (ngtcp2 parameter -V)
