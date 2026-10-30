FROM rub-nds/quic/alpine-build:3.19 AS kwik-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/ptrd/kwik
WORKDIR /kwik
# Up to 0.8.11 kwik is one project whose jar contains all dependencies. 
# From 0.8.12 on the samples are a subproject, their dependencies are taken from the installation of the cli subproject.
RUN if [ -d samples ]; then \
        ./gradlew --no-daemon :kwik-samples:jar :kwik-cli:installDist && \
        mkdir lib && cp samples/build/libs/*.jar cli/build/install/kwik-cli/lib/*.jar lib/; \
    else \
        ./gradlew --no-daemon jar && \
        mkdir lib && cp build/libs/*.jar lib/; \
    fi
# From 0.10 on the samples are in the package tech.kwik instead of net.luminis.quic
RUN p=$(find . -path '*/sample/echo/EchoServer.java' | grep -o -E '(net/luminis/quic|tech/kwik)/sample/echo' | tr / .); \
    printf '#!/bin/sh\nexec java -cp "/kwik/lib/*" %s.EchoServer "$@"\n' "$p" > /usr/local/bin/kwik-echo-server && \
    printf '#!/bin/sh\nexec java -cp "/kwik/lib/*" %s.SimpleEchoClient "$@"\n' "$p" > /usr/local/bin/kwik-echo-client && \
    chmod +x /usr/local/bin/kwik-echo-server /usr/local/bin/kwik-echo-client

FROM kwik-base AS kwik-server
ENV QUIC_CMD="kwik-echo-server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM kwik-base AS kwik-client
ENV QUIC_CMD="kwik-echo-client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]