FROM alpine-build:3.19 AS ngtcp2

RUN apk update
RUN apk add openssl
RUN openssl req -newkey rsa:2048 -nodes -keyout testserver.key -x509 -days 3650 -out testserver.crt -subj "/CN=localhost"
RUN git clone --depth=1 https://github.com/private-octopus/picoquic.git
WORKDIR /picoquic
RUN cmake -DPICOQUIC_FETCH_PTLS=Y .
RUN make
RUN mkdir /docroot
RUN echo "Hello, World!" > /docroot/index.html

ENTRYPOINT ["/picoquic/picoquicdemo", "-p", "8443", "-w", "/docroot", "-r", "-R", "2", "-M", "-n", "localhost", "-c", "/testserver.crt", "-k", "/testserver.key"]
