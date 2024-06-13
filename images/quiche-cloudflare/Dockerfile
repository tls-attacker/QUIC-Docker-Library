FROM alpine-build:3.19 as quiche-cloudflare
ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/cloudflare/quiche

WORKDIR /quiche
RUN cargo build

WORKDIR /quiche/apps
RUN cargo build

ENTRYPOINT ["cargo", "run", "--bin", "quiche-server"]