# quiche - cloudflare

## Source:

[https://github.com/cloudflare/quiche](https://github.com/cloudflare/quiche)

## Supported Versions:

0.20.0, 0.20.1 

## Building the Docker Image
```
docker build --build-arg VERSION=0.20.1 --no-cache -t quiche-cloudflare-server:0.20.1 .
```

## Starting the Docker Container
```
docker run quiche-cloudflare-server:0.20.1
```