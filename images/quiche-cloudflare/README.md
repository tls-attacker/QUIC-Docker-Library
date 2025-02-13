# quiche - cloudflare

## Source:

[https://github.com/cloudflare/quiche](https://github.com/cloudflare/quiche)

## Supported Versions:

0.20.0, 0.20.1, 0.23.2

## Building the Docker Image
```
docker build --build-arg VERSION=0.23.2 --no-cache -t quiche-cloudflare-server:0.23.2 .
```

## Starting the Docker Container
```
docker run -p 8443:8443/udp quiche-cloudflare-server:0.23.2
```