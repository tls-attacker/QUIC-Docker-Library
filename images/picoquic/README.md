# picoquic

## Source

[https://github.com/private-octopus/picoquic](https://github.com/private-octopus/picoquic)

## Required Server Parameters

```bash
-p [PORT] -c [CERTIFICATE] -k [PRIVATE_KEY]
```

## Required Client Parameters

```bash
[IP] [PORT]
```

## Note

- The signature and hash algorithms list should only contain TLS 1.3 allowed algorithms.
- The client verifies the server certificate; pass the CA certificate with `-t [CA_CERTIFICATE]`. Without it, certificate verification is disabled.
