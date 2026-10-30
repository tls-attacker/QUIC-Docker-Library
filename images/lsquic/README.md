# lsquic

## Source

[https://github.com/litespeedtech/lsquic](https://github.com/litespeedtech/lsquic)

## Requiered Server Parameters

```bash
-s [IP]:[PORT] -c [DOMAIN_NAME],[CERTIFICATE],[PRIVATE_KEY] -r [WWW_DIRECTORY]
```

## Requiered Client Parameters

```bash
-s [IP]:[PORT] -p [PATH]
```

## Note

- The server requires the SNI extension with the Common Name (CN) that is passed.
- The client does not verify the server certificate. Its option `-C [DIRECTORY]` is accepted but has no effect.
