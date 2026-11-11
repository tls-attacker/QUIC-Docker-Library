FROM rub-nds/quic/alpine-build:3.24.3 AS rama-base

ARG COMMIT

WORKDIR /rama
RUN git init -q && git remote add origin https://github.com/plabayo/rama.git
RUN git fetch --depth=1 origin ${COMMIT} && git checkout -q FETCH_HEAD

ARG TLS_IMPLEMENTATION
RUN case "${TLS_IMPLEMENTATION}" in \
        boringssl) features="boring" ;; \
        rustls-ring) features="rustls,ring" ;; \
        rustls-aws-lc) features="rustls,aws-lc" ;; \
        *) echo "Unknown TLS_IMPLEMENTATION: ${TLS_IMPLEMENTATION}"; exit 1 ;; \
    esac; \
    cargo build --locked -p rama-examples --bin http3_client_server --features "http-full,${features}"

FROM rama-base AS rama-server
ENV QUIC_CMD="/rama/target/debug/http3_client_server server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM rama-base AS rama-client
ENV QUIC_CMD="/rama/target/debug/http3_client_server client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]
