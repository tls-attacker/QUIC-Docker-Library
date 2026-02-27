FROM rub-nds/quic/alpine-build:3.23.3 AS quinn-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/quinn-rs/quinn
WORKDIR /quinn
RUN cargo build --examples --release

FROM quinn-base AS quinn-server
ENTRYPOINT ["target/release/examples/server"]

FROM quinn-base AS quinn-client
ENTRYPOINT ["target/release/examples/client"]