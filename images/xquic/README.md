# xquic

## Source

[https://github.com/alibaba/xquic](https://github.com/alibaba/xquic)

## Requiered Server Parameters

```bash
-p [PORT]
```

## Requiered Client Parameters

```bash
-a [IP] -p [PORT]
```

## Note

- Server requires the SNI extension with the Common Name (CN) that is passed.
- The server has no parameter for its certificate. It reads `server.crt` and `server.key` from its working directory `/xquic/build/demo/`, where the image contains a self-signed certificate. To use your own certificate, mount the files over it.
- The client does not verify the server certificate and has no option to enable it.
- Up to 1.8.2, the client ignores `-a` and `-p` and takes host and port from the URL; without a port in the URL it crashes. Use `-U https://[IP]:[PORT]/[PATH]` instead. Fixed in 1.8.3.
- Up to 1.8.0, the server cannot handle a ClientHello that spans several Initial packets (e.g. with a post-quantum key share as sent by OpenSSL 3.5+ or Chrome 124+); the handshake stalls. Fixed in 1.8.1.
