#!/bin/ksh
################################################################################
# Script Name : clear_aix_errcode.sh
# Description : Script to remotely clear a specific error code (352286C8) 
#               across multiple AIX servers after verifying its presence.
# Author      : Siva Prasad Kanishetty
# Date        : May 26, 2026
# Version     : 1.0
################################################################################

SERVER_LIST="/admin/scripts1/errpt_prod/prodaixserverslist.txt"
ERR_CODE="352286C8"

for i in $(cat "${SERVER_LIST}")
do
    echo "Target Node: $i"
    
    ssh -q "$i" '
        uname -uM; uname -n        
        if errpt -j 352286C8 | grep -q "352286C8"; then
            errclear -j 352286C8 0 > /dev/null 2>&1
            
            if [ $? -eq 0 ]; then
                echo "--------------ErrClearedSuccessfully-------------"
            else
                echo "--------------ErrorNotCleared or ErrorNotAvailable"
        fi
    '
    echo ""
done

exit 0
