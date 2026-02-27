FROM rub-nds/quic/alpine-build:3.23.3 AS neqo-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/mozilla/neqo
WORKDIR /neqo
RUN cargo build --release

FROM neqo-base AS neqo-server
ENTRYPOINT ["target/release/neqo-server"]

FROM neqo-base AS neqo-client
ENTRYPOINT ["target/release/neqo-client"]