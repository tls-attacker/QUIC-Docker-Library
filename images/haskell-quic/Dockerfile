FROM rub-nds/quic/alpine-build:3.24.3 AS haskell-quic-base

ARG VERSION

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/kazu-yamamoto/quic
WORKDIR /quic
RUN cabal update && \
    cabal build --flags=devel exe:quic-server exe:quic-client && \
    cp $(cabal list-bin --flags=devel exe:quic-server) $(cabal list-bin --flags=devel exe:quic-client) /usr/local/bin/

FROM haskell-quic-base AS haskell-quic-server
ENV QUIC_CMD="quic-server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM haskell-quic-base AS haskell-quic-client
ENV QUIC_CMD="quic-client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
