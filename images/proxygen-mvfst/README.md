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

- The client verifies the server certificate only with `-verify_server_cert` (from 2025.07.28.00 on), against the default trust store of OpenSSL; set `SSL_CERT_FILE` to the CA certificate. Without `-verify_server_cert`, certificate verification is disabled.
