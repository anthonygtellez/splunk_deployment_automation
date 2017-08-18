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
cat >/etc/security/limits.d/20-nproc.conf <<EOF
# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.

*          soft    nproc     10240
root       soft    nproc     unlimited
EOF

cat >/etc/security/limits.d/90-splunk.conf <<EOF
# ulimit Configuration for splunk

splunk soft nofile 10240
splunk hard nofile 10240
EOF

cat >/etc/sysctl.conf <<EOF
fs.file-max = 10240
EOF

sysctl -p

mv /etc/security/limits.conf /etc/security/limits.conf.orgin

cat >/etc/security/limits.conf <<EOF
# Configure uLimits for splunk
 root 	soft 	nofile 	10240
 root 	hard 	nofile 	20240
 splunk	soft	nofile	10240
 splunk	hard	nofile	20240
EOF

echo "done."
