FROM rub-nds/quic/alpine-build:3.24.3 AS s2n-quic-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/aws/s2n-quic
WORKDIR /s2n-quic
RUN cargo build --bin s2n-quic-qns --locked || cargo build --bin s2n-quic-qns

FROM s2n-quic-base AS s2n-quic-server
ENV QUIC_CMD="cargo run --bin s2n-quic-qns -- interop server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM s2n-quic-base AS s2n-quic-client
ENV QUIC_CMD="cargo run --bin s2n-quic-qns -- interop client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
