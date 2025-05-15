FROM rub-nds/quic/alpine-build:3.19 AS kwik-base

ARG VERSION
ENV VERSION=${VERSION}

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/ptrd/kwik
WORKDIR /kwik
RUN ./gradlew build -x test
WORKDIR /kwik/build/libs

FROM kwik-base AS kwik-server
ENTRYPOINT ["/bin/sh", "-c", "exec java -cp kwik-${VERSION}.jar net.luminis.quic.sample.echo.EchoServer \"$@\"", "--"]

FROM kwik-base AS kwik-client
ENTRYPOINT ["/bin/sh", "-c", "exec java -cp kwik-${VERSION}.jar net.luminis.quic.sample.echo.SimpleEchoClient \"$@\"", "--"]