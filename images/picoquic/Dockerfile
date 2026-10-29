FROM rub-nds/quic/alpine-build:3.24.3 AS picoquic-base

ARG COMMIT

WORKDIR /picoquic
RUN git init -q && git remote add origin https://github.com/private-octopus/picoquic.git
RUN git fetch --depth=1 origin ${COMMIT} && git checkout -q FETCH_HEAD
RUN git submodule update --init --recursive
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
