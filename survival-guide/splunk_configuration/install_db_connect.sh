#!/bin/bash
#
# ===========================================================
# Purpose:	This script will install oracle jdk for dbconnect and configure the application
# Parameters:	None
# Example usage: $ bash install_db_connect.sh
#
# Privileges:	Must be run as root
# Author:	Anthony Tellez
#
# Notes:	This script requires access to the internet in order to grab the latest version of oracle jdk
#           
#		
# Revision:	Last change: 03/08/2016 by AT :: Updated wget configuration/variables
# ===========================================================
#
dl_dbconnect="wget -O splunk-db-connect-2_213.tgz https://splunkbase.splunk.com/app/2686/release/2.1.3/download/?origin=ipb"
dl_jdk='wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz'

echo "downloading dbconnect v.213"
$dl_dbconnect

# echo "downloading oracle jdk for dbconnect"
# $dl_jdk

# tar -zxf splunk-db-connect-2_213.tgz -C /opt/splunk/etc/apps
# tar -zxf jdk-8u73-linux-x64.tar.gz -C /opt
# chown -R splunk:splunk /opt/splunk 
# echo "jvm parameters for dbx"
# su -c splunk "/opt/splunk/bin/splunk restart"
