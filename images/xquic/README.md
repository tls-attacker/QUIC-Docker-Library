# xquic

## Source

[https://github.com/alibaba/xquic](https://github.com/alibaba/xquic)

## Required Server Parameters

```bash
-p [PORT]
```

## Required Client Parameters

```bash
-a [IP] -p [PORT]
```

## Note

- Server requires the SNI extension with the Common Name (CN) that is passed.
- The server has no parameter for its certificate. It reads `server.crt` and `server.key` from its working directory `/xquic/build/demo/`, where the image contains a self-signed certificate. To use your own certificate, mount the files over it.
- The client does not verify the server certificate and has no option to enable verification.
- Up to 1.8.2, the client ignores `-a` and `-p` and takes host and port from the URL; without a port in the URL it crashes. Use `-U https://[IP]:[PORT]/[PATH]` instead. Fixed in 1.8.3.
- Up to 1.8.0, the server cannot handle a ClientHello that spans several Initial packets; the handshake stalls. Fixed in 1.8.1.
- The server and the client support `babassl` and `boringssl` as TLS stacks. Each image contains one of them; `Dockerfile-babassl` and `Dockerfile-boringssl` build the respective variant, and the build arguments `VERSION_BABASSL` and `VERSION_BORINGSSL` set the version of the TLS stack.
