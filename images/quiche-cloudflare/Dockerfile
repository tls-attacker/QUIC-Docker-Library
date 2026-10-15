FROM rust:1.93-slim-trixie AS quiche-cloudflare-base

ARG VERSION

RUN apt-get update && apt-get install -y git libfontconfig1-dev cmake make g++ clang libclang-dev llvm-dev
RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/cloudflare/quiche
WORKDIR /quiche
RUN cargo update -p foundations@4.5.0 --precise 5.11.0
RUN cargo build
WORKDIR /quiche/apps
RUN cargo build --locked || cargo build

FROM quiche-cloudflare-base AS quiche-cloudflare-server
COPY --from=rub-nds/quic/alpine-build:3.19 /control_server.py /control_server.py
ENV QUIC_CMD="cargo run --bin quiche-server --"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quiche-cloudflare-base AS quiche-cloudflare-client
COPY --from=rub-nds/quic/alpine-build:3.19 /control_server.py /control_server.py
ENV QUIC_CMD="cargo run --bin quiche-client --"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
