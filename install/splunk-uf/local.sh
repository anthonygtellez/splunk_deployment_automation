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
#		in ~/splunkforwarder/etc/system/local/
#			deploymentclient.conf - preloaded deployment server info
#		Alternatively, ~/splunkforwarder/etc/apps/
#		org_all_deploymentclient/local/
#			deploymentclient.conf - preloaded deployment server info
#		in ~/splunkforwarder/etc/
#			splunk-launch.conf - SPLUNK_FIPS=1 - this must be done on first boot to ensure splunk enables the FIPS module
#		after untar, splunk is started, the admin password is changed, and
#		splunk is set to run at boot time. Since everything up to this point was
#		done as the root user, we need to change ownership to the splunk user.
#		This is done via the chown command. Last step is to start splunk again.
#		
# Revision:	Last change: 03/08/2016 by AT :: Increased Security of password entry mechanism
# ===========================================================
#
useradd -d /opt/splunkforwarder splunk
tar -zxf  "${1}" -C /opt/
/opt/splunkforwarder/bin/splunk start --accept-license
read -s -p "set password for admin user: " password
printf "%b" "\n"
/opt/splunkforwarder/bin/splunk edit user admin -password "${password}" -auth admin:changeme
/opt/splunkforwarder/bin/splunk stop
/opt/splunkforwarder/bin/splunk enable boot-start -user splunk
chown -R splunk:splunk /opt/splunkforwarder
service splunk start
