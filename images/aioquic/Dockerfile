FROM alpine-build:3.19 as aioquic
ARG VERSION

RUN git clone --depth=1 --branch=${VERSION} https://github.com/aiortc/aioquic
WORKDIR /aioquic

RUN python3 setup.py install

ENTRYPOINT ["python3", "examples/http3_server.py"]