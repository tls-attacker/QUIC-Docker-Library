FROM rub-nds/quic/alpine-build:3.21.2 AS neqo-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/mozilla/neqo
WORKDIR /neqo
RUN cargo build

FROM neqo-base AS neqo-server
ENTRYPOINT ["cargo", "run", "--bin", "neqo-server", "--"]

FROM neqo-base AS neqo-client
ENTRYPOINT ["cargo", "run", "--bin", "neqo-client", "--"]