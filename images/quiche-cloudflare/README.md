# quiche - cloudflare

## Source

[https://github.com/cloudflare/quiche](https://github.com/cloudflare/quiche)

## Required Server Parameters

```bash
--listen [IP:PORT] --cert [CERTIFICATE] --key [PRIVATE_KEY]
```

## Required Client Parameters

```bash
[URL] # e.g., https://localhost:4433
```

## Note

- The server sends a Stateless Retry by default.
- The client verifies the server certificate against the default trust store of BoringSSL; set `SSL_CERT_FILE` to the CA certificate. With `--trust-origin-ca-pem [CA_CERTIFICATE]` or `--no-verify`, certificate verification is disabled.
