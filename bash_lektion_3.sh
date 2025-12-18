#!/bin/bash 

#Skapar filer jag kommer använda  en lista med processer och en loggfil där loggen 
ProcessLista="processlist.txt"
ProcessLogg="processlog.log"

# Denna kod skapar processlistan (Enbart om den inte redan finns)
# cat <<EOF > EOF gör att jag slipper skriva Echo ssh Echo cron Echo apache, gör skriptet mer "clean"
if [ ! -f "$ProcessLista" ]; then
    cat <<EOF > "$ProcessLista"
ssh
cron
apache2
mysqld
chrome
EOF
fi

# Sätter in datumstämpel i dokumentet processlogg. 
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$ProcessLogg"
}


# Check_Process är en funktion som kontrollerar om en process körs eller inte. 
# processen är min lokala variabel som enbart existerar i funktionen $1 variabeln får värdet $1 som är första raden
# i min lista. och fortsätter att läsa ut rad för rad. $1 är ssh $2 är cron .osv
#grep är "kommandot" som kontrollerar om processen körs eller inte. 
#log skriver ut till loggfilen.
check_process() {
    local processen=$1
    if pgrep -x "$processen" &>/dev/null; then
        log "Processen '$processen' körs."
    else
        log "VARNING: Processen '$processen' körs inte."
    fi
}

# Run_Checks är en funktion , som i detta fall kommer kontrollera om en specifik fil finns. 
# Om filen saknas kommer ett felmeddelande sedan stängs loopen. 
# Om filen existerar, läser programmet av filen och kontrollerar vilka processer som körs. 
run_checks() {
    local minafiler=$1

    if [ ! -f "$minafiler" ]; then
        log "FEL: Filen $minafiler saknas."
        exit 1
    fi

    while read -r rad; do
        check_process "$rad"
    done < "$minafiler"
}

#Här anropar jag funktionen run_checks som först kontrollerar om filen existerar, sedan läser av vald fil för att kontrollera
# vilka av  processerna i listan som körs.  (Loggar sedan att kontrollerna slutfördes.)  
run_checks "$ProcessLista"
log "Kontroller slutförda."

