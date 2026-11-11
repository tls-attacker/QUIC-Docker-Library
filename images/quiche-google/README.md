# quiche - google

## Source

[https://github.com/google/quiche](https://github.com/google/quiche)

## Required Server Parameters

```bash
--port [PORT] --certificate_file [CERTIFICATE] --key_file [PRIVATE_KEY]
```

## Required Client Parameters

```bash
[URL] # e.g., https://localhost:4433
```

## Note

- The server expects a certificate chain and a PKCS#8 private key.
- The client does not verify the server certificate and has no option to enable verification: the standalone build has no certificate verifier. Start it with `--disable_certificate_verification`; without this option, it crashes.
