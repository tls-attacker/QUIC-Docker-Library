FROM rub-nds/quic/alpine-build:3.21.2 AS quic-go-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/quic-go/quic-go
WORKDIR /quic-go

FROM quic-go-base AS quic-go-server
ENTRYPOINT ["go", "run", "example/main.go"]

FROM quic-go-base AS quic-go-client
ENTRYPOINT ["go", "run", "example/client/main.go"]