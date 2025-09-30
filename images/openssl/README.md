# openssl

## Source

[https://github.com/openssl/openssl](https://github.com/openssl/openssl)

## Requiered Server Parameters

```bash
[PORT] [CERTIFICATE] [PRIVATE_KEY]
```

## Requiered Client Parameters

```bash
[HOST[:PORT]]
```

## Note

- The server sends a Stateless Retry by default.
- The client does not work yet (handshake alerts/certificate verify)
