#!/bin/bash
#title           :tabuild.sh
#description     :This script will take a organization name as input and
#                 generate new TA's with the orgname embedded in the configs
#author          :chris tribie, anthony tellez
#date            :04APR16
#version         :1.1
#usage           :bash tabuild.sh <orgname>
#notes           :creates a clientName app which assigns the orgname to
#                 that organization's systems
#                 creates an app with outputs.conf for the organization
#                 creates an app with authorize.conf for the organization and sends it
#                 to our other deployment server
#                 edits $SPLUNK_HOME/etc/system/local/serverclass.conf
#                 adds a new serverclass and associated app mappings
#==============================================================================

#Variables
now=`date +"%F_%T"`
orgname=$1
destserver="###dmt.splunk.tld###"
destfolder="/opt/splunk/etc/deployment-apps"
serverclass="/opt/splunk/etc/system/local/serverclass.conf"

#define the final app name
orgapp="domain_${orgname}_clientName"

#make a copy of the template directory which includes the organization name
copy_command="cp -r /home/splunk/onboarding/sourceApps/domain_template_clientName ${orgapp}";$copy_command

#replace the word orgname from the template with the actual organization name
rename="sed -i "s/orgname/$orgname/g" ${orgapp}/*/*.c*";$rename

echo "App generation complete for ${orgapp}. Sending files to ${destfolder}."

copy_command="cp -r ${orgapp} /opt/splunk/etc/deployment-apps/.";$copy_command
#delete temporary copy
rmcp="rm -rf ${orgapp}";$rmcp

orgapp="domain_${orgname}_forwarder_outputs"
copy_command="cp -r /home/splunk/onboarding/sourceApps/domain_template_forwarder_outputs ${orgapp}";$copy_command
rename="sed -i "s/orgname/$orgname/g" ${orgapp}/*/*.c*";$rename

echo "App generation complete for ${orgapp}. Sending files to ${destfolder}."

copy_command="cp -r ${orgapp} /opt/splunk/etc/deployment-apps/.";$copy_command
rmcp="rm -rf ${orgapp}";$rmcp

orgapp="domain_auth_${orgname}"
copy_command="cp -r /home/splunk/onboarding/sourceApps/domain_auth_template ${orgapp}";$copy_command
rename="sed -i "s/orgname/$orgname/g" ${orgapp}/*/*.c*";$rename

echo "App generation complete for ${orgapp}. Sending files to ${destserver}:${destfolder}."

scp="scp -r ${orgapp} ${destserver}:${destfolder}/.";$scp
rmcp="rm -rf ${orgapp}";$rmcp

echo "[serverClass:domain_${orgname}_all_clients]" >> ${serverclass}
echo "whitelist.0 = *.${orgname}.(subdomain.gov|subdomain.org)" >> ${serverclass}
echo "" >> ${serverclass}
echo "[serverClass:domain_${orgname}_all_clients:app:domain_${orgname}_clientName]" >> ${serverclass}
echo "restartSplunkWeb = 0" >> ${serverclass}
echo "restartSplunkd = 1" >> ${serverclass}
echo "stateOnClient = enabled" >> ${serverclass}
echo "" >> ${serverclass}
echo "[serverClass:domain_${orgname}_all_clients:app:domain_${orgname}_forwarder_outputs]" >> ${serverclass}
echo "restartSplunkWeb = 0" >> ${serverclass}
echo "restartSplunkd = 1" >> ${serverclass}
echo "stateOnClient = enabled" >> ${serverclass}
echo "" >> ${serverclass}

echo ""
echo "Completed update of serverclass.conf for ${orgname}."
echo ""
tailcmd="tail -n 12 ${serverclass}";$tailcmd
reloadcmd="/opt/splunk/bin/splunk reload deploy-server -auth admin:password";$reloadcmd
