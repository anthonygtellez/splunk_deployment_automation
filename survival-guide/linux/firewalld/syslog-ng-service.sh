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
touch /etc/firewalld/services/syslog.xml
cat >/etc/firewalld/services/syslog.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>syslog</short>
  <description>Service for syslog communication.</description>
  <port protocol="udp" port="514"/>
  <port protocol="udp" port="51401"/>
  <port protocol="udp" port="51410"/>
  <port protocol="udp" port="51411"/>
  <port protocol="udp" port="51412"/>
  <port protocol="udp" port="51413"/>
  <port protocol="udp" port="51414"/>
  <port protocol="udp" port="51415"/>
  <port protocol="udp" port="51416"/>
  <port protocol="udp" port="51417"/>
  <port protocol="udp" port="51418"/>
  <port protocol="udp" port="51419"/>
  <port protocol="udp" port="51420"/>
  <port protocol="udp" port="51421"/>
  <port protocol="udp" port="51422"/>
  <port protocol="udp" port="51423"/>
  <port protocol="udp" port="51424"/>
  <port protocol="udp" port="51425"/>
  <port protocol="udp" port="51426"/>
  <port protocol="udp" port="51427"/>
  <port protocol="udp" port="51428"/>
  <port protocol="udp" port="51429"/>
  <port protocol="udp" port="51430"/>
  <port protocol="udp" port="51431"/>
  <port protocol="udp" port="51432"/>
  <port protocol="udp" port="51433"/>
  <port protocol="udp" port="51434"/>
  <port protocol="udp" port="51435"/>
  <port protocol="udp" port="51436"/>
  <port protocol="udp" port="51437"/>
  <port protocol="udp" port="51438"/>
  <port protocol="udp" port="51439"/>
  <port protocol="udp" port="51440"/>
  <port protocol="udp" port="51441"/>
  <port protocol="udp" port="51442"/>
  <port protocol="udp" port="51443"/>
  <port protocol="udp" port="51444"/>
  <port protocol="udp" port="51445"/>
  <port protocol="udp" port="51446"/>
  <port protocol="udp" port="51447"/>
  <port protocol="udp" port="51448"/>
  <port protocol="udp" port="51449"/>
  <port protocol="udp" port="51450"/>
  <port protocol="udp" port="51451"/>
  <port protocol="udp" port="51452"/>
  <port protocol="udp" port="51453"/>
  <port protocol="udp" port="51454"/>
  <port protocol="udp" port="51455"/>
  <port protocol="udp" port="51456"/>
  <port protocol="udp" port="51457"/>
  <port protocol="udp" port="51458"/>
  <port protocol="udp" port="51459"/>
  <port protocol="udp" port="51460"/>
</service>
EOF
echo "created service"
restorecon /etc/firewalld/services/syslog.xml
chmod 640 /etc/firewalld/services/syslog.xml
firewall-cmd --reload
echo "set selinux permissions"
firewall-cmd --permanent --add-service=syslog
firewall-cmd --reload
firewall-cmd --list-service
echo "done."
