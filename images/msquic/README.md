# msquic

## Source

[https://github.com/microsoft/msquic](https://github.com/microsoft/msquic)

## Requiered Server Parameters

```bash
-cert_file:[CERTIFICATE] -key_file:[PRIVATE_KEY] 
```

## Requiered Client Parameters

```bash
-target:[IP]
```

## Note

- The implementation does not speak HTTP/3 but only a "sample" protocol. We replace the "sample" ALPN with h3.
