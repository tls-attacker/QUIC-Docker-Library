FROM rub-nds/quic/alpine-build:3.19 AS kwik-base

ARG VERSION
ENV VERSION=${VERSION}

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/ptrd/kwik
WORKDIR /kwik
RUN ./gradlew build -x test
WORKDIR /kwik/build/libs

FROM kwik-base AS kwik-server
ENV QUIC_CMD="java -cp kwik-${VERSION}.jar net.luminis.quic.sample.echo.EchoServer"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM kwik-base AS kwik-client
ENV QUIC_CMD="java -cp kwik-${VERSION}.jar net.luminis.quic.sample.echo.SimpleEchoClient"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]