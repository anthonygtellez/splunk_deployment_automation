#!/bin/bash
#
# ===========================================================
# Purpose:	This script will replace the default splunk certs with the certificates supplied by letsencypt.
# Example usage: $ bash letsencypt.sh hostname.anthonytellez.com
#
# Privileges:	Must have openssl in path, ownership of certificate txt files and rw on /opt/splunk/etc/auth
# Author:	Anthony Tellez
#
# Notes:	Back up your /opt/splunk/etc/auth directory before running the script!
#
#
# Revision:	Last change: 12/12/2017 by AT :: Built and tested
# ===========================================================
#
if [[ $# -eq 0 ]] ; then
    echo 'provide the fqdn of the server as argument 1, eg: splunkserver.anthonytellez.com'
    exit 0
fi
fqdn="${1}"
cp /opt/splunk/etc/auth/${fqdn}/cert.pem /opt/splunk/etc/auth/splunkweb/cert.pem
cp /opt/splunk/etc/auth/${fqdn}/chain.pem /opt/splunk/etc/auth/ca.pem
cp /opt/splunk/etc/auth/${fqdn}/privkey.pem /opt/splunk/etc/auth/splunkweb/privkey.pem
# create server.pem
openssl pkcs8 -topk8 -inform PEM -outform PEM -in /opt/splunk/etc/auth/${fqdn}/privkey.pem -out /opt/splunk/etc/auth/encrypted.key -passout pass:"password"
cat /opt/splunk/etc/auth/${fqdn}/cert.pem > /opt/splunk/etc/auth/server.pem
cat /opt/splunk/etc/auth/encrypted.key >> /opt/splunk/etc/auth/server.pem
cat /opt/splunk/etc/auth/${fqdn}/chain.pem >> /opt/splunk/etc/auth/server.pem
chown -R splunk:splunk /opt/splunk
