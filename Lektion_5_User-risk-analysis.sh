#!/bin/bash
#=========================================================================
#**Regel 1:**  
#`last_login_days > 90` → användaren är potentiellt inaktiv → MEDIUM RISK
#
#
#**Regel 2:**  
#`last_login_days > 180` → användaren är mycket inaktiv → HIGH RISK
#
#
#**Regel 3:**  
#`status = disabled` AND `last_login_days < 30` → misstänkt → WARNING
#
#
#**Regel 4:**  
#`status = disabled` AND `last_login_days > 180` → KRITISK RISK  
#→ konto bör raderas eller undersökas omedelbart
#
#
#=========================================================================
#             ----- Script kommer här ----
#=========================================================================
#
#
logfile="user_risk_report.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $logfile
}

while IFS=',' read -r username days status; do

    [[ "$username" == "username" ]] && continue

    if (( days > 180 )) && [[ "$status" == "disabled" ]]; then
        log "$username - KRITISK RISK (inaktiv > 180 dagar & disabled)"
    elif (( days > 180 )); then
        log "$username - HIGH RISK (inaktiv > 180 dagar)"
    elif (( days > 90 )); then
        log "$username - MEDIUM RISK (inaktiv > 90 dagar)"
    elif [[ "$status" == "disabled" ]]; then
        log "$username - WARNING (disabled men nyligen inloggad)"
    else
        log "$username - OK"
    fi

done < users.csv

log "Analys slutförd."