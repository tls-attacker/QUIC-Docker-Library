#!/usr/bin/env bash
set -e

if ! command -v openssl > /dev/null 2>&1; then
  echo "ERROR - openssl not found, skipping the certificate and key generation"
  exit 1
fi

echo "0/10 - Removing existing files"
rm -rf ca.key ca.crt ca.der ca.srl server.key server.pkcs8.key server.csr server.crt server.chain.crt server.ext server.p12 nssdb

echo "1/10 - Generating CA private key"
openssl genrsa -out ca.key 2048 > /dev/null

echo "2/10 - Generating self-signed CA certificate"
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt \
  -subj "/C=US/ST=California/L=Los Angeles/O=ExampleCorp Inc./OU=CA Department/CN=ExampleCA/emailAddress=ca@example.org" \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,keyCertSign,cRLSign" > /dev/null
openssl x509 -in ca.crt -outform DER -out ca.der > /dev/null

echo "3/10 - Generating server private key (PKCS#1)"
openssl genrsa -out server.key 2048 > /dev/null

echo "4/10 - Converting server private key to PKCS#8"
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt \
  -in server.key -out server.pkcs8.key > /dev/null

echo "5/10 - Generating CSR for the server"
openssl req -new -key server.key -out server.csr \
  -subj "/C=US/ST=California/L=Los Angeles/O=ExampleCorp Inc./OU=IT Department/CN=server.example.org/emailAddress=admin@example.org" > /dev/null

echo "6/10 - Creating X.509v3 extensions for the server certificate"
cat > server.ext <<'EOF'
basicConstraints=CA:FALSE
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=DNS:localhost,DNS:server.example.org,IP:127.0.0.1,IP:::1
EOF

echo "7/10 - Signing the server CSR with the CA"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.crt -days 365 -sha256 -extfile server.ext > /dev/null

echo "8/10 - Creating certificate chain"
cat server.crt ca.crt > server.chain.crt

echo "9/10 - Creating NSS database"
if command -v certutil > /dev/null 2>&1 && command -v pk12util > /dev/null 2>&1; then
  openssl pkcs12 -export -in server.crt -inkey server.key -name server -out server.p12 -passout pass: > /dev/null
  mkdir nssdb
  certutil -N -d sql:nssdb --empty-password
  pk12util -i server.p12 -d sql:nssdb -W "" > /dev/null
else
  echo "WARNING - certutil or pk12util not found, skipping the NSS database"
fi

echo "10/10 - Adapting permissions"
chmod 644 server.key
chmod 644 server.pkcs8.key
chmod 644 server.crt
chmod 644 server.chain.crt
chmod 644 ca.der
chmod 644 ca.crt
if [ -d nssdb ]; then
  chmod 755 nssdb
  chmod 644 nssdb/*
fi
