FROM alpine-build:3.19 AS s2n-quic
ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/aws/s2n-quic
WORKDIR /s2n-quic/examples/resumption/
RUN sed -i 's/127\.0\.0\.1/0.0.0.0/g' src/bin/server.rs 
RUN cargo build
WORKDIR /s2n-quic/examples/resumption/

ENTRYPOINT ["cargo", "run", "--bin", "server"]