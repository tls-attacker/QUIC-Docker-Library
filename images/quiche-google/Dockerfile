FROM rub-nds/quic/alpine-build:3.19 AS quiche-google-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/google/quiche
WORKDIR /quiche