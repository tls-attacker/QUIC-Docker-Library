# go-x-net

## Source

[https://github.com/golang/net](https://github.com/golang/net)

## Required Server Parameters

```bash
-listen [IP:PORT] -cert [CERTIFICATE] -key [PRIVATE_KEY] -root [DIRECTORY TO SERVE FILES FROM]
```

## Required Client Parameters

```bash
[URL] # e.g., https://localhost:4433/index.html
```

## Note

- The interop program only runs with the environment variable `TESTCASE`. The images set it to `handshake`.
- The server and the client only support HTTP/0.9 with the ALPN `hq-interop`.
- The client does not verify the server certificate and has no option to enable verification.
