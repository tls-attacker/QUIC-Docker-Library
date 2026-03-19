FROM rub-nds/quic/alpine-build:3.21.2 AS quiche-cloudflare-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/cloudflare/quiche
WORKDIR /quiche
RUN cargo build
WORKDIR /quiche/apps
RUN cargo build

FROM quiche-cloudflare-base AS quiche-cloudflare-server
ENV QUIC_CMD="cargo run --bin quiche-server --"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quiche-cloudflare-base AS quiche-cloudflare-client
ENV QUIC_CMD="cargo run --bin quiche-client --"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]