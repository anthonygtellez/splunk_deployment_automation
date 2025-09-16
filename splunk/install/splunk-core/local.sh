#!/bin/bash
#
# ===========================================================
# Purpose:	This script will install splunk and complete some initial setup steps
# Parameters:	${1} = path to splunk install .tgz file
#
# Example usage: $ bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz
#
# Privileges:	Must be run as root
# Authors:	Chris Tribie, Anthony Tellez
#
# Notes:	This script can use customized Splunk install tar or the default from Splunk.com.
#       Our custom install comprised the following changes from the base install:
#		in ~/splunk/etc/system/local/
#			server.conf - configured master_uri for license server
#			authentication.conf - preloaded config for admin access from AD domain
#			deploymentclient.conf - preloaded deployment server info
#		in ~/splunk/etc/auth/
#			distServerKeys/dmc-hostname/trusted.pem - added the public key for our DMC for search peer configuration
#			distServerKeys/ess-hostname/trusted.pem - added the public key for our Enerprise Security Search Head	for search peer configuration
#		in ~/splunk/etc/
#			splunk-launch.conf - SPLUNK_FIPS=1 - this must be done on first boot to ensure splunk enables the FIPS module
#		after untar, splunk is started, the admin password is changed, and
#		splunk is set to run at boot time. Since everything up to this point was
#		done as the root user, we need to change ownership to the splunk user.
#		This is done via the chown command. Last step is to start splunk again.
#
# Revision:	Last change: 03/08/2016 by AT :: Increased Security of password entry mechanism
# ===========================================================
#
useradd -d /opt/splunk splunk
tar -zxf  "${1}" -C /opt/
touch /opt/splunk/etc/.ui_login
/opt/splunk/bin/splunk start --accept-license
read -s -p "set password for admin user: " password
printf "%b" "\n"
/opt/splunk/bin/splunk edit user admin -password "${password}" -auth admin:changeme
/opt/splunk/bin/splunk stop
/opt/splunk/bin/splunk enable boot-start -user splunk
chown -R splunk:splunk /opt/splunk
service splunk start
