FROM alpine-build:3.19 as xquic
ARG VERSION 
ARG VERSION_BABASSL=8.4.0

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/alibaba/xquic
RUN git clone --depth 1 --branch=${VERSION_BABASSL} https://github.com/Tongsuo-Project/Tongsuo.git xquic/third_party/babassl

WORKDIR /xquic/third_party/babassl/
RUN ./Configure --api=1.1.1 no-deprecated && \
    make -j 

WORKDIR /xquic_bin
RUN cmake -DSSL_TYPE="babassl" -DSSL_PATH="/xquic/third_party/babassl" -DCMAKE_BUILD_TYPE=DEBUG -DXQC_PRINT_SECRET=1 -DXQC_ENABLE_TESTING=1 ../xquic/ && \
    make -j

ADD ./server.crt /xquic_bin/demo/server.crt
ADD ./server.key /xquic_bin/demo/server.key

WORKDIR /xquic_bin/demo
ENTRYPOINT [ "./demo_server"]