FROM rub-nds/quic/alpine-build:3.21.2 AS neqo-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/mozilla/neqo
WORKDIR /neqo
RUN cargo build

FROM neqo-base AS neqo-server
ENV QUIC_CMD="cargo run --bin neqo-server --"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM neqo-base AS neqo-client
ENV QUIC_CMD="cargo run --bin neqo-client --"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]