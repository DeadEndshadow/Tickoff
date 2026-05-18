# Detailplan pro Woche – TickOff

**Projekt:** TickOff  
**Team:** Balestrieri Terence, Bürgi Sebastian, Leuenberger Luca Andrea, Mohan Tharun  
**Modul:** M321 – Microservices  

---

## Wochenübersicht

| Woche | Datum | Terence (Balestrieri) | Sebastian (Bürgi) | Luca (Leuenberger) | Tharun (Mohan) | Meilenstein |
|-------|-------|-----------------------|-------------------|--------------------|-----------------|-------------|
| **1** | KW 1  | Projektbeschreibung, Architekturdiagramm | Technologieauswahl & Begründung, Repo-Setup | Datenbankschema entwerfen | Flutter-Projekt initialisieren | Projektstart, Dokumentation V1 |
| **2** | KW 2  | Testkonzept erstellen | Docker-Compose Grundstruktur, Kafka + Zookeeper | Auth-Service: Grundstruktur, DB-Tabellen | Karte-Screen (Flutter) | Infrastruktur läuft lokal |
| **3** | KW 3  | Auth-Service testen (Endpoints) | Analytics-Service: Kafka Consumer | Auth-Service: Register/Login/Verify (JWT) | Hotspot-Anzeige auf Karte | Auth-Service fertig |
| **4** | KW 4  | TickMap-Service testen (CRUD) | Prometheus + Grafana Dashboards | TickMap-Service: Hotspots CRUD, Kafka | Zecke-melden Screen | TickMap-Service fertig |
| **5** | KW 5  | Tests (Bruno Collections) | Grafana Alerting (3 KPIs) | CORS, Nginx Reverse Proxy | Push-Benachrichtigungen (Firebase) | Tests & Monitoring |
| **6** | KW 6  | Testprotokoll vervollständigen | Logging-Pipeline (Loki/Promtail) | Konfigurationsdoku (.env, Abhängigkeiten) | Mehrsprachigkeit (DE/EN/FR) | Abgabevorbereitung |
| **7** | KW 7  | Präsentation vorbereiten | Docker-Compose final (alle Services) | README + Abgabedokumentation | App-Review & Bugfixes | Finale Abgabe |

---

## Abwesenheiten / IPAs

| Person | Datum | Grund |
|--------|-------|-------|
| – | – | Keine geplanten Abwesenheiten |

*(Spontane Abwesenheiten werden über den Gruppen-Chat kommuniziert und im nächsten Standup besprochen.)*

---

## Verantwortlichkeiten

| Bereich | Verantwortlich |
|---------|---------------|
| Auth Service (Backend) | Luca |
| TickMap Service (Backend) | Luca + Terence |
| Analytics Service (Backend) | Sebastian |
| Monitoring & Logging (Grafana, Prometheus) | Sebastian |
| Docker-Compose & Infrastruktur | Sebastian |
| Flutter App (Frontend) | Tharun |
| Tests & Testprotokoll | Terence |
| Dokumentation | Alle |

---

## Standup-Rhythmus

- **Täglich (10 min):** Was habe ich gemacht? Was mache ich heute? Gibt es Blocker?  
- **Wöchentlich (30 min):** Sprintreview & Planung der nächsten Woche  
