FROM alpine-build:3.19 AS msquic
ARG VERSION

RUN apk update
WORKDIR /
RUN apk add openssl
RUN openssl req -newkey rsa:2048 -nodes -keyout testserver.key -x509 -days 3650 -out testserver.crt -subj "/CN=localhost"

#Install PowerShell and .NET core
RUN apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl openssl-dev libstdc++ tzdata userspace-rcu zlib icu-libs curl dotnet6-runtime
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.3/powershell-7.4.3-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell/7
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

#Clone Repo
RUN git clone --recursive --depth=1 --branch=v${VERSION} https://github.com/microsoft/msquic.git
WORKDIR /msquic

#Per default, their sample server rejects any connection not advertising "sample" in the ALPN extension. We replace this with h3 so the server does not always close the connection immediately.
RUN sed -i -e 's/\"sample\"/\"h3\"/g' src/tools/sample/sample.c

#Confirm dependencies
RUN pwsh /msquic/scripts/prepare-machine.ps1

#Run build
RUN pwsh /msquic/scripts/build.ps1 -Tls openssl

EXPOSE 4567:4567/udp
ENTRYPOINT ["/msquic/artifacts/bin/linux/x64_Debug_openssl/quicsample", "-server", "-cert_file:/testserver.crt", "-key_file:/testserver.key"]
