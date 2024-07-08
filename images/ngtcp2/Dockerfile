FROM alpine-build:3.19 as ngtcp2
ARG VERSION

RUN apk update
RUN apk add openssl
RUN openssl req -newkey rsa:2048 -nodes -keyout testserver.key -x509 -days 3650 -out testserver.crt -subj "/CN=localhost"
RUN apk del openssl
RUN apk add libev libev-dev shared-mime-info
#RUN update-mime-database /etc/
RUN git clone https://boringssl.googlesource.com/boringssl
WORKDIR /boringssl
RUN git checkout a220a6024f66c123019b5c080f6bd8bcaf75448c
RUN cmake -B build -DCMAKE_POSITION_INDEPENDENT_CODE=ON
RUN make -j$(nproc) -C build
WORKDIR /
RUN git clone --recursive https://github.com/ngtcp2/nghttp3
WORKDIR /nghttp3
RUN autoreconf -i
RUN ./configure --prefix=$PWD/build --enable-lib-only
RUN make -j$(nproc) check
RUN make install
WORKDIR /
RUN git clone --recursive --depth=1 --branch=v${VERSION} https://github.com/ngtcp2/ngtcp2.git
WORKDIR /ngtcp2
RUN autoreconf -i
RUN ./configure PKG_CONFIG_PATH=$PWD/../nghttp3/build/lib/pkgconfig \
    BORINGSSL_LIBS="-L$PWD/../boringssl/build/ssl -lssl -L$PWD/../boringssl/build/crypto -lcrypto" \
    BORINGSSL_CFLAGS="-I$PWD/../boringssl/include" \
    --with-boringssl
RUN make -j$(nproc) check
WORKDIR /
RUN mkdir docroot

EXPOSE 8443:8443/udp
ENTRYPOINT ["/ngtcp2/examples/bsslserver", "-V", "-d", "/docroot", "0.0.0.0", "8443", "testserver.key", "testserver.crt"]


