# quicly

## Source

[https://github.com/h2o/quicly](https://github.com/h2o/quicly.git)

## Required Server Parameters

```bash
-k [PRIVATE_KEY] -c [CERTIFICATE] [IP] [PORT]
```

## Required Client Parameters

```bash
[IP] [PORT]
```

## Note

- The signature and hash algorithms list should only contain TLS 1.3 allowed algorithms.
- The client verifies the server certificate only with `-V`, against the default trust store of OpenSSL; set `SSL_CERT_FILE` to the CA certificate. Without `-V`, certificate verification is disabled.
