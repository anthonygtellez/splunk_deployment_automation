#!/bin/bash
#
# ===========================================================
# Purpose:
# Parameters:	${1} =
#               ${2} =
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
getprocspl="$(ps aux | grep '[s]plunkd -p 8089' | awk 'NR==1{print $2}')"
ulimitcmd="cat /proc/${getprocspl}/limits"
$ulimitcmd
echo "done."
