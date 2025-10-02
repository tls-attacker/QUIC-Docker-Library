# lsquic

## Source

[https://github.com/litespeedtech/lsquic](https://github.com/litespeedtech/lsquic)

## Supported Versions

4.1.0, 4.2.0

## Requiered Server Parameters

```bash
-s [IP]:[PORT] -c [DOMAIN_NAME],[CERTIFICATE],[PRIVATE_KEY]
```

## Requiered Client Parameters

```bash
-s [IP]:[PORT]
```

## Note

- The server requires the SNI extension with the Common Name (CN) that is passed.
