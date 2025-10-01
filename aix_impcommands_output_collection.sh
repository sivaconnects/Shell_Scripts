#!/bin/sh
##############################################
#Script to Collect Important Commands output from all AIX servers
#Author: Siva
#Date:01/10/2025
##############################################

ips="/admin/scripts1/siva/2018t/ips.txt"


cat "$ips" | while IFS= read -r i; do
echo "$i"
ssh -q root@"$i" << EOF
cd /tmp
if [ -f \$(uname -n)_ServerDetails ]; then
mv \$(uname -n)_ServerDetails \$(uname -n)_ServerDetails_\$(date +'%d%m%Y')
else
echo "\$(uname -n)_ServerDetails Not Available"
fi

if ! mount | grep -q '/perffs'; then
mount 172.19.68.139:/perffs /perffs
else
echo "/perffs already mounted"
cd /perffs
sh ServerDetails.sh
fi

cd /tmp
cp -pr \$(uname -n)_ServerDetails /perffs/062018T_HW_ACTIVITY_01102025/before
EOF
done
