#!/bin/bash
#
# ===========================================================
# Purpose:	This script will create the .ssh/authorized_keys objects required for passwordless ssh and generate a new
#           key for the host machine.
# Example usage: $ bash create_authorized_keys.sh
#
# Privileges:	Must be run as root
# Author:	Anthony Tellez
#
# Notes:	This script only requires root access/user acces  
#          
#		
# Revision:	Last change: 03/01/2016 by AT :: Updated for local yum install & added details about script
# ===========================================================
#
mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa
read -p "paste your public key to add to the host:" answer
echo "$answer" >> ~/.ssh/authorized_keys
chmod 400 ~/.ssh/authorized_keys