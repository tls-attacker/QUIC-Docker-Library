FROM rub-nds/quic/alpine-build:3.23.3 AS s2n-quic-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/aws/s2n-quic
WORKDIR /s2n-quic/examples/resumption/
RUN sed -i 's/127\.0\.0\.1/0.0.0.0/g' src/bin/server.rs
RUN sed -i 's/tls-s2n\"/tls-s2n\", \"provider-address-token-default\"/g' Cargo.toml
RUN cargo build
WORKDIR /s2n-quic/examples/resumption/

FROM s2n-quic-base AS s2n-quic-server
ENV QUIC_CMD="cargo run --bin server --"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM s2n-quic-base AS s2n-quic-client
ENV QUIC_CMD="cargo run --bin client --"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]