# Proxygen with mvfst

## Source:

[https://github.com/facebook/mvfst](https://github.com/facebook/mvfst)

## Supported Versions:

2025.02.10.00

## Building the Docker Image
```
docker build --build-arg VERSION=2024.07.01.00 --no-cache -t proxygen-mvfst-server:2024.07.01.00 .
```

## Starting the Docker Container
```
docker run -p 8443:8443/udp proxygen-mvfst-server:2024.07.01.00
```


