# rama

## Source

[https://github.com/plabayo/rama](https://github.com/plabayo/rama)

## Required Server Parameters

```bash
--listen [IP:PORT] --cert [CERTIFICATE] --key [PRIVATE_KEY]
```

## Required Client Parameters

```bash
--ca [CA_CERTIFICATE] --url [URL] # e.g., https://localhost:4433/
```

## Note

- QUIC is only available on the main branch of rama and not in a release yet, so the images are versioned by commit.
- The build argument `TLS_IMPLEMENTATION` selects the TLS stack: `boringssl`, `rustls-ring` or `rustls-aws-lc`. The versions of the TLS stacks are fixed by the `Cargo.lock` of the repository.
- The client verifies the server certificate against the CA certificate passed with `--ca`. Without `--ca`, the client exits with an error before connecting; there is no option to disable verification.
