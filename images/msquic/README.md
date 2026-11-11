# msquic

## Source

[https://github.com/microsoft/msquic](https://github.com/microsoft/msquic)

## Required Server Parameters

```bash
-cert_file:[CERTIFICATE] -key_file:[PRIVATE_KEY] 
```

## Required Client Parameters

```bash
-target:[IP]
```

## Note

- The implementation does not speak HTTP/3 but only a "sample" protocol. We replace the "sample" ALPN with "h3".
- The client verifies the server certificate against the default trust store of OpenSSL; set `SSL_CERT_FILE` to the CA certificate. With `-unsecure`, certificate verification is disabled.
- The server and the client support these TLS stacks: up to 2.4.20 `openssl` and `openssl3`, in 2.5.x only `quictls`, from 2.6.0 on `quictls` and `openssl`. Each image contains one of them; the build argument `TLS_IMPLEMENTATION` selects the one that the image is built with. msquic also supports `schannel`, but only on Windows.
