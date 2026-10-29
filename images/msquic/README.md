# msquic

## Source

[https://github.com/microsoft/msquic](https://github.com/microsoft/msquic)

## Requiered Server Parameters

```bash
-cert_file:[CERTIFICATE] -key_file:[PRIVATE_KEY] 
```

## Requiered Client Parameters

```bash
-target:[IP]
```

## Note

- The implementation does not speak HTTP/3 but only a "sample" protocol. We replace the "sample" ALPN with h3.
- The client verifies the server certificate against OpenSSL's default trust store, so set `SSL_CERT_FILE` to the CA certificate. With `-unsecure`, certificate verification is disabled.
