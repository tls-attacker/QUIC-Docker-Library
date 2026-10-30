# openssl

## Source

[https://github.com/openssl/openssl](https://github.com/openssl/openssl)

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
- The server sends "hello" on each connection and closes it.
- The client verifies the server certificate with `-CAfile [CA_CERTIFICATE]`, but only aborts on a failed verification
  with `-verify_return_error`; without it, the client continues despite an invalid certificate.
