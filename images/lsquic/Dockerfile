FROM alpine-build:3.19 AS lsquic
ARG VERSION

RUN apk update
RUN apk add build-base libevent-dev zlib-dev zlib-static
ENV CMAKE_LIBRARY_PATH=/lib
RUN apk add openssl
RUN openssl req -newkey rsa:2048 -nodes -keyout testserver.key -x509 -days 3650 -out testserver.crt -subj "/CN=localhost"
RUN apk del openssl

WORKDIR /
WORKDIR /
RUN git clone https://boringssl.googlesource.com/boringssl
WORKDIR boringssl
RUN git checkout 9fc1c33e9c21439ce5f87855a6591a9324e569fd
RUN cmake .
RUN make

WORKDIR /
RUN git clone --depth=1 --branch=v${VERSION} https://github.com/litespeedtech/lsquic.git
WORKDIR lsquic
RUN git submodule update --init
ENV EXTRA_CFLAGS='-DLSQUIC_QIR=1'
RUN cmake -DBORINGSSL_DIR=/boringssl .
RUN make

WORKDIR /
RUN mkdir docroot

EXPOSE 8443:8443/udp
ENTRYPOINT ["/lsquic/bin/http_server", "-r", "/docroot", "-s", "0.0.0.0:8443", "-c", "localhost,/testserver.crt,/testserver.key"]

