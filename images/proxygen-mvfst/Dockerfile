# Using Debian because facebook does not know Alpine Linux 
# and reverts to compiling all dependencies which is unnecessary
FROM debian:13-slim AS proxygen-mvfst-base

# The packages from install_dependencies_linux_default in the proxygen build.sh, installed here so they are cached for all versions.
RUN apt update && \
    apt -y install git python3 sudo lsb-release build-essential openssl libssl-dev pkg-config libfast-float-dev \
        cmake m4 g++ flex bison gperf wget unzip make \
        libgflags-dev libgoogle-glog-dev libkrb5-dev libsasl2-dev libnuma-dev libcap-dev libevent-dev libtool \
        libboost-all-dev libjemalloc-dev libsnappy-dev libiberty-dev liblz4-dev liblzma-dev zlib1g-dev \
        binutils-dev libsodium-dev libdouble-conversion-dev \
        libc-ares-dev

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/facebook/proxygen.git
WORKDIR /proxygen/proxygen/
ENV MAKEFLAGS="-j2"
RUN ./build.sh --no-tests
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