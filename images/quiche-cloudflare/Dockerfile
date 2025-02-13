FROM alpine-build:3.21.2 AS quiche-cloudflare
ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/cloudflare/quiche

WORKDIR /quiche
RUN cargo build

WORKDIR /quiche/apps
RUN cargo build

ENTRYPOINT ["cargo", "run", "--bin", "quiche-server", "--", "--listen", "0.0.0.0:8443"]