#!/bin/bash
#
# ===========================================================
# Purpose: This script will create a custom syslog service for firewalld
# Parameters:	None
# Example usage: $ bash configure_firewalld_syslog.sh
#
# Privileges:	Must be run as root
# Author:	Anthony Tellez
#
# Notes:	You can change the ports/protocol by modifying the XML syntax in the echo for example:
#           <port protocol="tcp" port="12345"/> You should only run this script once. Running it again will append
#           to the same file: /etc/firewalld/services/syslog.xml and will break the service!
#
# Revision:	Last change: 03/01/2016 by AT :: Added details about script
# ===========================================================
touch /etc/firewalld/services/splunkd.xml
cat >/etc/firewalld/services/splunkd.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>splunkd</short>
  <description>Splunkd service for rest and communication.</description>
  <port protocol="tcp" port="8089"/>
  <port protocol="tcp" port="8080"/>
  <port protocol="tcp" port="9997"/>
  <port protocol="tcp" port="8000"/>
  <port protocol="tcp" port="8191"/>
  <port protocol="tcp" port="8065"/>
</service>
EOF
restorecon /etc/firewalld/services/splunkd.xml
chmod 640 /etc/firewalld/services/splunkd.xml
firewall-cmd --reload
echo "set selinux permissions"
firewall-cmd --permanent --add-service=splunkd
firewall-cmd --reload
firewall-cmd --list-service
echo "done."
