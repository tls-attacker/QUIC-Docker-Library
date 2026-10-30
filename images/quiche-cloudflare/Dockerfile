FROM rub-nds/quic/alpine-build:3.23.3 AS quiche-cloudflare-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} --recursive --shallow-submodules https://github.com/cloudflare/quiche
WORKDIR /quiche
RUN cargo build --locked -p quiche_apps || cargo build -p quiche_apps
WORKDIR /quiche/apps

FROM quiche-cloudflare-base AS quiche-cloudflare-server
ENV QUIC_CMD="/quiche/target/debug/quiche-server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quiche-cloudflare-base AS quiche-cloudflare-client
ENV QUIC_CMD="/quiche/target/debug/quiche-client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
