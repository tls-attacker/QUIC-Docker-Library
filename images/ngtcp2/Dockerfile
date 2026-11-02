ARG TLS_IMPLEMENTATION

FROM rub-nds/quic/alpine-build:3.24.3 AS ngtcp2-src

ARG VERSION_NGTCP2
ARG VERSION_NGHTTP3
ARG TLS_IMPLEMENTATION
ARG VERSION_BORINGSSL
ARG VERSION_AWSLC
ARG VERSION_QUICTLS
ARG VERSION_LIBRESSL
ARG VERSION_PICOTLS
ARG VERSION_WOLFSSL
ARG VERSION_OPENSSL
ARG VERSION_GNUTLS

RUN git clone --depth=1 --branch=v${VERSION_NGTCP2} --recursive --shallow-submodules https://github.com/ngtcp2/ngtcp2.git /ngtcp2

# Version of the TLS stack: the build argument if set, otherwise the one named in the README.rst of ngtcp2
RUN R=/ngtcp2/README.rst; \
    case "${TLS_IMPLEMENTATION}" in \
        boringssl) v="${VERSION_BORINGSSL:-$(sed -n '/^Build with BoringSSL/,/^Build with aws-lc/p' $R | grep -o -E 'git checkout [0-9a-z.]+' | head -1 | cut -d' ' -f3)}" ;; \
        awslc) v="${VERSION_AWSLC:-$(grep -o -E -- '-b v[0-9.]+ https://github.com/aws/aws-lc' $R | head -1 | cut -d' ' -f2)}" ;; \
        quictls) v="${VERSION_QUICTLS:-$(grep -o -E 'quictls/openssl/tree/[^>]+' $R | head -1 | sed 's|.*/tree/||')}" ;; \
        libressl) v="${VERSION_LIBRESSL:-$(grep -o -E 'LIBRESSL_VERSION=v[0-9.]+|-b v[0-9.]+ https://github.com/libressl/portable' $R | head -1 | grep -o -E 'v[0-9.]+')}" ;; \
        picotls) v="${VERSION_PICOTLS:-$(grep -o -E 'Picotls \(commit [0-9a-f]+\)' $R | head -1 | grep -o -E '[0-9a-f]{40}')}" ;; \
        wolfssl) v="${VERSION_WOLFSSL:-$(grep -o -E -- '-b v[0-9.]+-stable https://github.com/wolfSSL/wolfssl' $R | head -1 | cut -d' ' -f2)}" ;; \
        openssl) v="${VERSION_OPENSSL:-$(grep -o -E 'OpenSSL >= [0-9.]+' $R | head -1 | cut -d' ' -f3)}" ;; \
        gnutls) v="${VERSION_GNUTLS:-$(grep -o -E 'GnuTLS >= [0-9.]+' $R | head -1 | cut -d' ' -f3)}" ;; \
        *) echo "Unknown TLS_IMPLEMENTATION '${TLS_IMPLEMENTATION}'" >&2; exit 1 ;; \
    esac; \
    if [ -z "$v" ]; then echo "No ${TLS_IMPLEMENTATION} version found, set it as build argument" >&2; exit 1; fi; \
    echo "$v" > /tls-version && echo "${TLS_IMPLEMENTATION} $v"

# VERSION_NGHTTP3 if set, otherwise the minimum version from `libnghttp3 >= <version>` in the configure.ac
RUN v="${VERSION_NGHTTP3}"; \
    if [ -z "$v" ]; then v=$(grep -o -E 'libnghttp3 >= [0-9.]+' /ngtcp2/configure.ac | head -1 | cut -d' ' -f3); fi; \
    if [ -z "$v" ]; then echo "No nghttp3 version found, set VERSION_NGHTTP3" >&2; exit 1; fi; \
    echo "$v" > /nghttp3-version && echo "nghttp3 $v"

# Build the TLS stacks separately from ngtcp2, so they can be reused for several ngtcp2 versions.
# Only the stage selected by TLS_IMPLEMENTATION is built.
FROM rub-nds/quic/alpine-build:3.24.3 AS boringssl
COPY --from=ngtcp2-src /tls-version /tls-version
WORKDIR /boringssl
RUN git init -q && git remote add origin https://github.com/google/boringssl.git && \
    git fetch --depth=1 origin $(cat /tls-version) && git checkout -q FETCH_HEAD && rm -rf .git
RUN cmake -B build -DCMAKE_POSITION_INDEPENDENT_CODE=ON
RUN make -C build -j$(nproc) ssl crypto

FROM rub-nds/quic/alpine-build:3.24.3 AS awslc
COPY --from=ngtcp2-src /tls-version /tls-version
RUN git clone --depth=1 --branch=$(cat /tls-version) https://github.com/aws/aws-lc.git /awslc && rm -rf /awslc/.git
WORKDIR /awslc
RUN cmake -B build -DDISABLE_GO=ON
RUN make -C build -j$(nproc) ssl crypto

FROM rub-nds/quic/alpine-build:3.24.3 AS quictls
COPY --from=ngtcp2-src /tls-version /tls-version
RUN git clone --depth=1 --branch=$(cat /tls-version) https://github.com/quictls/openssl.git /quictls && rm -rf /quictls/.git
WORKDIR /quictls
RUN ./config --prefix=/quictls/build --openssldir=/etc/ssl no-shared no-tests
RUN make -j$(nproc) && make install_sw

FROM rub-nds/quic/alpine-build:3.24.3 AS libressl
COPY --from=ngtcp2-src /tls-version /tls-version
WORKDIR /libressl
RUN git clone --depth=1 --branch=$(cat /tls-version) https://github.com/libressl/portable.git . && \
    LIBRESSL_GIT_OPTIONS="-b libressl-$(cat /tls-version)" ./autogen.sh && rm -rf .git openbsd/.git
