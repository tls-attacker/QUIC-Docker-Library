FROM rub-nds/quic/alpine-build:3.23.3 AS lsquic-base

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

# Create document root
WORKDIR /
RUN mkdir docroot

FROM lsquic-base AS lsquic-server
ENTRYPOINT ["/lsquic/bin/http_server"]

FROM lsquic-base AS lsquic-client
ENTRYPOINT ["/lsquic/bin/http_client"]