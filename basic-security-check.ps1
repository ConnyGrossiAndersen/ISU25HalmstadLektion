# Använder oss av loggfilen textdokumet security_log
$LogFile = "security_log.txt"

# skapar en funktion där vi loggar in meddelanden och datum in i loggen 
function Write-Log {
    param([string]$Message)
    $entry = "$(Get-Date) - $Message"
    $entry | Tee-Object -FilePath $LogFile -Append
}

# Skapar en funktion där vi ska kontrollera om en fil existerar, funktionen heter Check-File
# Variabeln för filen kallar vi för $path  parametern är en [string] som definierar att användaren skriver in en text i prompt
# Test-path 
function Check-File {
    param([string]$Path) 
    if (Test-Path $Path) {
        Write-Log "Filen '$Path' finns."
        (Get-Item $Path).Attributes | Out-String | Tee-Object -FilePath $LogFile -Append
    }
    else {
        Write-Log "VARNING: Filen '$Path' saknas."
    }
}

function Check-User {
    param([string]$User)
    try {
        $exists = (Get-LocalUser -Name $User -ErrorAction Stop)
        Write-Log "Användaren '$User' finns."
    }
    catch {
        Write-Log "VARNING: Användaren '$User' saknas."
    }
}

# hämtar funktion  Skriver till användare vilken fil som ska kontrolleras
# 
$File = Read-Host "Ange fil att kontrollera"
Check-File -Path $File

$User = Read-Host "Ange användarnamn att kontrollera"
Check-User -User $User

#Skriver ut meddelande "Kontroller slutförda" i loggen
Write-Log "Kontroller slutförda."