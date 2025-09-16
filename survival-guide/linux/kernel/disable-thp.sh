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
mkdir /etc/tuned/custom
touch /etc/tuned/custom/tuned.conf
cat >/etc/tuned/custom/tuned.conf <<EOF
[main]
include=virtual-guest

[vm]
transparent_hugepages=never

[script]
script=script.sh

EOF

touch /etc/tuned/custom/script.sh
cat >/etc/tuned/custom/script.sh <<EOF
#!/bin/sh

. /usr/lib/tuned/functions

start() {
    echo never > /sys/kernel/mm/transparent_hugepage/defrag
    return 0
}

stop() {
    return 0
}

process $@
EOF
tuned-adm profile custom
tuned-adm list
