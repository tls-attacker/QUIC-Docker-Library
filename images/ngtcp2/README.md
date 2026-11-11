# ngtcp2

## Source

[https://github.com/ngtcp2/ngtcp2/](https://github.com/ngtcp2/ngtcp2/)

## Required Server Parameters

```bash
[IP] [PORT] [PRIVATE_KEY] [CERTIFICATE] 
```

## Required Client Parameters

```bash
[IP] [PORT]
```

## Note

- The client does not verify the server certificate and has no option to enable verification.
- The server and the client support these TLS stacks: from 1.0.0 on `boringssl`, `quictls`, `gnutls`, `wolfssl` and `picotls`, from 1.2.0 on also `awslc` and `libressl`, from 1.12.0 on also `openssl`. Each image contains one of them; the build argument `TLS_IMPLEMENTATION` selects the one that the image is built with.
