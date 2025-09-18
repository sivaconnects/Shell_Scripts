#!/bin/ksh

# ==============================================================================
# Script Name: netstat_collection.sh
# Description: This script captures and logs network connection statistics
#              (SYN, WAIT, ESTABLISHED, LISTEN, CLOSE) at two different
#              intervals for monitoring and analysis.
#
# Author:      Siva Prasad
# Date:        2025-09-18
# ==============================================================================


LOG_FILE="/tmp/$(uname -n)_netstat_stats.log"

# Function to capture and log the statistics
capture_stats() {
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # Get the number of SYN, WAIT, ESTABLISHED, LISTEN & CLOSE connections
    SYN_COUNT=$(netstat -Aan | grep -i syn | wc -l)
    WAIT_COUNT=$(netstat -Aan | grep -i wait | wc -l)
    EST_COUNT=$(netstat -Aan | grep -i est | wc -l)
    LIST_COUNT=$(netstat -Aan |grep -i list | wc -l)
    CLOS_COUNT=$(netstat -Aan |grep -i clos | wc -l)

    # Log the output with a timestamp
    echo "=====================================================" >> $LOG_FILE
    echo "Statistics collected at: $TIMESTAMP" >> $LOG_FILE
    echo "-----------------------------------------------------" >> $LOG_FILE
    echo "SYN Connections: $SYN_COUNT" >> $LOG_FILE
    echo "WAIT Connections: $WAIT_COUNT" >> $LOG_FILE
    echo "ESTABLISHED Connections: $EST_COUNT" >> $LOG_FILE
    echo "LISTEN Connections: $LIST_COUNT" >> $LOG_FILE
    echo "CLOSE Connections : $CLOS_COUNT"  >> $LOG_FILE
    echo "" >> $LOG_FILE
    echo "Full netstat -Aan output:" >> $LOG_FILE
    netstat -Aan >> $LOG_FILE
    echo "=====================================================" >> $LOG_FILE
    echo "" >> $LOG_FILE
}

capture_stats

sleep 30

capture_stats

echo "Script finished."
