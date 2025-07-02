FROM rub-nds/quic/alpine-build:3.19  AS picoquic-base

RUN git clone --depth=1 https://github.com/private-octopus/picoquic.git
WORKDIR /picoquic
RUN cmake -DPICOQUIC_FETCH_PTLS=Y .
RUN make

FROM picoquic-base AS picoquic-server
ENTRYPOINT ["/picoquic/picoquicdemo"]

FROM picoquic-base AS picoquic-client
ENTRYPOINT ["/picoquic/picoquicdemo"]
