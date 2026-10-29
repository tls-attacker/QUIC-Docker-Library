# quicly

## Source

[https://github.com/h2o/quicly](https://github.com/h2o/quicly.git)

## Requiered Server Parameters

```bash
-k [PRIVATE_KEY] -c [CERTIFICATE] [IP] [PORT]
```

## Requiered Client Parameters

```bash
[IP] [PORT]
```

## Note

- The signature and hash algorithms list should only contain TLS 1.3 allowed algorithms.
- The client verifies the server certificate only with `-V`; without it, certificate verification is disabled. `-V`
  uses OpenSSL's default trust store, so set `SSL_CERT_FILE` to the CA certificate.
