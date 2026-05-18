# Konfiguration – TickOff Microservices

Dieses Dokument erklärt die Abhängigkeiten, Umgebungsvariablen und die zentrale Konfigurationsstrategie aller TickOff-Services.

---

## 1. Abhängigkeiten der Services

```
┌─────────────────┐      JWT verify      ┌──────────────────┐
│  TickMap Service│ ──────────────────►  │  Auth Service    │
│  (Port 3002)    │                      │  (Port 3001)     │
└────────┬────────┘                      └────────┬─────────┘
         │  Kafka events                           │  Kafka events
         ▼                                         ▼
┌────────────────────────────────────────────────────────────┐
│                   Kafka (Port 9092)                        │
│                   Zookeeper (Port 2181)                    │
└───────────────────────────┬────────────────────────────────┘
                            │  consume events
                            ▼
                 ┌──────────────────────┐
                 │  Analytics Service   │
                 │  (Port 8090)         │
                 └──────────┬───────────┘
                            │
                            ▼
              ┌─────────────────────────┐
              │     PostgreSQL          │
              │     (Port 5432)         │
              └─────────────────────────┘

All services are fronted by:
┌──────────────────────────────────────────────────────────┐
│              Nginx Reverse Proxy (Port 80)               │
│  /auth/*   → auth-service:3001                          │
│  /api/*    → tickmap-service:3002                       │
│  CORS headers added for all routes                      │
└──────────────────────────────────────────────────────────┘

Monitoring:
┌──────────────────┐    scrape    ┌───────────────────────┐
│    Prometheus    │ ◄──────────  │ auth-service /metrics │
│    (Port 9090)   │              │ tickmap-service /metrics│
│                  │              │ analytics-service /metrics│
│                  │              │ kafka-exporter:9308    │
│                  │              │ postgres-exporter:9187 │
└────────┬─────────┘              └───────────────────────┘
         │
         ▼
┌─────────────────┐
│    Grafana       │
│    (Port 3000)   │
│  3 KPI Alerts   │
└─────────────────┘
```

### Wer hängt von wem ab?

| Service | Abhängig von | Beschreibung |
|---------|-------------|--------------|
| **auth-service** | PostgreSQL, Kafka | Speichert Nutzer in PostgreSQL; publiziert `user_registered` Events auf Kafka |
| **tickmap-service** | PostgreSQL, Kafka, auth-service | Speichert Hotspots/Reports in PostgreSQL; ruft auth-service `/auth/verify` auf, um JWTs zu validieren; publiziert Events auf Kafka |
| **analytics-service** | PostgreSQL, Kafka | Konsumiert Kafka-Events und speichert Statistiken in PostgreSQL |
| **nginx** | auth-service, tickmap-service, analytics-service | Reverse Proxy; startet erst wenn alle Backend-Services bereit sind |
| **prometheus** | alle Services | Scraped `/metrics` Endpunkte |
| **grafana** | prometheus | Visualisiert Prometheus-Metriken |

### Service Discovery & Ausfallverhalten

Da alle Services in einem Docker-Compose-Netzwerk laufen, erfolgt Service Discovery über DNS-Namen (z. B. `http://auth-service:3001`).

**Was passiert, wenn ein Service ausfällt?**

| Ausgefallener Service | Auswirkung | Verhalten |
|----------------------|------------|-----------|
| **auth-service** | tickmap-service kann keine JWTs validieren → schreibende Endpoints geben 503 zurück | tickmap-service gibt deutliche Fehlermeldung: `"Auth service unavailable"` |
| **kafka** | auth-service / tickmap-service können keine Events publizieren | Beide Services starten mit Retry-Logik (5 s) und loggen den Fehler; API-Anfragen werden trotzdem beantwortet |
| **postgres** | auth-service und tickmap-service können keine Daten lesen/schreiben | DB-Verbindungsfehler → 500 mit Fehlermeldung |
| **analytics-service** | Kafka-Events werden nicht verarbeitet, Statistiken veralten | Kein Einfluss auf Auth oder TickMap; Kafka puffert die Messages (retention) |

---

## 2. Umgebungsvariablen

