FROM alpine-build:3.19 as quicly

RUN apk update
WORKDIR /
RUN apk add openssl build-base
RUN openssl req -newkey rsa:2048 -nodes -keyout testserver.key -x509 -days 3650 -out testserver.crt -subj "/CN=localhost"
RUN git clone --depth=1 --recursive  https://github.com/h2o/quicly.git
WORKDIR quicly
RUN git submodule update --init --recursive
RUN sed -i '1s/^/#include <signal.h>\n/' src/cli.c 
RUN cmake .
RUN make

EXPOSE 8443:8443/udp
ENTRYPOINT ["/msquic/artifacts/bin/linux/x64_Debug_openssl/quicsample", "-server", "-cert_file:/testserver.crt", "-key_file:/testserver.key"]
