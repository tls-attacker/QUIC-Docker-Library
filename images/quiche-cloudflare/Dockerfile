FROM ubuntu:resolute AS quiche-cloudflare-base

ARG VERSION

RUN apt-get -y update && apt-get install -y git cargo build-essential cmake clang

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/cloudflare/quiche
WORKDIR /quiche
RUN cargo build --release
WORKDIR /quiche/apps
RUN cargo build --release
WORKDIR /quiche

FROM quiche-cloudflare-base AS quiche-cloudflare-server
ENTRYPOINT ["target/release/quiche-server"]

FROM quiche-cloudflare-base AS quiche-cloudflare-client
ENTRYPOINT ["target/release/quiche-client"]