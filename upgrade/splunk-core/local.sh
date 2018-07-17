#!/bin/bash
#
# ===========================================================
# Purpose:
# Parameters:	${1} = path to splunk install
# Example usage: $ bash splunkinstall.sh splunk-6.3.2-aaff59bb082c-Linux-x86_64.tgz
#
# Privileges:	Must be run as root
# Authors:	Anthony Tellez
#
# Notes:
#
#
# Revision:	Last change: XX/XX/2017 by AT ::
# ===========================================================
#
sudo su - splunk -c '/opt/splunk/bin/splunk stop'
tar -zxvf ${1} -C /opt && chown -R splunk:splunk /opt/splunk
sudo su - splunk -c '/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt'
