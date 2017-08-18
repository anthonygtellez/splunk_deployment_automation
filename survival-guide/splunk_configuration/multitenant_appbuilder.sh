#!/bin/bash
#title           :multitenant_appbuilder.sh
#description     :This script will take a org name and Splunk TA as input and
#                 generate a new TA with the orgname embedded in the configs
#author          :ctribie, atellez
#date            :04Apr2016
#version         :1.1
#usage           :bash buildapp.sh
#notes           :
#==============================================================================

#Variables
newapps=()
appl=(sourceApps/*)
applist="${appl[@]/sourceApps\/template_/}"
now=`date +"%F_%T"`

#if [ -z "$1" ]
#then
#capture org name from user input
echo "#################################"
echo "###     Org App Builder     ###"
echo "#################################"
echo
echo "Please enter the org name you are generating an app for"
echo
read -p 'Orgname: ' orgname
echo

#else
#  orgname=${1[@]}
#fi

#allow user to choose which app to apply script to
select appname in exit ${applist[@]}
do
  if [ $appname = "exit" ]
  then
    break
  fi

 # for j in "${orgname[@]}"; do
    #define the final app name and append it to an array
    orgapp="${orgname}_${appname}"
    newapps+=($orgapp)
 # done

  #make a copy of the template directory which includes the org name
  copy_command="cp -r sourceApps/template_${appname} ${orgapp}"
  $copy_command

  #replace the word ORGNAME from the template with the actual org name
  rename="sed -i "s/ORGNAME/$orgname/g" ${orgapp}/*/*.c*";$rename

  echo "App generation complete for ${orgapp}."
done

#Prompt user to scp files to appropriate server
echo "Would you like to copy this addon to the appropriate Splunk server?"
select yn in "Yes" "No"; do
  case $yn in
    Yes )
      #make a backup copy of serverclass.conf
#      sync="rsync -a /opt/splunk/etc/system/local/serverclass.conf /home/splunk/serverclass-backup/serverclass.conf-$now";$sync

      #iterate through apps processed above
      for i in "${newapps[@]}"; do
        if [[ $i = *auth ]]
        then
          destfolder="/opt/splunk/etc/shcluster/apps"
          destserver="###deployer.splunk.tld###"
        elif [[ $i = *indexes ]]
        then
          mv_command="mv ${i} usc_${i}";$mv_command
          i="usc_${i}"
          destfolder="/opt/splunk/etc/master-apps"
          destserver="###master.splunk.tld###"
        else
          destfolder="/opt/splunk/etc/deployment-apps"
          destserver="###deployment.splunk.tld###"
        fi
        #copy files to destination server
        echo "Sending files to ${destserver}."
        scp="scp -r ${i} ${destserver}:${destfolder}/.";$scp
      done
      #delete temporary copy
      rmscp="rm -rf ${orgname}*";$rmscp
      break;;
    No ) exit;;
  esac
done
