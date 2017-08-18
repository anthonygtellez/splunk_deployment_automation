#!/bin/bash
#
# ===========================================================
# Purpose:	Upload a file to AmazonS3 in order to test connectivity to an environment during a cloud upgrade
# 		
# 	
#
# Parameters:	${1} = path to file you wish to upload
#		          ${2} = s3Key
#             ${s3Secret} = s3Secret supplied via interactive session
#             ${bucket} = replace this in the script with your own AWS bucket
# 
# Example usage: $ bash test_uploads3.sh some-file.tgz SomeKey
#
# Privileges:	Curl
# Authors:	Amanda Chen, Anthony Tellez
#
# Notes: Script found/developed my Amanda, parameterized by Tellez.
# 
file=${1}
bucket=test-bucket-splunk
resource="/${bucket}/${file}"
contentType="application/x-compressed-tar"
dateValue=`date -R`
stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
s3Key=${2}
d -s -p "set s3Secret: " s3Secret
printf "%b" "\n"
signature=`echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64`
curl -L -X PUT -T "${file}" \
  -H "Host: ${bucket}.s3.amazonaws.com" \
  -H "Date: ${dateValue}" \
  -H "Content-Type: ${contentType}" \
  -H "Authorization: AWS ${s3Key}:${signature}" \
  https://${bucket}.s3.amazonaws.com/${file}
