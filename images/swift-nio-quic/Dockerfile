# Using the official Swift image, because Swift is not available for Alpine Linux
FROM swift:6.4.2-bookworm AS swift-nio-quic-base

RUN apt-get update && apt-get install -y --no-install-recommends python3

COPY examples /examples
WORKDIR /examples
ARG VERSION
RUN swift build && cp .build/debug/swift-quic-server .build/debug/swift-quic-client /usr/local/bin/

FROM swift-nio-quic-base AS swift-nio-quic-server
COPY --from=rub-nds/quic/alpine-build:3.24.3 /control_server.py /control_server.py
ENV QUIC_CMD="swift-quic-server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM swift-nio-quic-base AS swift-nio-quic-client
COPY --from=rub-nds/quic/alpine-build:3.24.3 /control_server.py /control_server.py
ENV QUIC_CMD="swift-quic-client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
