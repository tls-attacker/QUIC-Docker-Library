#FROM alpine-build:3.19
FROM linuxcontainers/debian-slim:latest
#Using Debian because facebook does not know Alpine Linux and reverts to compiling all dependencies which is unnecessary
ARG VERSION

RUN apt update
RUN apt -y install git python3 sudo build-essential openssl libssl-dev pkg-config libfast-float-dev

WORKDIR /
RUN git clone --depth=1 --branch=v${VERSION} https://github.com/facebook/proxygen.git
WORKDIR /proxygen/proxygen/
RUN ./build.sh
RUN ./install.sh

EXPOSE 8443:6666/udp
ENTRYPOINT ["/proxygen/proxygen/_build/proxygen/httpserver/hq", "--mode=server", "-host", "0.0.0.0"]