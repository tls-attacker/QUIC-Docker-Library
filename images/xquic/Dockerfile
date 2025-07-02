FROM rub-nds/quic/alpine-build:3.19 AS xquic-base

ARG VERSION_XQUIC
ARG VERSION_BABASSL

# Clone projects
RUN git clone --depth=1 --branch=v${VERSION_XQUIC} https://github.com/alibaba/xquic
RUN git clone --depth 1 --branch=${VERSION_BABASSL} https://github.com/Tongsuo-Project/Tongsuo.git xquic/third_party/babassl

# Build babassl
WORKDIR /xquic/third_party/babassl/
RUN ./config --prefix=/usr/local/babassl
RUN make -j

# Build xquic
WORKDIR /xquic/
RUN git submodule update --init --recursive
RUN mkdir -p build
WORKDIR /xquic/build/
RUN cmake -DGCOV=on -DCMAKE_BUILD_TYPE=Debug -DXQC_ENABLE_TESTING=1 -DXQC_SUPPORT_SENDMMSG_BUILD=1 -DXQC_ENABLE_EVENT_LOG=1 -DXQC_ENABLE_BBR2=1 -DXQC_ENABLE_RENO=1 -DSSL_TYPE=babassl -DSSL_PATH=/xquic/third_party/babassl/ ..
RUN make -j

# Add a self-signed certificate for the server
WORKDIR /xquic/build/demo/
RUN openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 3650 -out server.crt -subj "/CN=localhost"

FROM xquic-base AS xquic-server
ENTRYPOINT [ "./demo_server"]

FROM xquic-base AS xquic-client
ENTRYPOINT [ "./demo_client"]