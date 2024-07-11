# msquic

## Source:

[https://github.com/microsoft/msquic](https://github.com/microsoft/msquic)

## Supported Versions:

2.3.5

## Building the Docker Image
```
docker build --build-arg VERSION=2.3.5 --no-cache -t msquic-server:2.3.5 .
```

## Starting the Docker Container
```
docker run -p 8443:4567/udp msquic-server:2.3.5
```

##Info

The sample server does not speak HTTP/3 but only a "sample" protocol. We replace the "sample" ALPN with h3 so TLS-Scanner can connect to the server without the connection being immediately closed due to no application protocol supported.
