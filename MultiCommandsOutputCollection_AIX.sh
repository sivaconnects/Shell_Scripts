#!/bin/kash

##############################################################
# Author : Siva Prasad Kanishetty
# Operating System : AIX 
# Date : 26/02/2026
# Version : V1.0
# Pre Requasite : Password Less Authentication is required 
# a script that contains multiple commands
##############################################################

while read -r i
do
echo "Connecting $i..."

ssh -q root@"$i" << 'EOF'
if ! df /perffs >/dev/null 2>&1
then
mount 172.27.68.70:/perffs /perffs || exit 1
else
echo "/perffs already mounted"
fi

if [ -f /tmp/$(uname -n)_ServerDetails ]
then
mv /tmp/$(uname -n)_ServerDetails /tmp/$(uname -n)_ServerDetails_$(date +"%d%m%Y")
fi

sh /perffs/ServerDetails.sh

cp -pr /tmp/$(uname -n)_ServerDetails /perffs/hwactivity_26022026/06EDD1T
EOF

if [ $? -ne 0 ]
then
echo "Failed on $i"
fi

done < /perffs/hwactivity_26022026/srvlist.txt
