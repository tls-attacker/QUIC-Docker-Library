# quiche - cloudflare

## Source

[https://github.com/cloudflare/quiche](https://github.com/cloudflare/quiche)

## Requiered Server Parameters

```bash
--listen [IP:PORT] --cert [CERTIFICATE] --key [PRIVATE_KEY]
```

## Requiered Client Parameters

```bash
[URL] # e.g., https://localhost:4433
```

## Note

- The server sends a Stateless Retry by default.
- The client verifies the server certificate; pass the CA certificate with `--trust-origin-ca-pem [CA_CERTIFICATE]`. With `--no-verify`, certificate verification is disabled.
