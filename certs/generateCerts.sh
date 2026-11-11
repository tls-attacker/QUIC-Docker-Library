#!/usr/bin/env bash
set -e

if ! command -v openssl > /dev/null 2>&1; then
  echo "ERROR - openssl not found, skipping the certificate and key generation"
  exit 1
fi

echo "0/13 - Removing existing files"
rm -rf ca.key ca.crt ca.der ca.srl \
  server.rsa.key server.rsa.csr server.rsa.crt server.rsa.chain.crt server.rsa.ext server.rsa.p12 nssdb \
  server.ecdsa.key server.ecdsa.csr server.ecdsa.crt server.ecdsa.ext

echo "1/13 - Generating CA private key"
openssl genrsa -out ca.key 2048 > /dev/null

echo "2/13 - Generating self-signed CA certificate"
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt \
  -subj "/C=US/ST=California/L=Los Angeles/O=ExampleCorp Inc./OU=CA Department/CN=ExampleCA/emailAddress=ca@example.org" \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,keyCertSign,cRLSign" > /dev/null
openssl x509 -in ca.crt -outform DER -out ca.der > /dev/null

echo "3/13 - Generating RSA server private key (2048 bit, PKCS#8)"
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out server.rsa.key > /dev/null

echo "4/13 - Generating CSR for the RSA server"
openssl req -new -key server.rsa.key -out server.rsa.csr \
  -subj "/C=US/ST=California/L=Los Angeles/O=ExampleCorp Inc./OU=IT Department/CN=server.example.org/emailAddress=admin@example.org" > /dev/null

echo "5/13 - Creating X.509v3 extensions for the RSA server certificate"
cat > server.rsa.ext <<'EOF'
basicConstraints=CA:FALSE
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=DNS:localhost,DNS:server.example.org,IP:127.0.0.1,IP:::1
EOF

echo "6/13 - Signing the RSA server CSR with the CA"
openssl x509 -req -in server.rsa.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.rsa.crt -days 3650 -sha256 -extfile server.rsa.ext > /dev/null

echo "7/13 - Creating certificate chain for the RSA server certificate"
cat server.rsa.crt ca.crt > server.rsa.chain.crt

echo "8/13 - Generating ECDSA server private key (P-256, PKCS#8)"
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out server.ecdsa.key > /dev/null

echo "9/13 - Generating CSR for the ECDSA server"
openssl req -new -key server.ecdsa.key -out server.ecdsa.csr \
  -subj "/C=US/ST=California/L=Los Angeles/O=ExampleCorp Inc./OU=IT Department/CN=server.example.org/emailAddress=admin@example.org" > /dev/null

echo "10/13 - Creating X.509v3 extensions for the ECDSA server certificate"
cat > server.ecdsa.ext <<'EOF'
basicConstraints=CA:FALSE
keyUsage=critical,digitalSignature
extendedKeyUsage=serverAuth
subjectAltName=DNS:localhost,DNS:server.example.org,IP:127.0.0.1,IP:::1
EOF

echo "11/13 - Signing the ECDSA server CSR with the CA"
openssl x509 -req -in server.ecdsa.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out server.ecdsa.crt -days 3650 -sha256 -extfile server.ecdsa.ext > /dev/null

echo "12/13 - Creating NSS database with the RSA server certificate"
if command -v certutil > /dev/null 2>&1 && command -v pk12util > /dev/null 2>&1; then
  openssl pkcs12 -export -in server.rsa.crt -inkey server.rsa.key -name server -out server.rsa.p12 -passout pass: > /dev/null
  mkdir nssdb
  certutil -N -d sql:nssdb --empty-password
  pk12util -i server.rsa.p12 -d sql:nssdb -W "" > /dev/null
else
  echo "WARNING - certutil or pk12util not found, skipping the NSS database"
fi

echo "13/13 - Adapting permissions"
chmod 644 server.rsa.key
chmod 644 server.rsa.crt
chmod 644 server.rsa.chain.crt
chmod 644 server.ecdsa.key
chmod 644 server.ecdsa.crt
chmod 644 ca.der
chmod 644 ca.crt
if [ -d nssdb ]; then
  chmod 755 nssdb
  chmod 644 nssdb/*
fi
