#!/bin/bash
#Om jag vill filtrera i loggar, kan jag exempelvis göra ett filtrerat sök
# Grep "ERROR" application.log eller Grep "FATAL" application.log etc. 

# Kommando om hur du enbart kollar loggar som blivit ändrade ( Till skolarbete)
# find . -name "*.log" -mtime -1 (Kontrollerar loggar som ändrats de senaste 24h)
# Hittar exempel syslog eller applicationlog som ändrats så kan jag skanna igenom dem . 
# Jag kan kombinera denna genom att sedan kontrollera ERROR CRITICAL och FATAL genom Grep.

#Dessa kommandon kommer jagh vilja göra in one go, för att skapa ett Shellscript 
#Detta gör jag genom att skapa en fil på shellscriptet. 

touch analyse-logs.sh
vim analyse-logs.sh 
chmod +x analyse-logs.sh
./analyse-logs.sh 

# Inne i vim ska jag markera --insert-- för att få in i find grep shellscriptet
# spara scriptet med esc? och längst nere :wq <-- Varför? 
# lägg till echo med \n för att skapa rader, infotect etc för att få ut info i loggen etc. film min21
#min 29 visar logsökfilen med variabler för döpta direktories och loggar. 
# final loop in a loop pattern i min46. 


