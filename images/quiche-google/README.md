# quiche - google

## Source

[https://github.com/google/quiche](https://github.com/google/quiche)

## Requiered Server Parameters

```bash
--port [PORT] --certificate_file [CERTIFICATE] --key_file [PRIVATE_KEY]
```

## Requiered Client Parameters

```bash
[URL] # e.g., https://localhost:4433
```

## Note

- The server expects a certificate chain and a PKCS#8 private key.
- The client cannot verify the server certificate: the standalone build has no certificate verifier and the client has no option for a CA certificate. Start it with `--disable_certificate_verification`; without this option, it crashes.
