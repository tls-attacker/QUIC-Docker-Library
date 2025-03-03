FROM alpine-build:3.19 AS xquic
ARG VERSION 
ARG VERSION_BABASSL=8.3-stable

RUN apk update
RUN apk add cunit

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/alibaba/xquic
RUN git clone --depth 1 --branch=${VERSION_BABASSL} https://github.com/Tongsuo-Project/Tongsuo.git xquic/third_party/babassl

WORKDIR /xquic/third_party/babassl/

RUN ./config --prefix=/usr/local/babassl
RUN make -j
WORKDIR /xquic/

RUN git submodule update --init --recursive
RUN mkdir -p build
WORKDIR /xquic/build/
RUN cmake -DGCOV=on -DCMAKE_BUILD_TYPE=Debug -DXQC_ENABLE_TESTING=1 -DXQC_SUPPORT_SENDMMSG_BUILD=1 -DXQC_ENABLE_EVENT_LOG=1 -DXQC_ENABLE_BBR2=1 -DXQC_ENABLE_RENO=1 -DSSL_TYPE=babassl -DSSL_PATH=/xquic/third_party/babassl/ ..

RUN make -j

WORKDIR /xquic/build/demo/

RUN apk add openssl
RUN openssl req -newkey rsa:2048 -nodes -keyout server.key -x509 -days 3650 -out server.crt -subj "/CN=localhost"
RUN apk del openssl
RUN touch session_ticket.key
ENTRYPOINT [ "./demo_server", "-r", "-l", "d"]