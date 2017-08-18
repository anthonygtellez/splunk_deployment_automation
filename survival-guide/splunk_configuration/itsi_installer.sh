#!/bin/bash
#
# ===========================================================
# Purpose:	This script will install ITSI following the steps from docs.splunk.com
# Parameters:	${1} = path to itsi .spl file
# 
# Example usage: $ bash itsi_install.sh splunk-it-service-intelligence_220.spl
#
# Privileges:	Run as root
# Authors:	Anthony Tellez
#
# Notes:	This script will set ownership to a splunk user, it is expected that the splunk_install script was used
#           to create the user splunk.
#		
# Revision:	Last change: 04/27/2016 by AT :: Created script, added documentation
# ===========================================================
#

service splunk stop
echo "##################################################################"
echo "###     Splunk Stopped, Installing IT Service Intelligence     ###"
echo "##################################################################"

tar -xvf ${1} -C /opt/splunk/etc/apps
chown -R splunk:splunk /opt/splunk

echo "##################################################################"
echo "###     IT Service Intelligence Installed, Starting Splunk     ###"
echo "##################################################################"

service splunk start