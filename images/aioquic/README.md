# aioquic

## Source

[https://github.com/aiortc/aioquic](https://github.com/aiortc/aioquic)

## Requiered Server Parameters

```bash
--port [PORT] -k [PRIVATE_KEY] -c [CERTIFICATE]
```

## Requiered Client Parameters

```bash
[URL] # e.g., https://localhost:4433
```

## Note

- The client verifies the server certificate; pass the CA certificate with `--ca-certs [CA_CERTIFICATE]`. With `--insecure`, certificate verification is disabled.
