# s2n-quic

## Source

[https://github.com/aws/s2n-quic](https://github.com/aws/s2n-quic)

## Requiered Server Parameters

```bash
--port [PORT] --certificate [CERTIFICATE] --private-key [PRIVATE_KEY] --www-dir [DIRECTORY TO SERVE FILES FROM]
```

## Requiered Client Parameters

```bash
--ca [CA_CERTIFICATE] --ip [IP] --port [PORT] [URL]
```

## Note

- The client verifies the server certificate; pass the CA certificate with `--ca [CA_CERTIFICATE]`.
- The server and the client support `s2n-tls` and `rustls` as TLS stacks. Both are part of every image; the build argument `TLS_IMPLEMENTATION` (`s2n-tls` or `rustls`) selects the one that the container uses.
