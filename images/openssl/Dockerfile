FROM rub-nds/quic/alpine-build:3.21.2 AS openssl-base

ARG VERSION

RUN git clone --depth=1 --branch=openssl-${VERSION} https://github.com/openssl/openssl
WORKDIR /openssl
RUN ./config --prefix=/build/ --openssldir=/build/ enable-demos
RUN make -j && make install

# Copy all required libraries
RUN mkdir /libdeps
RUN cp libcrypto.so.3 /usr/lib/
RUN cp libcrypto.a /usr/lib/
RUN cp libssl.so.3 /usr/lib/
RUN cp $(LD_LIBRARY_PATH="/build/lib/" ldd /build/bin/openssl | \
    awk '$3=="" {print $1}; $3!="" {print $3}') /libdeps/

FROM openssl-base AS openssl-server
ENTRYPOINT ["/openssl/demos/quic/server/server"]

FROM openssl-base AS openssl-client
ENTRYPOINT ["openssl", "s_client"]