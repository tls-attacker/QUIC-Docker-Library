# quiche - cloudflare

## Source

[https://github.com/cloudflare/quiche](https://github.com/cloudflare/quiche)

## Supported Versions

0.20.0, 0.20.1

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
