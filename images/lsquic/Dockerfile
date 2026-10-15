FROM rub-nds/quic/alpine-build:3.19 AS lsquic-base

ARG VERSION_LSQUIC
ARG VERSION_BORINGSSL

# Clone projects
RUN git clone --depth=1 --branch=${VERSION_BORINGSSL} https://github.com/google/boringssl.git
RUN git clone --depth=1 --branch=v${VERSION_LSQUIC} https://github.com/litespeedtech/lsquic.git

# Build boringssl
WORKDIR /boringssl
RUN cmake .
RUN make

# Build lsquic
WORKDIR /lsquic
RUN git submodule update --init
ENV EXTRA_CFLAGS='-DLSQUIC_QIR=1'
RUN cmake -DBORINGSSL_DIR=/boringssl .
RUN make

FROM lsquic-base AS lsquic-server
ENV QUIC_CMD="/lsquic/bin/http_server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM lsquic-base AS lsquic-client
ENV QUIC_CMD="/lsquic/bin/http_client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]