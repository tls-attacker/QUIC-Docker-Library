FROM rub-nds/quic/alpine-build:3.24.3 AS openssl-base

ARG VERSION

RUN git clone --depth=1 --branch=openssl-${VERSION} https://github.com/openssl/openssl
WORKDIR /openssl
RUN ./config --prefix=/build/ --openssldir=/build/ --libdir=lib no-shared no-tests enable-demos
RUN make -j$(nproc) && make install_sw

FROM openssl-base AS openssl-server
ENV QUIC_CMD="/openssl/demos/quic/server/server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM openssl-base AS openssl-client
ENV QUIC_CMD="/build/bin/openssl s_client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]