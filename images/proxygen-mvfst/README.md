# proxygen with mvfst

## Source

[https://github.com/facebook/proxygen](https://github.com/facebook/proxygen)

## Requiered Server Parameters

```bash
-host [IP] -port [PORT] -key [PRIVATE_KEY] -cert [CERTIFICATE]
```

## Requiered Client Parameters

```bash
-host [IP] -port [PORT]
```

## Note

- The client does not verify the server certificate by default. From 2025.07.28.00 on, `-verify_server_cert` enables the verification against the default CA store of OpenSSL, which can be set with the environment variable `SSL_CERT_FILE=[CA_CERTIFICATE]`.
