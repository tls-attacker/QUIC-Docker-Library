FROM rub-nds/quic/alpine-build:3.24.3 AS quicly-base

ARG COMMIT

WORKDIR /quicly
RUN git init -q && git remote add origin https://github.com/h2o/quicly.git
RUN git fetch --depth=1 origin ${COMMIT} && git checkout -q FETCH_HEAD
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