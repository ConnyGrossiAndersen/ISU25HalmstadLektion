#       --- Analysera samma sample.log som bash scriptet ---
#       --- Börjar med att definiera mina variabler ---
#
$InputFile="sample.log"
$LogFile="analysis.log"
#
#
#       -- Tillämpa funktionen som ska skriva logg till loggfilen --
function Write-Log {
    param([string]$Message)
    $entry = "$(Get-Date) - $Message"
    $entry | Tee-Object -FilePath $LogFile -Append
}
#
#
#       -- Ange variabler för räknaren till felmeddelande --
#
$failed=0 
$errors=0   #Får felmeddelande här som jag går tillbaka till -- (fick inte heta $error)
$unauth=0
#
#
#       -- Skapar Samma typ "while - loop som bash här heter det foreach"
#       -- Notera att alla if satser är innanför foreach-satsens måsvingar. 
foreach ($line in Get-Content $InputFile) {
#
#
#       -- Vi börjar  med failed...
if ($line -match "failed") {
        Write-Log "Avvikande meddelande hittat: $line"
        $failed++
    }    
#       -- fortsätter med  med error...
    if ($line -match "error") {
        Write-Log "Avvikande meddelande hittat: $line"
        $errors++
    }  
    #       -- och till sist unauth ...
    if ($line -match "unauthorized") {
        Write-Log "Avvikande meddelande hittat: $line"
        $unauth++
    }  
} # Denna måsvinge avslutar foreach loopen
#   Vilket vi ser på indenteringen  måsvingen är i linje med foreach vertikalt
#
#   ---- Lägger in loggmeddelande som tidigare skript ---
Write-Log "ANALYS KLAR"
Write-Log "Antal misslyckade inloggningar: $failed"
Write-Log "Antal errors: $errors"
Write-Log "Antal obehöriga försök: $unauth"
