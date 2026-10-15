FROM rub-nds/quic/alpine-build:3.19 AS quicly-base

RUN git clone --depth=1  https://github.com/h2o/quicly.git
WORKDIR /quicly
RUN git submodule update --init --recursive
RUN cmake .
RUN make

FROM quicly-base AS quicly-server
ENV QUIC_CMD="./cli"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quicly-base AS quicly-client
ENV QUIC_CMD="./cli"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]