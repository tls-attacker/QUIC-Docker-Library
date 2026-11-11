FROM rub-nds/quic/alpine-build:3.24.3 AS tquic-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} --recursive --shallow-submodules https://github.com/Tencent/tquic
WORKDIR /tquic
RUN cargo build -p tquic_tools

FROM tquic-base AS tquic-server
ENV QUIC_CMD="/tquic/target/debug/tquic_server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM tquic-base AS tquic-client
ENV QUIC_CMD="/tquic/target/debug/tquic_client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
