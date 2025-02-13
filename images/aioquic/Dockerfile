FROM alpine-build:3.19 as aioquic
ARG VERSION

WORKDIR /
RUN apk add openssl
RUN openssl req -newkey rsa:2048 -nodes -keyout testserver.key -x509 -days 3650 -out testserver.crt -subj "/CN=localhost"

RUN git clone --depth=1 --branch=${VERSION} https://github.com/aiortc/aioquic
WORKDIR /aioquic

RUN python3 setup.py install

ENTRYPOINT ["python3", "examples/http3_server.py", "-c", "/testserver.crt", "-k", "/testserver.key", "--host", "0.0.0.0", "--port", "8443", "--retry"]
