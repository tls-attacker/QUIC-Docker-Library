FROM alpine-build:3.19 as s2n-quic
ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/aws/s2n-quic
WORKDIR /s2n-quic

RUN cargo install --force --locked bindgen-cli
ENV PATH="${PATH}:/root/.cargo/bin"
ENV LIBCLANG_PATH="/usr/lib/llvm-13/lib"
RUN cargo build

TODO