# xquic

## Source:

[https://github.com/alibaba/xquic](https://github.com/alibaba/xquic)

## Supported Versions:

1.7.1, 1.7.2

## Building the Docker Image
```
docker build --build-arg VERSION=1.7.2 --no-cache -t xquic-server:1.7.2 .
```

## Starting the Docker Container
```
docker run xquic-server:1.7.2 
```