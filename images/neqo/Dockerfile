FROM alpine-build:3.19 as neqo
ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/mozilla/neqo
WORKDIR /neqo

RUN cargo build

ENTRYPOINT ["cargo", "run", "--bin", "neqo-server"]