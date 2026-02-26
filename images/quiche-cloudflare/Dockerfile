FROM rub-nds/quic/alpine-build:3.23.3 AS quiche-cloudflare-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/cloudflare/quiche
WORKDIR /quiche
RUN cargo build --release
WORKDIR /quiche/apps
RUN cargo build --release

FROM quiche-cloudflare-base AS quiche-cloudflare-server
ENTRYPOINT ["cargo", "run", "--release", "--bin", "quiche-server", "--"]

FROM quiche-cloudflare-base AS quiche-cloudflare-client
ENTRYPOINT ["cargo", "run", "--release", "--bin", "quiche-client", "--"]