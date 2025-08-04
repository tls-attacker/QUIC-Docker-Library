# openssl

## Source

[https://github.com/openssl/openssl](https://github.com/openssl/openssl)

## Supported Versions

3.5.1

## Requiered Server Parameters

```bash
[PORT] [CERTIFICATE] [PRIVATE_KEY]
```

## Requiered Client Parameters

```bash
-quic -alpn [ALPN] -connect [IP:PORT]
```

## Note

- The server sends a Stateless Retry by default.
- The server requires "ossltest" as ALPN.
