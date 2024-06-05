# quinn

## Source:

[https://github.com/quinn-rs/quinn](https://github.com/quinn-rs/quinn)

## Supported Versions:

0.10.3, 0.10.4

## Building the Docker Image
```
docker build --build-arg VERSION=0.10.3 --no-cache -t quinn-server:0.10.3 .
```

## Starting the Docker Container
```
docker run quinn-server:0.10.3
```