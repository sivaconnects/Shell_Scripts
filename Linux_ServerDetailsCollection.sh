#!/bin/bash
mount -t nfs -o vers=3 172.19.68.139:/perffs /perffs

mkdir -p /perffs/ServerDetails/Linux_ServerDetails/$(date +"%m%Y")
chmod 777 /perffs/ServerDetails/Linux_ServerDetails/$(date +"%m%Y")

while IFS= read -r i; do
echo "Connecting to $i"

ssh -q root@"$i" 2>/dev/null << 'EOF'

cd /tmp
FILE="$(hostname)_ServerDetails"
if [ -f "$FILE" ]; then
    mv "$FILE" "${FILE}_old_$(date +'%d%m%Y')"
    echo "Renamed $FILE to ${FILE}_old_$(date +'%d%m%Y')"
else
    echo "ServerDetails file not found for $(hostname)"
fi


if ! mountpoint -q /perffs; then
mount -t nfs -o vers=3 172.19.68.139:/perffs /perffs
else
echo "/perffs already mounted"
fi

cd /perffs
sh Linux_ServerDetails.sh

cd /tmp
cp -pr /tmp/*_ServerDetails /perffs/ServerDetails/Linux_ServerDetails/$(date +"%m%Y")

EOF
done < /admin/scripts1/Server_details/allredhat.txt
