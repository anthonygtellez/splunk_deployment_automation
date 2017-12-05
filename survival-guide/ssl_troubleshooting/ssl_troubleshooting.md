## SSL Troubleshooting for Splunk
Purpose of this is to provide common errors and how to get to root cause of ssl issues for Splunk to Splunk and intersplunk communication. When configuring Splunk SSL for web or various components talking to each other several configuration files need to modified and parameters need to line up for things to work properly. 

## Sanity Check:
Information about how certs are generated can be found in /opt/splunk/bin/genRootCA.sh:

```
echo "This script will create a root CA"
echo "It will output two files. ca.pem cacert.pem"
echo "Distribute the cacert.pem to all clients you wish to connect to you."
echo "Keep ca.pem for safe keeping for signing other clients certs"
echo "Remember your password for the ca.pem you will need to later to sign other client certs"
echo "Your root CA will expire in 10 years"
```
### Search Head

### Indexer(s)
Inputs.conf

```
[splunktcp-ssl://9997]

# SSL SETTINGS
[SSL]
serverCert = $SPLUNK_HOME/etc/auth/server.pem
requireClientCert = false
sslPassword = password
```

Server.conf

```
[sslConfig]
sslRootCAPath = $SPLUNK_HOME/etc/auth/ca.pem
```

### Checking sslRootCAPath
$ openssl x509 -in /opt/splunk/etc/auth/ca.pem -text -noout

```
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number: 16551569488170448198 (0xe5b2fcc16997f546)
    Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, ST=CA, L=San Francisco, O=Splunk, CN=SplunkCommonCA/emailAddress=support@splunk.com
        Validity
            Not Before: May 11 19:51:37 2015 GMT
            Not After : May  8 19:51:37 2025 GMT
        Subject: C=US, ST=CA, L=San Francisco, O=Splunk, CN=SplunkCommonCA/emailAddress=support@splunk.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (1024 bit)
                Modulus:
                    00:c9:99:be:79:ca:f6:a6:d4:6a:86:81:32:b4:75:
                    f1:d7:58:98:81:d0:58:7c:7e:c7:49:15:17:39:77:
                    10:49:3c:56:82:fe:49:66:b5:b2:c5:2d:b6:2e:5d:
                    d0:b6:26:1e:1c:9b:fb:a1:8f:5f:c5:5a:60:34:59:
                    b8:5b:d3:6a:e8:01:5d:37:67:74:97:d2:91:f2:15:
                    ad:d4:77:2a:ab:f5:fe:44:44:9d:00:60:50:3e:cb:
                    95:21:6c:c9:c3:f7:39:61:b3:b2:7c:b9:cb:9b:dd:
                    7b:c0:f2:b9:fb:f5:e8:e4:62:d0:d7:da:b3:10:58:
                    f3:59:60:f7:2b:c5:41:21:8b
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha1WithRSAEncryption
         57:7d:77:3c:b2:6f:6c:27:94:3c:b7:b6:51:55:1f:60:54:5d:
         d2:59:3c:a2:02:13:75:72:32:c3:d3:36:15:c3:ab:b1:12:55:
         60:4b:25:e5:10:87:ab:89:d4:0d:d0:c8:ba:ed:4e:a1:bf:d6:
         1e:b6:be:f3:fe:53:10:30:e1:31:d9:e2:0d:da:da:2e:b9:dd:
         3d:6a:ef:c7:61:ab:57:0a:9d:e3:ae:13:cd:d3:7b:f7:d1:10:
         7e:78:42:89:33:ae:70:17:a3:3f:af:fd:a1:89:93:38:c4:a5:
         21:30:ad:65:30:2c:0d:64:a0:4f:08:ff:45:c5:13:0c:56:6c:
         46:ed
```

### Forwarder(s)
Outputs.conf

```
[tcpout:primary_indexers_ssl]
server = jupiter.synapticecho.com:9997
clientCert = $SPLUNK_HOME/etc/auth/server.pem
sslPassword = password
sslRootCAPath = $SPLUNK_HOME/etc/auth/cacert.pem
autoLB = true
# If value is set to true read instructions below:
sslVerifyServerCert = false
```

#### Checking clientCert
$ openssl x509 -in /opt/splunkforwarder/etc/auth/server.pem -text -noout

```
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number: 15831133880858721752 (0xdbb37c63403c3dd8)
    Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, ST=CA, L=San Francisco, O=Splunk, CN=SplunkCommonCA/emailAddress=support@splunk.com
        Validity
            Not Before: Mar  3 20:26:48 2017 GMT
            Not After : Mar  2 20:26:48 2020 GMT
        Subject: CN=SplunkServerDefaultCert, O=SplunkUser
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (1024 bit)
                Modulus:
                    00:a7:6b:a8:63:3c:c9:48:2e:9e:fc:4d:b4:26:96:
                    4e:83:37:24:9d:cf:9c:b7:a0:a2:d9:30:36:ec:43:
                    46:3f:68:b3:04:fb:e4:3f:a4:4a:c3:4b:b4:40:e9:
                    1c:be:a9:af:21:3a:5a:87:3f:45:4c:39:64:ef:fc:
                    c3:64:65:1c:b6:58:c4:0c:9f:71:58:cd:bf:2a:ca:
                    cf:d9:24:5c:99:ab:f3:2f:16:73:94:cb:62:c2:99:
                    f2:1a:6c:89:8b:20:d4:7c:8a:86:c9:c4:38:2e:da:
                    52:c4:da:ec:db:c0:97:c5:05:31:22:d5:40:87:a9:
                    9a:83:a3:1a:93:3a:5c:38:b3
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha1WithRSAEncryption
         0d:3f:49:04:67:02:f2:68:cd:76:ff:5a:9a:6f:85:51:2f:32:
         87:95:a4:cc:85:1d:4f:2c:f5:93:a3:30:b6:c5:6d:b1:f8:94:
         f1:31:39:0f:94:7e:3b:f4:1d:5d:24:f7:c9:ce:02:c6:7a:6e:
         56:40:80:3d:c2:61:3a:08:05:f3:a9:0f:ba:80:cc:78:f5:fa:
         06:4a:fb:9f:df:9b:95:50:a0:c3:b5:1c:cf:f5:a8:ed:ab:0c:
         85:6b:e4:e5:a8:9e:72:5b:67:b7:6d:2a:eb:ff:67:48:7a:35:
         68:76:7b:4c:e5:8c:2d:65:3a:88:8e:f8:b2:62:49:28:b1:73:
         29:19
```

