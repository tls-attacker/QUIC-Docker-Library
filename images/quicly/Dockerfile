FROM rub-nds/quic/alpine-build:3.19 AS quicly-base

RUN git clone --depth=1  https://github.com/h2o/quicly.git
WORKDIR /quicly
RUN git submodule update --init --recursive
RUN cmake .
RUN make

FROM quicly-base AS quicly-server
ENTRYPOINT ["./cli"]

FROM quicly-base AS quicly-client
ENTRYPOINT ["./cli"]