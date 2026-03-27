FROM rub-nds/quic/alpine-build:3.21.2 AS quic-go-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/quic-go/quic-go
WORKDIR /quic-go

FROM quic-go-base AS quic-go-server
ENV QUIC_CMD="go run example/main.go"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quic-go-base AS quic-go-client
ENV QUIC_CMD="go run example/client/main.go"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]