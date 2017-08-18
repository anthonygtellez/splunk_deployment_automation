#
# ===========================================================
# Purpose: This script will set ulimits and THP for splunk optimization
# Parameters:	None
# Example usage: $ bash optimize_linux.sh
#
# Privileges:	Must be run as root
# Author:	Mark Macielinski
#
# Notes:	Still got to add Centos 7 support and work on the selinux part, but that should be pretty easy. 
#           tested the Ubuntu portion, but don’t know if there are changes in the more current versions so that may need more testing.
# 
# Revision:	Last change: 03/28/2016 by AT :: Added details about script, updated version sent from Mark
# ===========================================================
#first check for redhat version
if [ -f /etc/centos-release ]; then
	#distro=$(cat /etc/redhat-release)
	#echo "distro:$distro"
	os_name=`cat /etc/redhat-release|awk '{print $1}'`
	os_version=`cat /etc/redhat-release |grep -o "[0-9]"|head -n 1`
else
	#check for os usling lsb_release command
	os_name=`lsb_release -a|grep Distributor|awk '{print $3}'`
fi

echo "os name:$os_name"
echo "os version:$os_version"


#check for centos (works on both centos and redhat)
if [ "$os_name" == "CentOS" ] || [ "$os_name" == "Ubuntu" ]; then

    echo "centos or ubuntu:$os_version"

   #get redhat release
   if [ "$os_name" == "CentOS" ]; then
        #redhat_release=`cat /etc/redhat-release|awk '{print $3}'`
        echo "Redhat release:$redhat_release"
   fi

  #check for redhat 7
  redhat_v7=os_version
  if [[ ($os_name -eq "CentOS") || ("$os_name" == "Ubuntu") ]]; then
        #fix ulimit settings
        #check ulimit.  If at default 1024 change to 8192.
        test=`ulimit -n`
        echo "ulimit:$test"
        if [ $test -lt 8192 ]; then
            #manually set ulimit to 8192
            setulimit=`ulimit -n 8192`
            echo "increase ulimit to 8192"
            #set limits.conf, will survive reboots
            #check to see if file as been modified
            test=`grep splunk /etc/security/limits.conf|grep 8192`
            if [[ $test =~ "splunk" ]]; then
                echo "do nothing"
            else
                cp /etc/security/limits.conf /etc/security/limits.conf.orig
                echo "splunk hard nproc 8192" >> /etc/security/limits.conf
                echo "splunk soft nproc 8192" >> /etc/security/limits.conf
                echo "splunk soft nofile 8192" >> /etc/security/limits.conf
                echo "splunk hard nofile 8192" >> /etc/security/limits.conf
            fi
        fi

        #if ubuntu make the following change
        if [ "$os_name" == "Ubuntu" ]; then
                #backup /etc/pam.d/common-session
                cp /etc/pam.d/common-session /etc/pam.d/common-session.orig
                #check to see if the pam_limits.so entry exists
                test=`grep pam_limits /etc/pam.d/common-session`
                if [[ $test =~ "pam_limits" ]]; then
                        echo "pam settings good,do nothing"
                else
                        echo "session   required        pam_limits.so" >> /etc/pam.d/common-session
                fi
        fi

        #disable transparent huge pages
        #modify /etc/rc.local to make changes permanent across re-boot
        test=`grep hugepage /etc/rc.local`
        if [[ $test =~ "hugepage" ]]; then
                echo "skip"
        else
            if [[ ("$os_name" = "CentOS") && ("$os_version" = "6") ]]; then
	       echo "CentOS Version:$os_version"
               disable1=`echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled`
               disable2=`echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag`
                echo "fix /etc/rc.local"
                #backup /etc/rc.local
                cp /etc/rc.local /etc/rc.local.orig
                #modify /etc/rc.local to turn off THP on reboot
                echo "if test -f /sys/kernel/mm/redhat_transparent_hugepage/enabled; then" >> /etc/rc.local
                echo "     echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled" >> /etc/rc.local
                echo "fi" >> /etc/rc.local
                echo "if test -f /sys/kernel/mm/redhat_transparent_hugepage/defrag; then" >> /etc/rc.local
                echo "     echo > never /sys/kernel/mm/redhat_transparent_hugepage/defrag" >> /etc/rc.local
                echo "fi" >> /etc/rc.local
	    elif [[ ("$os_name" = "CentOS") && ("$os_version" = "7") ]]; then
		echo "CentOS Version:$os_version"
               disable1=`echo never > /sys/kernel/mm/transparent_hugepage/enabled`
               disable2=`echo never > /sys/kernel/mm/transparent_hugepage/defrag`
                echo "fix /etc/rc.local"
                #backup /etc/rc.local
                cp /etc/rc.local /etc/rc.local.orig
                #modify /etc/rc.local to turn off THP on reboot
                echo "if test -f /sys/kernel/mm/transparent_hugepage/enabled; then" >> /etc/rc.local
                echo "     echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
                echo "fi" >> /etc/rc.local
                echo "if test -f /sys/kernel/mm/transparent_hugepage/defrag; then" >> /etc/rc.local
                echo "     echo > never /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
                echo "fi" >> /etc/rc.local
            elif [ "$os_name" = "Ubuntu" ]; then
                disable1=`echo never > /sys/kernel/mm/transparent_hugepage/enabled`
                disable2=`echo never > /sys/kernel/mm/transparent_hugepage/defrag`
                echo "fix /etc/rc.local"
                #backup /etc/rc.local
                cp /etc/rc.local /etc/rc.local.orig
                #modify /etc/rc.local to turn off THP on reboot
                echo "if test -f /sys/kernel/mm/transparent_hugepage/enabled; then" >> /etc/rc.local
                echo "     echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
                echo "fi" >> /etc/rc.local
                echo "if test -f /sys/kernel/mm/transparent_hugepage/defrag; then" >> /etc/rc.local
                echo "     echo > never /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
                echo "fi" >> /etc/rc.local
            fi
        fi
  fi

fi
