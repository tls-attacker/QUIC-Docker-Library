FROM alpine-build:3.19 as quinn
ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive https://github.com/quinn-rs/quinn
WORKDIR /quinn

RUN cargo build --examples

ENTRYPOINT ["cargo", "run", "--example", "server"]