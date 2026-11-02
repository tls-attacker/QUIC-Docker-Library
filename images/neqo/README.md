# neqo

## Source

[https://github.com/mozilla/neqo](https://github.com/mozilla/neqo)

## Requiered Server Parameters

```bash
[IP]:[PORT]
```

## Requiered Client Parameters

```bash
[URL] # e.g., https://localhost:4433
```

## Note

- The server does not read PEM files; it takes its certificate from an NSS database (`--db [DIRECTORY] --key [NICKNAME]`). Without these options, it uses the test certificate that comes with neqo.
- The client does not verify the server certificate and has no option to enable verification.
