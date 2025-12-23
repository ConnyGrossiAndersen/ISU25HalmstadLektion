#!/bin/bash
#=============================================================================
#**Regel 1:**  
#≥ 3 misslyckade inloggningar → _High Risk_

#**Regel 2:**  
#≥ 1 misslyckad inloggning **och** användaren är `disabled` → _Critical Risk_

#**Regel 3:**  
#≥ 1 misslyckad inloggning → _Medium Risk_

#**Regel 4:**  
#0 misslyckade inloggningar → _Low Risk_
#=============================================================================
#

logfile="event_risk_report.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $logfile
}

# 1. Läs in CSV till en array av användare
declare -A status_map
while IFS=',' read -r username status; do
    [[ "$username" == "username" ]] && continue
    status_map[$username]=$status
done < users.csv

# 2. Räkna antal misslyckade inloggningar per användare
declare -A fail_count
for user in "${!status_map[@]}"; do
    count=$(jq --arg usr "$user" '.events | map(select(.user == $usr and .event == "failed_login")) | length' events.json)
    fail_count[$user]=$count
done

# 3. Riskklassificering
for user in "${!fail_count[@]}"; do
    fails=${fail_count[$user]}
    stat=${status_map[$user]}

    if (( fails >= 1 )) && [[ "$stat" == "disabled" ]]; then
        log "$user - CRITICAL RISK (disabled + failed logins)"
    elif (( fails >= 3 )); then
        log "$user - HIGH RISK (3+ failed attempts)"
    elif (( fails >= 1 )); then
        log "$user - MEDIUM RISK (failed attempts)"
    else
        log "$user - LOW RISK"
    fi
done

log "Analys slutförd."