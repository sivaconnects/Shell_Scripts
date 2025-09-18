#!/bin/bash

# ==============================================================================
# Script Name: log_archiver.sh
# Description: This script finds the top 30 largest log files with a specific 
#              extension pattern, sorts them, and compresses them using gzip.
#
# Usage:       ./log_archiver.sh
#
# Author:      Siva Prasad
# Date:        2025-09-18
# ==============================================================================


LOGPATH=$(find / -xdev -ls | sort -nr --key=7 | head -30 | grep -E '\.log\.[0-9]+$' |awk '{print $11}')

if [ -z "$LOGPATH" ]; then
echo "No Log Files Found."
exit 1
fi

for i in $LOGPATH
do
if [ -f "$i" ]; then
gzip -f "$i" || { echo "Failed to gzip $i"; exit 1; }
else
echo "$i is not a valid file"
fi
done

exit 0
