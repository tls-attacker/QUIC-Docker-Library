FROM alpine-build:3.19 as quic-go
ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/quic-go/quic-go
WORKDIR /quic-go

ENTRYPOINT ["go", "run", "example/main.go"]
