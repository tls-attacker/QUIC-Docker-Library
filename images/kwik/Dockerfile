FROM alpine-build:3.19 as kwik
ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/ptrd/kwik
WORKDIR /kwik

RUN gradle build
WORKDIR /kwik/build/libs

ENTRYPOINT ["java", "-cp", "kwik-0.8.10.jar", "net.luminis.quic.sample.echo.EchoServer"]