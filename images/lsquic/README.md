# ngtcp2

## Source:

[https://github.com/litespeedtech/lsquic](https://github.com/litespeedtech/lsquic)

## Supported Versions:

4.0.9

## Building the Docker Image
```
docker build --build-arg VERSION=4.0.9 --no-cache -t lsquic:4.0.9 .
```

## Starting the Docker Container
```
docker run -p 8443:8443/udp lsquic:4.0.9
```

