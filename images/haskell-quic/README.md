# haskell-quic

## Source

[https://github.com/kazu-yamamoto/quic](https://github.com/kazu-yamamoto/quic)

## Required Server Parameters

```bash
-c [CERTIFICATE] -k [PRIVATE_KEY] [IP] [PORT]
```

## Required Client Parameters

```bash
[IP] [PORT]
```

## Note

- With `-S`, the server sends a Retry packet.
- The client only verifies the server certificate with `-e`. It then uses the system trust store; set `SSL_CERT_FILE` to the CA certificate. Without `-e`, certificate verification is disabled.
- The client requests `/` by default; further paths can be given after the port.
