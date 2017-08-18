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
stopSplunk="sudo su - splunk -c '/opt/splunkforwarder/bin/splunk stop'"
untarSplunk="tar -zxvf /tmp/${1} -C /opt && chown -R splunk:splunk /opt/splunkforwarder"
startSplunk="sudo su - splunk -c '/opt/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt'"
for HOST in $(< $2); do
    scp -r "${1}" $HOST:/tmp
    ssh $HOST "$stopSplunk"
    ssh $HOST "$untarSplunk"
    ssh $HOST "$startSplunk"
	if [ $? -ne 0 ]; then
	  	echo "---- COULD NOT CONNECT TO $HOST ----"
	fi
done
