#!/bin/bash
#
# ===========================================================
# Purpose: This script will create a custom uba service for firewalld
# Parameters:	None
# Example usage: $ bash configure_firewalld_uba.sh
#
# Privileges:	Must be run as root
# Author:	Anthony Tellez
#
# Notes:	You can change the ports/protocol by modifying the XML syntax in the echo for example:
#           <port protocol="tcp" port="12345"/> You should only run this script once. Running it again will append
#           to the same file: /etc/firewalld/services/uba.xml and will break the service!
#
# Revision:	Last change: 03/01/2016 by AT :: Added details about script
# ===========================================================
touch /etc/firewalld/services/uba.xml
cat >/etc/firewalld/services/uba.xml <<EOF'<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>uba</short>
  <description>Service for Splunk UBA communication.</description>
  <port protocol="tcp" port="80"/>
  <port protocol="tcp" port="443"/>
  <port protocol="tcp" port="6379-6380"/>
  <port protocol="tcp" port="5432"/>
  <port protocol="tcp" port="8089"/>
  <port protocol="tcp" port="6700-6708"/>
  <port protocol="tcp" port="2181"/>
  <port protocol="tcp" port="2888"/>
  <port protocol="tcp" port="3888"/>
  <port protocol="tcp" port="9901"/>
  <port protocol="tcp" port="9001-9002"/>
  <port protocol="tcp" port="7474"/>
  <port protocol="tcp" port="4242"/>
  <port protocol="tcp" port="27107"/>
  <port protocol="tcp" port="21000-28000"/>
  <port protocol="tcp" port="8080-8081"/>
  <port protocol="tcp" port="50070"/>
  <port protocol="tcp" port="50075"/>
  <port protocol="tcp" port="50090"/>
  <port protocol="tcp" port="60010"/>
  <port protocol="tcp" port="60020"/>
  <port protocol="tcp" port="60030"/>
  <port protocol="tcp" port="9090"/>
  <port protocol="tcp" port="9095"/>
  <port protocol="tcp" port="9083"/>
</service>
EOF
echo "created service"
restorecon /etc/firewalld/services/uba.xml
chmod 640 /etc/firewalld/services/uba.xml
firewall-cmd --reload
echo "set selinux permissions"
firewall-cmd --permanent --add-service=uba
firewall-cmd --reload
firewall-cmd --list-service
echo "done."
