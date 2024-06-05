# quic-go

## Source:

[https://github.com/quic-go/quic-go](https://github.com/quic-go/quic-go)

## Supported Versions:

0.41.0, 0.42.0

## Building the Docker Image
```
docker build --build-arg VERSION=0.42.0 --no-cache -t quic-go-server:0.42.0 .
```

## Starting the Docker Container
```
docker run quic-go-server:0.42.0
```