Alle Variablen werden in einer zentralen `.env`-Datei im Verzeichnis `infrastructure/` gehalten.  
Die Datei `.env.example` dokumentiert alle verfügbaren Variablen **ohne** echte Werte:

```
infrastructure/
├── .env.example   ← vorlage (committed)
└── .env           ← echte Werte (NICHT committed, in .gitignore)
```

### Übersicht aller Variablen

| Variable | Service | Bedeutung | Beispielwert |
|----------|---------|-----------|--------------|
| `POSTGRES_DB` | postgres, auth, tickmap, analytics | Name der PostgreSQL-Datenbank | `tickoff` |
| `POSTGRES_USER` | postgres, auth, tickmap, analytics | PostgreSQL-Benutzername | `tickoff_user` |
| `POSTGRES_PASSWORD` | postgres, auth, tickmap, analytics | PostgreSQL-Passwort | *(geheim)* |
| `JWT_SECRET` | auth-service | Geheimschlüssel für JWT-Signierung (min. 32 Zeichen) | *(geheim)* |
| `JWT_EXPIRES_IN` | auth-service | JWT-Ablaufzeit | `24h` |
| `GRAFANA_ADMIN_USER` | grafana | Grafana-Admin-Benutzername | `admin` |
| `GRAFANA_ADMIN_PASSWORD` | grafana | Grafana-Admin-Passwort | *(geheim)* |

### Variablen pro Service

**auth-service**
```
PORT=3001
POSTGRES_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
KAFKA_BROKERS=kafka:29092
KAFKA_TOPIC=tickoff.events
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRES_IN=${JWT_EXPIRES_IN}
```

**tickmap-service**
```
PORT=3002
POSTGRES_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
KAFKA_BROKERS=kafka:29092
KAFKA_TOPIC=tickoff.events
AUTH_SERVICE_URL=http://auth-service:3001
```

**analytics-service**
```
PORT=8090
POSTGRES_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
KAFKA_BROKERS=kafka:29092
KAFKA_TOPIC=tickoff.events
```

---

## 3. Zentrale Konfiguration

Alle Konfigurationswerte werden **zentral** in `infrastructure/.env` gehalten und per Docker-Compose an alle Services übergeben.  
Kein Service hat hartcodierte Credentials; alle sensiblen Werte kommen ausschliesslich aus Umgebungsvariablen.

```yaml
# Beispiel aus docker-compose.yml
auth-service:
  environment:
    - POSTGRES_URL=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
    - JWT_SECRET=${JWT_SECRET}
```

### Setup-Anleitung

```bash
# 1. .env erstellen
cp infrastructure/.env.example infrastructure/.env
# 2. Werte in .env anpassen (Passwörter, Secrets setzen)
nano infrastructure/.env

# 3. Gesamte Umgebung starten
cd infrastructure
docker compose up -d

# 4. Status prüfen
docker compose ps
```

---

## 4. Monitoring – 3 KPIs mit Alarmierung

Die folgenden KPIs werden in Grafana überwacht (Konfiguration: `infrastructure/monitoring/grafana/provisioning/alerting/alerts.yml`):

| KPI | Beschreibung | Schwellenwert | Severity |
|-----|-------------|---------------|---------|
| **Kafka Consumer Lag** | Unverarbeitete Messages in der Queue | > 100 Messages | warning |
| **Analytics Processing Errors** | Fehler beim Verarbeiten von Kafka-Events | ≥ 1 Fehler in 5 min | critical |
| **PostgreSQL Connections** | Aktive DB-Verbindungen | > 10 gleichzeitig | warning |

Alle Alerts sind in Grafana provisioned und lösen bei Überschreitung der Schwellenwerte eine Alarmierung aus.

---

## 5. Logging

Alle Services schreiben strukturierte Logs auf `stdout`.  
Diese werden von Promtail (`infrastructure/monitoring/promtail-config.yml`) gesammelt und an Loki weitergeleitet, wo sie in Grafana abgefragt werden können.

Log-Format: `[timestamp] [service] [level] message`

Beispiel:
```
2024-01-15T10:30:00 [auth] POST /auth/login
2024-01-15T10:30:00 [tickmap] Published event: tick_report
```
