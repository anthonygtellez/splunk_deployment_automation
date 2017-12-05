#Certificate Creation

## Generate a new private key and Certificate Signing Request
$ openssl req -out CSR.csr -new -newkey rsa:2048 -nodes -keyout privateKey.key

## Generate a self-signed certificate
$ openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt

## Generate a certificate signing request (CSR) for an existing private key
$ openssl req -out CSR.csr -key privateKey.key -new

## Generate a certificate signing request based on an existing certificate
$ openssl x509 -x509toreq -in certificate.crt -out CSR.csr -signkey privateKey.key

## Remove a passphrase from a private key
$ openssl rsa -in privateKey.pem -out newPrivateKey.pem


# Certificate Checking
## Check a signing request
$ openssl req -text -noout -verify -in CSR.csr

# Check a private key
$ openssl rsa -in privateKey.key -check

# Check a Certificate
$ openssl x509 -in certificate.crt -text -noout

# Check a PKS#12 file
$ openssl pkcs12 -info -in keyStore.p12

# SSL Debugging
# Check an MD5 hash of the public key to ensure that it matches with what is in a CSR or private key
$ openssl x509 -noout -modulus -in certificate.crt | openssl md5
$ openssl rsa -noout -modulus -in privateKey.key | openssl md5
$ openssl req -noout -modulus -in CSR.csr | openssl md5

# Connect to a port/socket using Openssl
$ openssl s_client -connect splunk.com:443

# SSL Conversion
## Convert a DER file (.crt .cer .der) to PEM
$ openssl x509 -inform der -in certificate.cer -out certificate.pem

## Convert a PEM file to DER
$ openssl x509 -outform der -in certificate.pem -out certificate.der

##Convert a PKCS#12 file (.pfx .p12) containing a private key and certificates to PEM
$ openssl pkcs12 -in keyStore.pfx -out keyStore.pem -nodes

## Convert a PEM certificate file and a private key to PKCS#12 (.pfx .p12)
$ openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile CACert.crt