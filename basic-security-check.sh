#!/bin/bash
# Vi anger till systemet att filen ar ett bashscript

# Vi skapar en loggfil och döper den till security_log.txt
logfile="security_log.txt"

# loggar  datum till ( tee- a $logfile som är vårt textdokument  security_log)
log() {
    echo "$(date) - $1" | tee -a $logfile
}

#kontrollerar om filen som användaren matat in existerar.  matar ut om filen finns eller saknas 
# Programmet går vidare till nästa steg och låter inte användaren försöka med en ny fil om en fil
#Inte existerar 

check_file() {
    local file=$1
    if [ -f "$file" ]; then
        log "Filen '$file' finns."
        ls -l "$file" | tee -a $logfile
    else
        log "VARNING: Filen '$file' saknas."
    fi
}

# definierar en variabel för användare första input och vidare
# dev/null ignorerar felmeddelanden 
#  kontrollerar om en specifik användare finns i filen id. loggar om användaren finns eller saknas. 
check_user() {
    local user=$1
    if id "$user" &>/dev/null; then
        log "Användaren '$user' finns."
    else
        log "VARNING: Användaren '$user' saknas."
    fi
}

# Skriver ut en promt till användaren att ange  vilken fil som ska kontrolleras. 
# Skriver också ut en promt till användaren vilket användarnamn i filen som skall kontrolleras
# Loggar sedan i security-log.txt  att kontroller är slutförda 
#Loggar förmodligen inte för varje användare som kontrollerats utan enbart att det är slutfört

read -p "Ange fil att kontrollera: " file_input
check_file "$file_input"

read -p "Ange användarnamn att kontrollera: " user_input
check_user "$user_input"

log "Kontroller slutförda."
