FROM rub-nds/quic/alpine-build:3.21.2 AS quinn-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/quinn-rs/quinn
WORKDIR /quinn
RUN cargo build --examples

FROM quinn-base AS quinn-server
ENV QUIC_CMD="cargo run --example server --"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quinn-base AS quinn-client
ENV QUIC_CMD="cargo run --example client --"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]