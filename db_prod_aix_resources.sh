#!/usr/bin/sh

# ==============================================================================
# Description: This script connects to a list of AIX servers, and collects
#              and displays CPU and memory resource information.
# Author: Siva Prasad
# Date: 2025-09-18
# ==============================================================================

servers_list="/admin/scripts1/siva/db_prod_aix_ips.txt"

if [ ! -f "${servers_list}" ]; then
echo "Error : The server list file '${servers_list}' not available."
exit 1
fi

while read -r i; do
echo "${i}"
echo "--------------------------------------"

ssh -q root@"${i}" << 'EOF'

pcpu=$(vmstat |grep ent |awk '{print \$5}' |sed 's/ent=//g')
vcpu=$(lparstat -i |grep "Online Virtual CPUs" |awk '{print $5}')
mem=$(lparstat -i |grep "Online Memory" |awk '{print $4}')

echo "Physical CPUs: ${pcpu}"
echo "Virtual CPUs: ${vcpu}"
echo "Memory: ${mem}"

EOF

done < "$servers_list" > /admin/scripts1/siva/db_prod_aix_resources.txt
