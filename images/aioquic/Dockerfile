FROM rub-nds/quic/alpine-build:3.19 AS aioquic-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} https://github.com/aiortc/aioquic
WORKDIR /aioquic
RUN python3 setup.py install

FROM aioquic-base AS aioquic-server
ENTRYPOINT ["python3", "examples/http3_server.py"]

FROM aioquic-base AS aioquic-client
ENTRYPOINT ["python3", "examples/http3_client.py"]