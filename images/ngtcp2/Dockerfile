FROM rub-nds/quic/alpine-build:3.24.3 AS ngtcp2-src

ARG VERSION_NGTCP2
ARG VERSION_NGHTTP3
ARG VERSION_BORINGSSL

RUN git clone --depth=1 --branch=v${VERSION_NGTCP2} --recursive --shallow-submodules https://github.com/ngtcp2/ngtcp2.git /ngtcp2
# VERSION_BORINGSSL if set, otherwise the commit from `git checkout <commit>` in the section "Build with BoringSSL" of the README.rst
RUN v="${VERSION_BORINGSSL}"; \
    if [ -z "$v" ]; then v=$(sed -n '/^Build with BoringSSL/,/^Build with aws-lc/p' /ngtcp2/README.rst | grep -o -E 'git checkout [0-9a-z.]+' | head -1 | cut -d' ' -f3); fi; \
    if [ -z "$v" ]; then echo "No BoringSSL version found, set VERSION_BORINGSSL" >&2; exit 1; fi; \
    echo "$v" > /boringssl-version && echo "BoringSSL $v"
# VERSION_NGHTTP3 if set, otherwise the minimum version from `libnghttp3 >= <version>` in the configure.ac
RUN v="${VERSION_NGHTTP3}"; \
    if [ -z "$v" ]; then v=$(grep -o -E 'libnghttp3 >= [0-9.]+' /ngtcp2/configure.ac | head -1 | cut -d' ' -f3); fi; \
    if [ -z "$v" ]; then echo "No nghttp3 version found, set VERSION_NGHTTP3" >&2; exit 1; fi; \
    echo "$v" > /nghttp3-version && echo "nghttp3 $v"

# Build boringssl separately from ngtcp2, so it can be reused for several ngtcp2 versions
FROM rub-nds/quic/alpine-build:3.24.3 AS boringssl
COPY --from=ngtcp2-src /boringssl-version /boringssl-version
WORKDIR /boringssl
RUN git init -q && git remote add origin https://github.com/google/boringssl.git
RUN git fetch --depth=1 origin $(cat /boringssl-version) && git checkout -q FETCH_HEAD
RUN cmake -B build -DCMAKE_POSITION_INDEPENDENT_CODE=ON
RUN make -C build -j$(nproc) ssl crypto

# Build nghttp3 separately from ngtcp2, so it can be reused for several ngtcp2 versions
FROM rub-nds/quic/alpine-build:3.24.3 AS nghttp3
COPY --from=ngtcp2-src /nghttp3-version /nghttp3-version
RUN git clone --depth=1 --branch=v$(cat /nghttp3-version) --recursive --shallow-submodules https://github.com/ngtcp2/nghttp3.git /nghttp3
WORKDIR /nghttp3
RUN autoreconf -i
RUN ./configure --prefix=$PWD/build --enable-lib-only
RUN make -j$(nproc) install

# Build ngtcp2 with the example server and client
FROM boringssl AS ngtcp2-base
COPY --from=nghttp3 /nghttp3 /nghttp3
COPY --from=ngtcp2-src /ngtcp2 /ngtcp2
WORKDIR /ngtcp2
RUN autoreconf -i
RUN ./configure PKG_CONFIG_PATH=$PWD/../nghttp3/build/lib/pkgconfig \
    BORINGSSL_LIBS="-L$PWD/../boringssl/build -lssl -lcrypto" \
    BORINGSSL_CFLAGS="-I$PWD/../boringssl/include" \
    --with-boringssl --with-libnghttp3
RUN make -j$(nproc)

FROM ngtcp2-base AS ngtcp2-server
ENV QUIC_CMD="/ngtcp2/examples/bsslserver"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM ngtcp2-base AS ngtcp2-client
ENV QUIC_CMD="/ngtcp2/examples/bsslclient"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]