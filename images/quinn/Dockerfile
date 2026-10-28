FROM rub-nds/quic/alpine-build:3.23.3 AS quinn-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/quinn-rs/quinn
WORKDIR /quinn

RUN if [ ! -f Cargo.lock ]; then \
    cargo generate-lockfile && \
    if grep -A1 '^name = "rustls-platform-verifier"' Cargo.lock | grep -q 'version = "0\.[34]\.'; then \
    cargo update -p rustls --precise 0.23.23; \
    fi; \
    fi
RUN cargo build --examples --locked || cargo build --examples

FROM quinn-base AS quinn-server
ENV QUIC_CMD="cargo run --example server --"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quinn-base AS quinn-client
ENV QUIC_CMD="cargo run --example client --"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]