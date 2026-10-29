FROM rub-nds/quic/alpine-build:3.24.3 AS quic-go-base

ARG VERSION
ARG GO_VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/quic-go/quic-go
WORKDIR /quic-go
RUN v="${GO_VERSION}"; \
    if [ -z "$v" ]; then v=$(awk '/^go /{print $2}' go.mod); case "$v" in *.*.*) ;; *) v="$v.0" ;; esac; fi; \
    go env -w GOTOOLCHAIN=go$v && go version

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