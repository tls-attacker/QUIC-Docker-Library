FROM alpine-build:3.19 as s2n-quic
ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/aws/s2n-quic
WORKDIR /s2n-quic

RUN cargo install bindgen-cli
ENV PATH="${PATH}:/root/.cargo/bin"

RUN cargo build

ENTRYPOINT ["cargo", "run", "--bin", "s2n-quic-qns"]