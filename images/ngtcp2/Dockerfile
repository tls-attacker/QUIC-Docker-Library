FROM rub-nds/quic/alpine-build:3.23.3 AS ngtcp2-base

ARG VERSION_NGTCP2
ARG VERSION_NGHTTP3
ARG VERSION_BORINGSSL

# Clone projects
RUN git clone --depth=1 --branch=${VERSION_BORINGSSL} https://github.com/google/boringssl.git
RUN git clone --depth=1 --branch=v${VERSION_NGHTTP3} https://github.com/ngtcp2/nghttp3.git
RUN git clone --depth=1 --branch=v${VERSION_NGTCP2} https://github.com/ngtcp2/ngtcp2.git

# Build boringssl
WORKDIR /boringssl
RUN cmake -B build -DCMAKE_POSITION_INDEPENDENT_CODE=ON
RUN make -C build

# Build nghttp3
WORKDIR /nghttp3
RUN git submodule update --init
RUN autoreconf -i
RUN ./configure --prefix=$PWD/build --enable-lib-only
RUN make check
RUN make install

# Build ngtcp2
WORKDIR /ngtcp2
RUN git submodule update --init
RUN autoreconf -i
RUN ./configure PKG_CONFIG_PATH=$PWD/../nghttp3/build/lib/pkgconfig \
    BORINGSSL_LIBS="-L$PWD/../boringssl/build/ssl -lssl -L$PWD/../boringssl/build/crypto -lcrypto" \
    BORINGSSL_CFLAGS="-I$PWD/../boringssl/include" \
    --with-boringssl
RUN make check

FROM ngtcp2-base AS ngtcp2-server
ENTRYPOINT ["/ngtcp2/examples/bsslserver"]

FROM ngtcp2-base AS ngtcp2-client
ENTRYPOINT ["/ngtcp2/examples/bsslclient"]