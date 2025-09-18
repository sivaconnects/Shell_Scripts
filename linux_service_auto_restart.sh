#!/bin/bash

# ==============================================================================
# Script Name: cpuhigh_rtvrestart.sh
# Description: Automatically stops and restarts the rtvscand service if the 
#              CPU utilization consistently exceeds a defined threshold.
#
# Usage:       This script is intended to be run by cron, for example:
#              */5 * * * * /path/to/cpuhigh_rtvrestart.sh
#
# Author:      Siva [unix team]
# Version:     V.0.1
# Date:        11/08/2025
# ==============================================================================


# Un-comment the following lines for debugging purposes:
# set -x         # Traces the execution of the script
# set -e         # Exits immediately if a command exits with a non-zero status
# set -o pipefail # Exits if any command in a pipeline fails


cpu_idle=$(top -bn 1 |grep "Cpu" |awk -F " " '{print $5}' |sed 's/%.*//')
rtvscand_service=$(ps -ef |grep [r]tvscand |awk '{print $2}')
rtvrestart_log=/admin/scripts1/siva/rtvrestart.log

if (( $(echo "$cpu_idle <= 20" | bc -l) )); then

/etc/init.d/symcfgd stop >> "$rtvrestart_log" 2>&1

for i in $rtvscand_service
do
echo "$(date) : Stopping rtvscand PID $i, as the cpu utilization is >80%" >> "$rtvrestart_log" 2>&1
kill -9 "$i"
done

sleep 300

/etc/init.d/symcfgd start >> "$rtvrestart_log" 2>&1
/etc/init.d/rtvscand start >> "$rtvrestart_log" 2>&1
/etc/init.d/smcd start >> "$rtvrestart_log" 2>&1

new_rtvscand_service=$(ps -ef |grep [r]tvscand |awk '{print $2}')

for a in $new_rtvscand_service
do
echo "$(date) : rtvscand service has been started with PID $a" >> "$rtvrestart_log" 2>&1
done

fi



