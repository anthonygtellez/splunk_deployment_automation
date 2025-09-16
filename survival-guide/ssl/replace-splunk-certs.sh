#!/bin/bash
#
# ===========================================================
# Purpose:	This script will take the two certs from the other script and replace the defualt splunk certs
#           It also needs the private key which was used for generating the certificates to create the certificate chain correctly
#           Bundled all of these files into a .tar file, the script expects the files to have the same hostname ast the certificate files
#           Ex: hostname001.dod.mil.cer.txt-server.pem, hostname001.dod.mil.cer.txt-cacert.pem, hostname001.dod.mil.key
#           I suggest backing up /opt/splunk/etc/auth before running this script just incase your keys or certs are wrong.
# Example usage: $ bash replace-splunk-certs.sh hostname001.dod.mil.keysandcerts.tar
#
# Privileges:	Must have openssl in path, ownership of certificate txt file
# Author:	Anthony Tellez
#
# Notes:	Only tested on RHEL7, OSX grep does not have perl support (I believe)
#
#
# Revision:	Last change: 05/23/2017 by AT :: Built and tested
# ===========================================================
#

hostname=`hostname`
mkdir /opt/splunk/certs
tar xvf ${1} -C /opt/splunk/certs
cp /opt/splunk/certs/${hostname}*-server.pem /opt/splunk/etc/auth/splunkweb/cert.pem
cp /opt/splunk/certs/${hostname}*-cacert.pem /opt/splunk/etc/auth/ca.pem
cp /opt/splunk/certs/${hostname}*.key /opt/splunk/etc/auth/splunkweb/privkey.pem
chown -R splunk:splunk /opt/splunk
## Server Cert Structure:
### /opt/splunk/etc/auth/splunkweb/cert.pem
### encrypted /opt/splunk/etc/auth/splunkweb/privkey.pem
### /opt/splunk/ect/auth/cacert.pem
cp /opt/splunk/etc/auth/server.pem /opt/splunk/etc/auth/server.pem.splunk
openssl pkcs8 -topk8 -inform PEM -outform PEM -in /opt/splunk/etc/auth/splunkweb/privkey.pem -out /opt/splunk/etc/auth/encrypted.key -passout pass:"password"
cat /opt/splunk/etc/auth/splunkweb/cert.pem > /opt/splunk/etc/auth/server.pem
cat /opt/splunk/etc/auth/encrypted.key >> /opt/splunk/etc/auth/server.pem
cat /opt/splunk/etc/auth/ca.pem >> /opt/splunk/etc/auth/server.pem
chown -R splunk:splunk /opt/splunk
