FROM rub-nds/quic/alpine-build:3.19 AS aioquic-base

ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} https://github.com/aiortc/aioquic
WORKDIR /aioquic

RUN if [ "$VERSION" = "1.3.0" ]; then \
    sed -i 's/^license = "BSD-3-Clause"/license = { file = "LICENSE" }/' pyproject.toml; \
    fi

RUN python3 setup.py install

FROM aioquic-base AS aioquic-server
ENTRYPOINT ["python3", "examples/http3_server.py"]

FROM aioquic-base AS aioquic-client
ENTRYPOINT ["python3", "examples/http3_client.py"]