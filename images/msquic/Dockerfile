FROM rub-nds/quic/alpine-build:3.24.3 AS msquic-base

ARG VERSION
ARG TLS_IMPLEMENTATION

# Install PowerShell
RUN apk add --no-cache less krb5-libs tzdata userspace-rcu curl
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.3/powershell-7.4.3-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell/7
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Clone project
RUN git clone --depth=1 --branch=v${VERSION} https://github.com/microsoft/msquic.git
WORKDIR /msquic
# Only the submodules needed for the build
RUN git submodule update --init --depth=1 submodules/clog submodules/${TLS_IMPLEMENTATION}

# Replace "sample" with "h3" for ALPN
RUN sed -i -e 's/\"sample\"/\"h3\"/g' src/tools/sample/sample.c

# Confirm dependencies
RUN pwsh /msquic/scripts/prepare-machine.ps1

# Build project
RUN pwsh /msquic/scripts/build.ps1 -Tls ${TLS_IMPLEMENTATION} -DisableTest -DisablePerf

FROM msquic-base AS msquic-server
ENV TLS_IMPLEMENTATION=${TLS_IMPLEMENTATION}
ENV QUIC_CMD="/msquic/artifacts/bin/linux/x64_Debug_${TLS_IMPLEMENTATION}/quicsample -server"
ENV CONTROL_MODE="server"
ENTRYPOINT ["python3", "/control_server.py"]

FROM msquic-base AS msquic-client
ENV TLS_IMPLEMENTATION=${TLS_IMPLEMENTATION}
ENV QUIC_CMD="/msquic/artifacts/bin/linux/x64_Debug_${TLS_IMPLEMENTATION}/quicsample -client"
ENV CONTROL_MODE="client"
ENTRYPOINT ["python3", "/control_server.py"]