# Risklogik 
#Regel 1: ≥ 3 fails -> High Risk
#Regel 2: ≥ 1 fails -> Medium Risk 
#Regel 3: ≥ 0 fails -> Low Risk 
# *Bonus* Disabled + fails -> Critical Risk 
#
import json
import csv

#Läs Json
with open ("pevents.json") as f:
    events = json.load(f)["events"]

# Läs in CSV 
users = {}
with open("pusers.csv") as f:
    reader = csv.DictReader(f)
for row in reader:
    users[row["username"]] = {
        "status":row["status"],
        "fails":0
    }

#Räkna fails
for event in events: 
    if event["event"] == "failed_login":
        user = event["user"]
        if user in users: 
            users[user]["fails"] += 1

# Riskklassificering

def classify(userinfo):
    fails = userinfo["fails"]
    status = userinfo["status"]

    if status == "disabled" and fails > 0:
        return " CRITICAL" 
    if fails >=3:
        return "HIGH"
    if fails >=1:
        return "MEDIUM"
    return "LOW"

#Loggning

with open("risk_report.txt","w") as report:
    for username, info in users.items():
        risk = classify(info)
    report.write(f"{username}: {risk} (fails: {info['fails']}, status: {info['status']})\n")
    print("Analysen är klar.Se risk_report.txt.")

                          
    
    
