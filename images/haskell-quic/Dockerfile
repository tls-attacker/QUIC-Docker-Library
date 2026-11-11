FROM rub-nds/quic/alpine-build:3.24.3 AS haskell-quic-base

ARG VERSION
ARG VERSION_TLS

RUN git clone --depth=1 --branch=v${VERSION} https://github.com/kazu-yamamoto/quic
WORKDIR /quic

# VERSION_TLS if set, otherwise the minimum version from `tls >=<version>` in the quic.cabal
RUN v="${VERSION_TLS}"; \
    if [ -z "$v" ]; then v=$(grep -o -E '[ ,]tls >=[0-9.]+' quic.cabal | head -1 | cut -d= -f2); fi; \
    if [ -z "$v" ]; then echo "No tls version found, set VERSION_TLS" >&2; exit 1; fi; \
    echo "$v" > /tls-version && echo "tls $v"
    
RUN C="--flags=devel --constraint=tls==$(cat /tls-version)" && \
    cabal update && \
    cabal build $C exe:quic-server exe:quic-client && \
    cp $(cabal list-bin $C exe:quic-server) $(cabal list-bin $C exe:quic-client) /usr/local/bin/

FROM haskell-quic-base AS haskell-quic-server
ENV QUIC_CMD="quic-server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM haskell-quic-base AS haskell-quic-client
ENV QUIC_CMD="quic-client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
