#!/bin/bash
#
# ===========================================================
# Purpose:	This script will install splunk and complete some initial setup steps
# Parameters:	None
# Example usage: $ bash rhel_yum_install_syslog-ng.sh
#
# Privileges:	Must be run as root
# Author:	Anthony Tellez
#
# Notes:	This script requires access to the internet in order to install the epel repos
#           and wget installed on the host
#		
# Revision:	Last change: 03/01/2016 by AT :: Updated for yum install & added details about script
# ===========================================================
#
download_epel="wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
install_local="yum localinstall epel-release-latest-7.noarch.rpm"
update_yum="yum -y update"
install_syslogng="yum -y install syslog-ng syslog-ng-libdbi"
disable_rsyslog="service rsyslog stop"
enable_syslog_ng="service syslog-ng start"
echo "downloading the epel required for RHEL"
echo $download_epel
$download_epel
echo $install_local
$install_local
echo "updating yum for epel"
echo $update_yum
$update_yum
echo "using YUM to install the latest version of Syslog-NG"
echo $install_syslogng
$install_syslogng
echo "disabling rSyslog and enabling Syslog-NG as the primary sysloging daemon"
echo $disable_rsyslog
$disable_rsyslog
echo $enable_syslog_ng
$enable_syslog_ng
