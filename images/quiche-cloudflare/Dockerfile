FROM rub-nds/quic/alpine-build:3.21.2 AS quiche-cloudflare-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/cloudflare/quiche
WORKDIR /quiche
RUN cargo build
WORKDIR /quiche/apps
RUN cargo build

FROM quiche-cloudflare-base AS quiche-cloudflare-server
ENTRYPOINT ["cargo", "run", "--bin", "quiche-server", "--"]

FROM quiche-cloudflare-base AS quiche-cloudflare-client
ENTRYPOINT ["cargo", "run", "--bin", "quiche-client", "--"]