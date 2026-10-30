FROM rub-nds/quic/alpine-build:3.19 AS lsquic-src

ARG VERSION_LSQUIC
ARG VERSION_BORINGSSL

RUN git clone --depth=1 --branch=v${VERSION_LSQUIC} https://github.com/litespeedtech/lsquic.git /lsquic
RUN git -C /lsquic submodule update --init --depth=1
# 4.3.0 and 4.3.1 miss includes (fixed in 4.3.2), add them if needed
RUN cd /lsquic && if grep -q lsquic_sfcw_t src/liblsquic/lsquic_stream.h && ! grep -q lsquic_sfcw.h bin/http_client.c; then \
        sed -i 's|^#include "../src/liblsquic/lsquic_stream.h"|#include "../src/liblsquic/lsquic_sfcw.h"\n#include "../src/liblsquic/lsquic_varint.h"\n#include "../src/liblsquic/lsquic_hq.h"\n&|' bin/http_client.c; \
    fi
# VERSION_BORINGSSL if set, otherwise the one named in the lsquic readme
RUN v="${VERSION_BORINGSSL}"; \
    if [ -z "$v" ]; then v=$(grep -o -E 'git checkout [0-9a-z.]+' /lsquic/README.md | head -1 | cut -d' ' -f3); fi; \
    if [ -z "$v" ]; then echo "No BoringSSL version found, set VERSION_BORINGSSL" >&2; exit 1; fi; \
    echo "$v" > /boringssl-version && echo "BoringSSL $v"

# Build boringssl separately from lsquic, so it can be reused for several lsquic versions
FROM rub-nds/quic/alpine-build:3.19 AS boringssl
COPY --from=lsquic-src /boringssl-version /boringssl-version
WORKDIR /boringssl
RUN git init -q && git remote add origin https://github.com/google/boringssl.git
RUN git fetch --depth=1 origin $(cat /boringssl-version) && git checkout -q FETCH_HEAD
RUN cmake .
RUN make -j$(nproc) ssl crypto

# Build lsquic (only the example server and client)
FROM boringssl AS lsquic-base
COPY --from=lsquic-src /lsquic /lsquic
WORKDIR /lsquic
ENV EXTRA_CFLAGS='-DLSQUIC_QIR=1'
RUN cmake -DBORINGSSL_DIR=/boringssl -DLIBSSL_DIR=/boringssl -DLSQUIC_TESTS=OFF .
RUN make -j$(nproc) http_server http_client

FROM lsquic-base AS lsquic-server
ENV QUIC_CMD="/lsquic/bin/http_server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM lsquic-base AS lsquic-client
ENV QUIC_CMD="/lsquic/bin/http_client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
