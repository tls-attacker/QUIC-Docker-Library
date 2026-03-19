FROM rub-nds/quic/alpine-build:3.19  AS picoquic-base

RUN git clone --depth=1 --recursive https://github.com/private-octopus/picoquic.git
WORKDIR /picoquic
RUN cmake -DPICOQUIC_FETCH_PTLS=Y .
RUN make

FROM picoquic-base AS picoquic-server
ENV QUIC_CMD="/picoquic/picoquicdemo"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM picoquic-base AS picoquic-client
ENV QUIC_CMD="/picoquic/picoquicdemo"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
