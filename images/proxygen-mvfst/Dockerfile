# Using Debian because facebook does not know Alpine Linux 
# and reverts to compiling all dependencies which is unnecessary
FROM debian:13-slim AS proxygen-mvfst-base

ARG VERSION

RUN apt update && \
    apt -y install git python3 sudo build-essential openssl libssl-dev pkg-config libfast-float-dev

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/facebook/proxygen.git
WORKDIR /proxygen/proxygen/
ENV MAKEFLAGS="-j2"
RUN ./build.sh
RUN ./install.sh

FROM proxygen-mvfst-base AS proxygen-mvfst-server
COPY --from=rub-nds/quic/alpine-build:3.19 /control_server.py /control_server.py
ENV QUIC_CMD="/proxygen/proxygen/_build/proxygen/httpserver/hq --mode=server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM proxygen-mvfst-base AS proxygen-mvfst-client
COPY --from=rub-nds/quic/alpine-build:3.19 /control_server.py /control_server.py
ENV QUIC_CMD="/proxygen/proxygen/_build/proxygen/httpserver/hq --mode=client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]