#!/bin/bash
#===========================================================
#
# 1. loopa igenom varje rad
# 2.  detektera mönster
# 3. logga resultatet# 
# 4. räkna antalet träffar
# 5. skriva en slutlig rapport
#
#==========================================================
# 
#          --- Börjar med filnamnen ---
# -- Skapar två loggfiler med inputfile och logfile som variabel--
inputfile="sample.log"
logfile="analysis.log"
#
#       --- Skapar funktionen log med datumstämpel ---
#       --- och skriver in i analysis.log dvs, logfile ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') -$1" | tee -a $logfile
    }
#
#       --- Nu skall vi ange fler variabler för räknare ---
#       --- Vi tilldelar värdet "0" för att sedan kunna plussa ---
#       --- för varje failed/error/unauth, den hittar i loggfilen ---
failed_count=0
error_count=0
unauth_count=0 
#
#       -- Nedan kommer tre if-satser som skall addera +1 till ---
#       -- ovan satta variabler, varje gång den hittar satt ord i loggen ---
#       -- Vi börjar med en While- sats för att berätta att den ska --
#       -- exekvera if-satsen medans den läser av linjerna rad för rad --
#
while IFS= read -r line; do
#
#       -- Vi börjar med failed
if echo "$line" | grep -qi "failed"; then
        log "Avvikande meddelande hittat: $line"
        ((failed_count++))
    fi

#       -- Sedan error ...
if echo "$line" | grep -qi "error"; then
        log "Avvikande meddelande hittat: $line"
        ((error_count++))
    fi

#       -- och till sist unauthorized ...
if echo "$line" | grep -qi "unauthorized"; then
        log "Avvikande meddelande hittat: $line"
        ((unauth_count++))
    fi
#
#       -- if satsen avslutas när varje rad har lästs av --
#       -- i den angivna filen, men filen anges aldrig av användare --
##      -- utan är hårdkodad till vår specifika inputfile /sample.log --
#
done < "$inputfile"
#
#
#       -- vi skickar loggar om analysen till vår logfile --
#       -- som vi definierade överst i scriptet --
#
log "ANALYS KLAR"
log "Antal misslyckade inloggningar: $failed_count"
log "Antal errors: $error_count"
log "Antal obehöriga försök: $unauth_count"
#
#
# Efter att ha kört skriptet blev loggen missvisande och meddelade att alla avvikande loggar
# var misslyckade inloggningsförsök, detta korrigerade jag med nytt meddelande i if-satsen till
# "avvikande meddelande hittat" 
