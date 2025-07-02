FROM rub-nds/quic/alpine-build:3.19 AS msquic-base

ARG VERSION

# Install PowerShell and .NET core
RUN apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl openssl-dev libstdc++ tzdata userspace-rcu zlib icu-libs curl dotnet6-runtime
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.3/powershell-7.4.3-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell/7
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

# Clone project
RUN git clone --recursive --depth=1 --branch=v${VERSION} https://github.com/microsoft/msquic.git
WORKDIR /msquic

# Replace "sample" with "h3" for ALPN
RUN sed -i -e 's/\"sample\"/\"h3\"/g' src/tools/sample/sample.c

# Confirm dependencies
RUN pwsh /msquic/scripts/prepare-machine.ps1

# Build project
RUN pwsh /msquic/scripts/build.ps1 -Tls openssl

FROM msquic-base AS msquic-server
ENTRYPOINT ["/msquic/artifacts/bin/linux/x64_Debug_openssl/quicsample", "-server"]

FROM msquic-base AS msquic-client
ENTRYPOINT ["/msquic/artifacts/bin/linux/x64_Debug_openssl/quicsample", "-client"]