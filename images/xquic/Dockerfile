FROM alpine-build:3.19 as xquic
ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/alibaba/xquic
WORKDIR /xquic

RUN git clone -b 8.3-stable https://github.com/Tongsuo-Project/Tongsuo.git ./third_party/babassl \
    && cd ./third_party/babassl \
    && ./config --prefix=/usr/local/babassl \
    && make -j \
    && SSL_TYPE_STR="babassl" \
    && SSL_PATH_STR="${PWD}" \
    && cd -

RUN git submodule update --init --recursive \
    && mkdir -p build; cd build \
    && cmake -DGCOV=on -DCMAKE_BUILD_TYPE=Debug -DXQC_ENABLE_TESTING=1 -DXQC_SUPPORT_SENDMMSG_BUILD=1 -DXQC_ENABLE_EVENT_LOG=1 -DXQC_ENABLE_BBR2=1 -DXQC_ENABLE_RENO=1 -DSSL_TYPE=${SSL_TYPE_STR} -DSSL_PATH=${SSL_PATH_STR} .. 

RUN make -j

TODO