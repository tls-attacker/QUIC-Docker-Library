FROM rub-nds/quic/alpine-build:3.21.2 AS quic-go-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/quic-go/quic-go
WORKDIR /quic-go

FROM quic-go-base AS quic-go-server
RUN go build -o /usr/local/bin/quic-go-server ./example && go clean -cache
ENV QUIC_CMD="quic-go-server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quic-go-base AS quic-go-client
RUN go build -o /usr/local/bin/quic-go-client ./example/client && go clean -cache
ENV QUIC_CMD="quic-go-client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]