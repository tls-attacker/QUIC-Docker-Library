# Certificates and Keys

The [generateCerts.sh](generateCerts.sh) script creates a CA and two server certificates signed by it, one with an RSA key and one with an ECDSA key. The quick start setups mount these files into the containers.

## Requirements

- [OpenSSL](https://github.com/openssl/openssl)
- `certutil` and `pk12util` for the NSS database. Without them, the script skips the NSS database.

## Usage

Run the script inside this directory:

```bash
./generateCerts.sh
```

## Files

| File                                  | Content                                                                     |
|---------------------------------------|-----------------------------------------------------------------------------|
| `ca.crt`, `ca.der`, `ca.key`          | CA certificate (PEM and DER) and its private key                            |
| `server.rsa.crt`, `server.rsa.key`    | RSA server certificate and private key (2048 bit, PKCS#8)                   |
| `server.rsa.chain.crt`                | RSA server certificate followed by the CA certificate                       |
| `server.ecdsa.crt`, `server.ecdsa.key`| ECDSA server certificate and private key (P-256, PKCS#8)                    |
| `nssdb`                               | NSS database with the RSA server certificate and key under the name `server`|

## Note

- Both server certificates are valid for `localhost`, `server.example.org`, `127.0.0.1` and `::1`.
- All certificates are valid for 3650 days.