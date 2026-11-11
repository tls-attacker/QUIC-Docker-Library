# swift-nio-quic

## Source

[https://github.com/apple/swift-nio-quic](https://github.com/apple/swift-nio-quic)

## Required Server Parameters

```bash
--cert [CERTIFICATE] --key [PRIVATE_KEY] --port [PORT]
```

## Required Client Parameters

```bash
--host [IP] --port [PORT] --ca [CA_CERTIFICATE]
```

## Note

- swift-nio-quic uses the QUIC implementation of [swift-network-evolution](https://github.com/apple/swift-network-evolution) and the TLS implementation of [swift-tls](https://github.com/apple/swift-tls). The version of an image is the tag of swift-nio-quic, which selects the versions of swift-network-evolution and swift-tls.
- swift-nio-quic has no standalone server and client. The images contain our own server and client.
- The server sends the data of every bidirectional stream back on that stream. It is not an HTTP/3 server, so HTTP/3 clients complete the handshake, but they get their own request back instead of an HTTP/3 response. Optional parameters: `--host [IP]` (default `0.0.0.0`), `--alpn [PROTOCOLS]` (comma-separated, default `h3`) and `--retry` (the server sends a Retry packet).
- The client opens one bidirectional stream, sends a message and prints the response. Optional parameters: `--server-name [NAME]` (default: the value of `--host`), `--alpn [PROTOCOLS]` (comma-separated, default `h3`) and `--message [TEXT]`.
- The client verifies the server certificate; pass the CA certificate with `--ca [CA_CERTIFICATE]`. Without `--ca`, the client uses the default trust store of the system. With `--no-verify`, certificate verification is disabled.
- The server and the client only work with ECDSA certificates.