RUN ./configure --prefix=/libressl/build --disable-shared
RUN make -j$(nproc) install

FROM rub-nds/quic/alpine-build:3.24.3 AS picotls
COPY --from=ngtcp2-src /tls-version /tls-version
WORKDIR /picotls
RUN git init -q && git remote add origin https://github.com/h2o/picotls.git && \
    git fetch --depth=1 origin $(cat /tls-version) && git checkout -q FETCH_HEAD && \
    git submodule update --init --depth=1 && rm -rf .git
RUN cmake -B build -DCMAKE_POSITION_INDEPENDENT_CODE=ON
RUN make -C build -j$(nproc)

FROM rub-nds/quic/alpine-build:3.24.3 AS openssl
COPY --from=ngtcp2-src /tls-version /tls-version
RUN git clone --depth=1 --branch=openssl-$(cat /tls-version) https://github.com/openssl/openssl.git /openssl && rm -rf /openssl/.git
WORKDIR /openssl
RUN ./config --prefix=/openssl/build --openssldir=/etc/ssl --libdir=lib no-shared no-tests
RUN make -j$(nproc) && make install_sw

# GnuTLS is taken from the release archive, because building it from git needs many additional tools.
FROM rub-nds/quic/alpine-build:3.24.3 AS gnutls
COPY --from=ngtcp2-src /tls-version /tls-version
RUN apk add --no-cache nettle-dev libtasn1-dev libunistring-dev
RUN v=$(cat /tls-version) && \
    wget -q -O - https://www.gnupg.org/ftp/gcrypt/gnutls/v${v%.*}/gnutls-${v}.tar.xz | tar -xJ && \
    mv gnutls-${v} /gnutls
WORKDIR /gnutls
RUN ./configure --prefix=/gnutls/build --without-p11-kit --without-idn --disable-cxx --disable-tools \
    --disable-doc --disable-tests --disable-nls --disable-guile CFLAGS="-O2 -std=gnu17"
RUN make -j$(nproc) install

FROM rub-nds/quic/alpine-build:3.24.3 AS wolfssl
COPY --from=ngtcp2-src /tls-version /tls-version
RUN git clone --depth=1 --branch=$(cat /tls-version) https://github.com/wolfSSL/wolfssl.git /wolfssl && rm -rf /wolfssl/.git
WORKDIR /wolfssl
RUN autoreconf -i
# The tests and example programs of wolfSSL are not needed
RUN ./configure --prefix=/usr/local --enable-all --enable-aesni --enable-harden \
    --enable-keylog-export --disable-examples --disable-crypttests
RUN make -j$(nproc) install

# Build nghttp3 separately from ngtcp2, so it can be reused for several ngtcp2 versions
FROM rub-nds/quic/alpine-build:3.24.3 AS nghttp3
COPY --from=ngtcp2-src /nghttp3-version /nghttp3-version
RUN git clone --depth=1 --branch=v$(cat /nghttp3-version) --recursive --shallow-submodules https://github.com/ngtcp2/nghttp3.git /nghttp3
WORKDIR /nghttp3
RUN autoreconf -i
RUN ./configure --prefix=$PWD/build --enable-lib-only
RUN make -j$(nproc) install

# Build ngtcp2 with the example server and client of the selected TLS stack
FROM ${TLS_IMPLEMENTATION} AS ngtcp2-base
ARG TLS_IMPLEMENTATION
COPY --from=nghttp3 /nghttp3 /nghttp3
COPY --from=ngtcp2-src /ngtcp2 /ngtcp2
WORKDIR /ngtcp2
RUN autoreconf -i
# The example programs are named after the TLS stack (e.g. bsslserver), examples/server and examples/client link to them
RUN P=/nghttp3/build/lib/pkgconfig; \
    case "${TLS_IMPLEMENTATION}" in \
        boringssl) set -- --with-boringssl BORINGSSL_CFLAGS="-I/boringssl/include" BORINGSSL_LIBS="-L/boringssl/build -lssl -lcrypto"; n=bssl ;; \
        awslc) set -- --with-boringssl BORINGSSL_CFLAGS="-I/awslc/include" BORINGSSL_LIBS="-L/awslc/build/ssl -lssl -L/awslc/build/crypto -lcrypto"; n=bssl ;; \
        quictls) P="/quictls/build/lib/pkgconfig:$P"; set -- --with-openssl; n=qtls ;; \
        libressl) P="/libressl/build/lib/pkgconfig:$P"; set -- --with-openssl; n=qtls ;; \
        openssl) P="/openssl/build/lib/pkgconfig:$P"; set -- --with-openssl; n=ossl ;; \
        gnutls) P="/gnutls/build/lib/pkgconfig:$P"; set -- --with-gnutls LDFLAGS="-Wl,-rpath,/gnutls/build/lib"; n=gtls ;; \
        wolfssl) P="/usr/local/lib/pkgconfig:$P"; set -- --with-wolfssl; n=wssl ;; \
        picotls) set -- --with-picotls PICOTLS_CFLAGS="-I/picotls/include" PICOTLS_LIBS="-L/picotls/build -lpicotls-openssl -lpicotls-core"; n=ptls ;; \
    esac; \
    ./configure PKG_CONFIG_PATH="$P" --with-libnghttp3 "$@" && \
    make -j$(nproc) && \
    ln -s ${n}server examples/server && ln -s ${n}client examples/client

FROM ngtcp2-base AS ngtcp2-server
ENV QUIC_CMD="/ngtcp2/examples/server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM ngtcp2-base AS ngtcp2-client
ENV QUIC_CMD="/ngtcp2/examples/client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
