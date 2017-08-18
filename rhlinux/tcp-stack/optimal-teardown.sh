#!/bin/bash
#
# ===========================================================
# Purpose: Optimial teardown for TCP connections. Default is 2 hours, causing ulimit issues in environments
#          with lots of forwarders. This reduces it down to 10 minutes. Tweak the integer as need. Value is in seconds
# Parameters:	None
# Example usage: $ bash optimal-teardown.sh
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
echo 600 > /proc/sys/net/ipv4/tcp_keepalive_time
echo '# Persist Updated Keep Alive Setting Afer A Reboot' >> /etc/sysctl.conf
echo 'net.ipv4.tcp_keepalive_time = 600' >> /etc/sysctl.conf
