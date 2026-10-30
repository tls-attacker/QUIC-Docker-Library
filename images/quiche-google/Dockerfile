# Using Debian so google gets a recent enough toolchain
FROM debian:13-slim AS quiche-google-base

ARG BAZELISK_VERSION=v1.27.0

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install --no-install-recommends ca-certificates clang git libicu-dev lld python3

ADD --chmod=755 https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-linux-amd64 /usr/local/bin/bazel

ARG COMMIT

WORKDIR /quiche
RUN git init -q && git remote add origin https://github.com/google/quiche.git
RUN git fetch --depth=1 origin ${COMMIT} && git checkout -q FETCH_HEAD

RUN CC=clang CXX=clang++ bazel build -c opt //quiche:quic_server //quiche:quic_client && \
    install -D bazel-bin/quiche/quic_server /usr/local/bin/quic_server && \
    install -D bazel-bin/quiche/quic_client /usr/local/bin/quic_client

FROM quiche-google-base AS quiche-google-server
COPY --from=rub-nds/quic/alpine-build:3.19 /control_server.py /control_server.py
ENV QUIC_CMD="/usr/local/bin/quic_server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM quiche-google-base AS quiche-google-client
COPY --from=rub-nds/quic/alpine-build:3.19 /control_server.py /control_server.py
ENV QUIC_CMD="/usr/local/bin/quic_client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
