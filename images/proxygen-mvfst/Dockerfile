# Using Debian because facebook does not know Alpine Linux 
# and reverts to compiling all dependencies which is unnecessary
FROM linuxcontainers/debian-slim:12.5 AS proxygen-mvfst-base

ARG VERSION

RUN apt update && \
    apt -y install git python3 sudo build-essential openssl libssl-dev pkg-config libfast-float-dev

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/facebook/proxygen.git
WORKDIR /proxygen/proxygen/
RUN ./build.sh
RUN ./install.sh

FROM proxygen-mvfst-base AS proxygen-mvfst-server
ENTRYPOINT ["/proxygen/proxygen/_build/proxygen/httpserver/hq", "--mode=server"]

FROM proxygen-mvfst-base AS proxygen-mvfst-client
ENTRYPOINT ["/proxygen/proxygen/_build/proxygen/httpserver/hq", "--mode=client"]