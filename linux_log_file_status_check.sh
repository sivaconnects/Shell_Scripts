#!/bin/bash

# ==============================================================================
# Script Name: apb_status_file_chk.sh
# Description: Checks the modification time of a status file. If the file has 
#              not been modified in the last 20 minutes, its content is cleared.
#
# Usage:       ./apb_status_file_chk.sh
#
# Author:      Siva Prasad
# Date:        2025-09-18
# ==============================================================================


status_file="/APB_NPCI_FTP/APB_NPCI_Script/APB_NPCI_RETFILE_STATUS"
log_file="/admin/scripts1/siva/status_file_ckh.log"

if [ -f "$status_file" ]; then

if find "$status_file" -mmin +20 | grep -q "$status_file"; then
>"$status_file"

echo "$(date): Cleared $status_file due to >20m inactivity" >> "$log_file"

fi

fi

