#!/bin/ksh

# ==============================================================================
# Description: This script connects to a list of AIX servers and renames the old server
# details file and Runs a script to collect impotant command outputs and then finally copies 
# the newly generated outputs file into a given path
# Author: Siva Prasad
# Date: 2025-10-25
# ==============================================================================

dt=$(date +"%d%m%Y")
path="/perffs/062016T_HW_ACTIVITY_26102025/before"
servers_list="/admin/scripts1/siva/activities/2016t_ips.txt"

while read -r i; do
    echo "Processing Server $i"
    ssh -q root@"$i" << EOF 2>/dev/null
    
# Rename old ServerDetails if exists
if [ -f /tmp/\$(uname -n)_ServerDetails ]; then
    mv "/tmp/\$(uname -n)_ServerDetails" "/tmp/\$(uname -n)_ServerDetails_$dt"
else
    echo "Old ServerDetails Not Found"
fi

# Run ServerDetails.sh if exists
if [ -f /perffs/ServerDetails.sh ]; then
    sh /perffs/ServerDetails.sh
else
    echo "ServerDetails.sh Script Not Available"
fi

# Copy new ServerDetails to backup location
if [ -f /tmp/\$(uname -n)_ServerDetails ]; then
    cp -p "/tmp/\$(uname -n)_ServerDetails" "$path"
fi
EOF

done < "$servers_list"
