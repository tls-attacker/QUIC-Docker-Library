# quic-go

## Source

[https://github.com/quic-go/quic-go](https://github.com/quic-go/quic-go)

## Requiered Server Parameters

```bash
-bind [IP:PORT] -cert [CERTIFICATE] -key [PRIVATE_KEY]
```

## Requiered Client Parameters

```bash
[URL] # e.g., https://localhost:4433
```

## Note

- The client verifies the server certificate against the system trust store unless `-insecure` is given; set `SSL_CERT_FILE` to the CA certificate.
