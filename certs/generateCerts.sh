#!/usr/bin/env bash
set -e

echo "0/9 - Removing existing files"
rm -f ca.key ca.crt ca.srl server.key server.pkcs8.key server.csr server.crt server.chain.crt server.ext

echo "1/9 - Generating CA private key"
openssl genrsa -out ca.key 2048 > /dev/null 2>&1

echo "2/9 - Generating self-signed CA certificate"
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt \
  -subj "/C=US/ST=California/L=Los Angeles/O=ExampleCorp Inc./OU=CA Department/CN=ExampleCA/emailAddress=ca@example.org" > /dev/null 2>&1

echo "3/9 - Generating server private key (PKCS#1)"
openssl genrsa -out server.key 2048 > /dev/null 2>&1

echo "4/9 - Converting server private key to PKCS#8"
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt \
  -in server.key -out server.pkcs8.key > /dev/null 2>&1

echo "5/9 - Generating CSR for the server"
openssl req -new -key server.key -out server.csr \
  -subj "/C=US/ST=California/L=Los Angeles/O=ExampleCorp Inc./OU=IT Department/CN=server.example.org/emailAddress=admin@example.org" > /dev/null 2>&1

echo "6/9 - Creating X.509v3 extensions for the server certificate"
cat > server.ext <<'EOF'
basicConstraints=CA:FALSE
EOF

echo "7/9 - Signing the server CSR with the CA"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt -days 365 -sha256 -extfile server.ext > /dev/null 2>&1

echo "8/9 - Creating certificate chain"
cat server.crt ca.crt > server.chain.crt

echo "9/9 - Adapting permissions"
chmod 644 server.key
chmod 644 server.pkcs8.key
chmod 644 server.crt
chmod 644 server.chain.crt