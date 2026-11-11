# tquic

## Source

[https://github.com/Tencent/tquic](https://github.com/Tencent/tquic)

## Required Server Parameters

```bash
-l [IP:PORT] -c [CERTIFICATE] -k [PRIVATE_KEY] --root [DIRECTORY TO SERVE FILES FROM]
```

## Required Client Parameters

```bash
[URL] # e.g., https://localhost:4433/index.html
```

## Note

- tquic uses BoringSSL as TLS stack; the version is fixed by the `deps/boringssl` submodule of the repository.
- The server and the client support HTTP/3 (`h3`) and HTTP/0.9 (`http/0.9`, `hq-interop`).
- The client does not verify the server certificate and has no option to enable verification.
