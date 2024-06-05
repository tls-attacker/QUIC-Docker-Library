# s2n-quic

## Source:

[https://github.com/aws/s2n-quic](https://github.com/aws/s2n-quic)

## Supported Versions:

1.34.0, 1.35.0

## Building the Docker Image
```
docker build --build-arg VERSION=1.35.0 --no-cache -t s2n-quic-server:1.35.0 .
```

## Starting the Docker Container
```
docker run s2n-quic-server:1.35.0
```