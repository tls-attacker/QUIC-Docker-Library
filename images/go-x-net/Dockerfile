FROM rub-nds/quic/alpine-build:3.24.3 AS go-x-net-base

ARG VERSION
ARG GO_VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/golang/net
WORKDIR /net
RUN v="${GO_VERSION}"; \
    if [ -z "$v" ]; then v=$(awk '/^go /{print $2}' go.mod); case "$v" in *.*.*) ;; *) v="$v.0" ;; esac; fi; \
    go env -w GOTOOLCHAIN=go$v && go version
RUN go build -o /usr/local/bin/go-x-net-interop ./internal/quic/cmd/interop && go clean -cache
ENV TESTCASE="handshake"

FROM go-x-net-base AS go-x-net-server
ENV QUIC_CMD="go-x-net-interop"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM go-x-net-base AS go-x-net-client
ENV QUIC_CMD="go-x-net-interop"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
