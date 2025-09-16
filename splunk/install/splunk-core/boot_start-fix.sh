#!/bin/bash
# Update ulimit setting correcly during reboot of Splunk in /etc/init.d/splunk
 splunk_start() {
  echo Starting Splunk...
  ulimit -Hn 20240
  ulimit -Sn 10240
  "/opt/splunk/bin/splunk" start --no-prompt --answer-yes
  RETVAL=$?
 }
