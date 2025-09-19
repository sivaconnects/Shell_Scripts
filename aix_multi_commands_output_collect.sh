#!/bin/ksh

#############################################################################################
# Script Name: multicommands_datacollect.sh
# Description: To collect multiple commands output from the list of AIX servers
# Author: Siva Prasad
# Date: 2024-06-10
# Version: 1.0
##############################################################################################

servers_list="/admin/scripts1/siva/vscode/ip/dr_aix_pli_servers.txt"
output="/admin/scripts1/siva/vscode/output/multi_commands_report.txt"

if [ ! -f "$servers_list" ]; then
  echo "Servers list file not found: $servers_list"
  exit 1
fi

while read -r i; do
echo "----------------------------------------------------------------"
echo "$i"
ssh -T -q root@"$i" << 'EOF' 2>/dev/null
uname -n
date
df -gt
lsvg -o
lsvg -p rootvg
EOF
echo "----------------------------------------------------------------"
echo
done < "$servers_list" > "$output"
