# TickOff API Tests

Diese Tests prüfen die REST-Endpoints beider Microservices.

## Bruno (GUI-Tool)

[Bruno](https://www.usebruno.com/) ist ein Open-Source API-Client (vergleichbar mit Postman).

### Setup

1. Bruno herunterladen und installieren: https://www.usebruno.com/downloads
2. In Bruno: **Open Collection** → Ordner `test/bruno/auth-service/` oder `test/bruno/tickmap-service/` wählen
3. Environment `Local` auswählen (Environment-Icon oben rechts)
4. Requests in der richtigen Reihenfolge ausführen (seq 1 → seq 7)

### Reihenfolge (Auth Service)

| # | Request | Beschreibung |
|---|---------|-------------|
| 1 | Health Check | Prüft ob Service läuft |
| 2 | Register User | Erstellt Account, speichert Token in Variable |
| 3 | Login | Anmeldung, aktualisiert Token-Variable |
| 4 | Verify Token | Token-Validierung (von anderen Services genutzt) |
| 5 | Get Current User | Gibt Profil des eingeloggten Users zurück |

### Reihenfolge (TickMap Service)

| # | Request | Beschreibung |
|---|---------|-------------|
| 1 | Health Check | Prüft ob Service läuft |
| 2 | List Hotspots | Alle Hotspots abrufen (public) |
| 3 | Create Hotspot | Neuen Hotspot erstellen (JWT erforderlich) |
| 4 | Update Hotspot | Idempotentes Update (JWT erforderlich) |
| 5 | Create Report | Anonymisierten Bericht einreichen |
| 6 | List Reports | Alle Berichte abrufen (public) |
| 7 | Delete Hotspot | Hotspot löschen (JWT erforderlich, idempotent) |

---

## curl (Kommandozeile)

Als Alternative zu Bruno können die Tests auch mit `curl` durchgeführt werden.

### Voraussetzung

```bash
cd infrastructure
cp .env.example .env
# .env anpassen (Passwörter setzen)
docker compose up -d
```

### Auth Service Tests

```bash
# 1. Health Check
curl http://localhost:3001/health

# 2. Registrieren
TOKEN=$(curl -s -X POST http://localhost:3001/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@tickoff.ch","password":"Secret123!","displayName":"Test"}' \
  | jq -r '.token')
echo "Token: $TOKEN"

# 3. Login
TOKEN=$(curl -s -X POST http://localhost:3001/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@tickoff.ch","password":"Secret123!"}' \
  | jq -r '.token')

# 4. Token verifizieren
curl http://localhost:3001/auth/verify \
  -H "Authorization: Bearer $TOKEN"

# 5. Profil abrufen
curl http://localhost:3001/auth/me \
  -H "Authorization: Bearer $TOKEN"
```

### TickMap Service Tests

```bash
# 1. Health Check
curl http://localhost:3002/health

# 2. Hotspots abrufen (public)
curl http://localhost:3002/api/hotspots

# 3. Hotspot erstellen (JWT erforderlich)
HOTSPOT_ID=$(curl -s -X POST http://localhost:3002/api/hotspots \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"latitude":47.3769,"longitude":8.5417,"city":"Zürich","region":"Zürich","riskLevel":"high","radius":500}' \
  | jq -r '.id')
echo "Hotspot ID: $HOTSPOT_ID"

# 4. Hotspot aktualisieren (idempotent)
curl -X PUT http://localhost:3002/api/hotspots/$HOTSPOT_ID \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"latitude":47.3769,"longitude":8.5417,"riskLevel":"medium","verified":true,"radius":300}'

# 5. Bericht einreichen
curl -X POST http://localhost:3002/api/reports \
  -H "Content-Type: application/json" \
  -d '{"latitude":47.3769,"longitude":8.5417,"region":"Zürich","riskLevel":"high","environment":"forest"}'

# 6. Berichte abrufen
curl http://localhost:3002/api/reports

# 7. Hotspot löschen (idempotent)
curl -X DELETE http://localhost:3002/api/hotspots/$HOTSPOT_ID \
  -H "Authorization: Bearer $TOKEN"
# Nochmal aufrufen → gleiche Antwort (204), kein Fehler
curl -X DELETE http://localhost:3002/api/hotspots/$HOTSPOT_ID \
  -H "Authorization: Bearer $TOKEN"
```

---

## Über Nginx Gateway (Port 80)

Alle Endpoints sind auch über den Nginx Reverse Proxy erreichbar:

```bash
# Auth Service via Gateway
curl http://localhost/auth/verify -H "Authorization: Bearer $TOKEN"

# TickMap Service via Gateway
curl http://localhost/api/hotspots
```
