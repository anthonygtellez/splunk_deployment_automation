#!/bin/bash
cp /opt/splunk/etc/auth/server.pem /opt/splunk/etc/auth/server.pem.splunk
openssl pkcs8 -topk8 -inform PEM -outform PEM -in /opt/splunk/etc/auth/splunkweb/privkey.pem -out /opt/splunk/etc/auth/encrypted.key -passout pass:"password"
cat /opt/splunk/etc/auth/splunkweb/cert.pem > /opt/splunk/etc/auth/server.pem
cat /opt/splunk/etc/auth/encrypted.key >> /opt/splunk/etc/auth/server.pem
cat /opt/splunk/etc/auth/ca.pem >> /opt/splunk/etc/auth/server.pem
chown -R splunk:splunk /opt/splunk