### Checking sslRootCAPath

$ openssl x509 -in /opt/splunkforwarder/etc/auth/cacert.pem -text -noout

```
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number: 16551569488170448198 (0xe5b2fcc16997f546)
    Signature Algorithm: sha1WithRSAEncryption
        Issuer: C=US, ST=CA, L=San Francisco, O=Splunk, CN=SplunkCommonCA/emailAddress=support@splunk.com
        Validity
            Not Before: May 11 19:51:37 2015 GMT
            Not After : May  8 19:51:37 2025 GMT
        Subject: C=US, ST=CA, L=San Francisco, O=Splunk, CN=SplunkCommonCA/emailAddress=support@splunk.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (1024 bit)
                Modulus:
                    00:c9:99:be:79:ca:f6:a6:d4:6a:86:81:32:b4:75:
                    f1:d7:58:98:81:d0:58:7c:7e:c7:49:15:17:39:77:
                    10:49:3c:56:82:fe:49:66:b5:b2:c5:2d:b6:2e:5d:
                    d0:b6:26:1e:1c:9b:fb:a1:8f:5f:c5:5a:60:34:59:
                    b8:5b:d3:6a:e8:01:5d:37:67:74:97:d2:91:f2:15:
                    ad:d4:77:2a:ab:f5:fe:44:44:9d:00:60:50:3e:cb:
                    95:21:6c:c9:c3:f7:39:61:b3:b2:7c:b9:cb:9b:dd:
                    7b:c0:f2:b9:fb:f5:e8:e4:62:d0:d7:da:b3:10:58:
                    f3:59:60:f7:2b:c5:41:21:8b
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha1WithRSAEncryption
         57:7d:77:3c:b2:6f:6c:27:94:3c:b7:b6:51:55:1f:60:54:5d:
         d2:59:3c:a2:02:13:75:72:32:c3:d3:36:15:c3:ab:b1:12:55:
         60:4b:25:e5:10:87:ab:89:d4:0d:d0:c8:ba:ed:4e:a1:bf:d6:
         1e:b6:be:f3:fe:53:10:30:e1:31:d9:e2:0d:da:da:2e:b9:dd:
         3d:6a:ef:c7:61:ab:57:0a:9d:e3:ae:13:cd:d3:7b:f7:d1:10:
         7e:78:42:89:33:ae:70:17:a3:3f:af:fd:a1:89:93:38:c4:a5:
         21:30:ad:65:30:2c:0d:64:a0:4f:08:ff:45:c5:13:0c:56:6c:
         46:ed
```


### Whats the difference?
The self signed cert has:

```
Subject: CN=SplunkServerDefaultCert, O=SplunkUser
```

And is derived from the CA cert.

## sslPassword set incorrectly

### SplunkSSL port Unreachable (Indexer)
Use openssl to connect to the port you configured for recieving data. 

$ openssl s_client -connect 45.55.233.75:9997

If you cannot connect this means the port is not being opened by the indexer with SSL settings.

Search for: index=_internal log_level=ERROR component=TcpInputConfig

If you see messages like the following:
03-04-2017 20:43:37.701 +0000 ERROR TcpInputConfig - SSL server certificate not found, or password is wrong - SSL ports will not be opened
03-04-2017 20:43:37.701 +0000 ERROR TcpInputConfig - SSL context not found. Will not open splunk to splunk (SSL) IPv4 port 9997

The sslPassword in inputs.conf is likely wrong. The default password for the Splunk self-signed cert is "password"

Messages you might see on your forwarders:
03-04-2017 20:48:23.148 +0000 ERROR TcpOutputFd - Connection to host=45.55.233.75:9997 failed

### Using old configurations
These are issues that will show up in the Splunkd logs, SSL will still work but the settings are deprecated.

### Web.conf
02-06-2017 14:46:31.111 -0500 WARN  SSLOptions - web.conf/[settings]/caCertPath: deprecated; use 'serverCert' instead

### Inputs.conf
02-06-2017 14:46:29.516 -0500 WARN  SSLOptions - inputs.conf/[SSL]/rootCA: deprecated; use 'sslRootCAPath' instead in server.conf/[sslConfig]

### Server.conf
02-06-2017 14:46:14.374 -0500 WARN  SSLOptions - server.conf/[sslConfig]/sslKeysfilePassword: deprecated; use 'sslPassword' instead


### SSL Version issues:
03-07-2017 15:28:11.721 -0500 ERROR TcpInputProc - Error encountered for connection from src=10.10.184.12:44380. error:140760FC:SSL routines:SSL23_GET_CLIENT_HELLO:unknown protocol

sslVersions = tls