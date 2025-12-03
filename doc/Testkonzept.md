# Testkonzept für TickOff (TickApp)

## 1. Testobjekt / Projektbeschreibung
**TickOff** ist eine mobile App, die Zeckenhotspots in der Schweiz anzeigt, Meldungen sammelt, Nutzer in Echtzeit warnt und wichtige Erste-Hilfe-Informationen bietet. Die App richtet sich an:
- Wanderer
- Touristen
- Familien
- Hundebesitzer
- Outdoor-Sportler

**Wichtige Funktionen:**
- Hotspot-Karte mit farblicher Risikoanzeige
- Zeckenmeldung erfassen (mit Standortvalidierung)
- Echtzeit-Updates für Hotspots
- Push-Benachrichtigungen beim Betreten von Risikogebieten
- Mehrsprachigkeit (DE/EN/FR)
- Einstellungen (Benachrichtigungen, Sprache, Datenschutz)
- Erste-Hilfe-Info-Seite
- Navigation zwischen allen App-Seiten
- DSGVO-konforme Datenspeicherung
- Offline-Modus für Karte & Meldungen

---

# 2. Zu testende User Stories (vollständig abgedeckt)

### **User Stories aus Backlog (alle Features):**
- **Mehrsprachigkeit**  
- **Meldungen in Echtzeit**  
- **Datenbank laut DSGVO**  
- **Einstellungen verwalten**  
- **Karten mit Hotspots sehen**  
- **Zeckenmeldung erfassen**  
- **Erste-Hilfe-Info-Seite öffnen**  
- **Navigation durch die App**  
- **Main Page anzeigen**  
- **Datenbank einrichten**  

Alle diese Funktionen werden durch Tests abgedeckt (Unit-, Integration-, System-, Blackbox-, Security-Tests).

---

# 3. Systemarchitektur
- **Frontend:** Flutter (Android/iOS/Web)
- **Backend:** Firebase (Firestore, Auth, Cloud Functions, Storage)
- **APIs:** Google Maps API
- **Hosting:** Firebase Hosting
- **Daten:** anonymisiert, DSGVO-konform
- **Echtzeit:** Firestore Listener + Cloud Functions

---

# 4. Kritikalität der Funktionseinheiten  
(Begründet: Welche Funktionseinheiten sind kritisch und warum?)

| Funktionseinheit | Kritikalität | Grund |
|------------------|--------------|-------|
| Hotspot-Karte | Hoch | Hauptfunktion – falsche Daten = Sicherheitsrisiko |
| Echtzeit-Meldungen | Hoch | Verzögerungen führen zu falscher Risikoeinschätzung |
| Zeckenmeldung | Hoch | Fehlerhafte Standorterfassung → unbrauchbare Datenbank |
| Push-Warnungen | Mittel | Nutzer könnte Gefahr übersehen |
| DSGVO-Datenbank | Hoch | Rechtliche Vorgaben, Datenschutz sehr kritisch |
| Offline-Modus | Mittel | Nutzer könnte ohne Internet keine Daten haben |
| Mehrsprachigkeit | Niedrig | Komfort-Funktion, kein Risiko |
| Erste-Hilfe-Seite | Mittel | Informationen müssen korrekt sein |
| Navigation | Mittel | Schlechte Navigation = schlechte UX |
| Einstellungen | Niedrig | Nicht sicherheitskritisch |

---

# 5. Anforderungen an die Tests
Tests müssen folgende Anforderungen abdecken:
- alle **Akzeptanzkriterien** abprüfen
- alle **User Stories** sind durch mindestens 1 Testfall abgesichert
- Tests müssen **reproduzierbar** sein
- Tests müssen auf **verschiedenen Geräten** laufen (Android/iOS)
- Tests müssen sowohl **online als auch offline** funktionieren
- Tests müssen **Fehlerfälle explizit prüfen**  
- Tests erfüllen **DSGVO-Anforderungen**

---

# 6. Testziele
- Sicherstellen, dass alle Funktionen **vollständig, stabil und korrekt** arbeiten
- Prüfen der **Karten- und Hotspotfunktionen**
- Sicherstellen, dass die App **Echtzeitdaten korrekt verarbeitet**
- Verifikation der **DSGVO-Konformität** (Standort, Anonymisierung)
- Überprüfung aller **Navigationselemente**
- Validierung der **Mehrsprachigkeit**
- Sicherstellen, dass die App **intuitiv und benutzerfreundlich** ist
- Gewährleistung hoher **Performance und Stabilität**

---

# 7. Testfälle (Blackbox)

## Vollständige Blackbox-Testtabelle  
*(alle User Stories abgedeckt)*

| ID | User Story | Beschreibung | Testdaten | Vorbedingungen | Schritte | Erwartetes Ergebnis |
|----|------------|--------------|-----------|----------------|----------|---------------------|
| BB-01 | Hotspot-Karte | Hotspots korrekt anzeigen | GPS-Position Zürich | App installiert | App starten, Karte öffnen | Hotspots erscheinen <3s |
| BB-02 | Zeckenmeldung | Standort validieren | – | GPS deaktiviert | Meldung erstellen | Fehlermeldung "Standort aktivieren" |
| BB-03 | Echtzeitdaten | Neuer Hotspot erscheint sofort | Neuer Hotspot im Backend | App offen | Hotspot hinzufügen | Neuer Hotspot erscheint ohne Neustart |
| BB-04 | Mehrsprachigkeit | Sprache umstellen | – | App gestartet | Einstellungen → FR | UI in Französisch |
| BB-05 | Push-Warnung | Warnung bei Hotspot betreten | Koordinaten eines Hotspots | GPS aktiv | Hotspot-Gebiet betreten | Push erscheint |
| BB-06 | Offline-Modus | Hotspots offline | gespeicherte Hotspots | Offline | App starten | Letzte Hotspots sichtbar |
| BB-07 | Erste-Hilfe-Info | Inhalte anzeigen | – | App gestartet | Erste Hilfe öffnen | Bilder + Texte korrekt |
| BB-08 | Navigation | Navigation testen | – | App installiert | Menü → Karte → Meldung → Info | Jede Seite erreichbar |
| BB-09 | Einstellungen | Sprache & Benachrichtigungen ändern | – | App installiert | Einstellungen ändern | App übernimmt Änderungen |
| BB-10 | DSGVO | Daten anonymisiert | Testuser | Meldung erfassen | Datenbank prüfen | Keine personenbezogenen Daten gespeichert |
| BB-11 | Main Page | Startseite wird geladen | – | App neu starten | App starten | Main Page sichtbar (<2s) |
| BB-12 | Datenbank | Firestore-Verbindung | Test-Hotspot | App online | Lesen/Schreiben testen | Daten werden korrekt gespeichert |

---

# 8. Testdaten

**Benötigte Daten:**
- GPS-Daten verschiedener Regionen (Zürich, Bern, Tessin, Land)
- Beispiel-Hotspots:
  - niedriges Risiko
  - mittleres Risiko
  - hohes Risiko
- Zeckenmeldungen:
  - 1 Zecke
  - 2–5 Zecken
  - >10 Zecken
- Testnutzer:
  - Standard-User
  - Nutzer mit deaktivierten Berechtigungen
- Mehrsprachige Inhalte
- Offline gespeicherte Daten (Cache)

Testdaten werden mit:
- Firestore-Testumgebung  
- Flutter-Testdaten  
- GPS-Simulation  
erstellt.

---

# 9. Testergebnisse
Jeder Test liefert:
- Bestanden / Nicht bestanden
- Fehlerbeschreibung
- Geräte- und OS-Version
- Screenshot oder Video
- Log-Auszug (Flutter + Firebase)
- Schritte zur Reproduktion

Alle Ergebnisse werden in **GitHub Issues** dokumentiert.

---

# 10. Testumgebung

**Geräte:**
- Samsung A52 (Android 12)
- Google Pixel (Android 13)
- iPhone 11 (iOS 16)
- iPhone 14 (iOS 17)

**Netzwerk:**
- WLAN
- 4G / 5G
- Offline

**Backend:**
- Firestore Testprojekt  
- Cloud Functions Emulator  

**Tools:**
- Flutter Test Runner
- Android Studio & Xcode Simulator
- Firebase Emulator Suite
- Google Maps Debug API Key

---

# 11. Testinfrastruktur
- GitHub Repository mit CI/CD
- Firebase Hosting + Testdatenbank
- Flutter Pipelines:
  - Unit Tests
  - Integration Tests
  - Linter
- Gerätefarm (lokal oder Browserstack optional)

---

# 12. Testverfahren
- **Blackbox-Tests**  
- **Unit-Tests (Dart)**  
- **Integrationstests (Flutter)**  
- **Systemtests auf echten Geräten**  
- **Usability-Tests mit echten Nutzern**  
- **Sicherheitstests** (DSGVO, Standort, Berechtigungen)  
- **Performance-Tests**  
- **Regressionstests** vor jedem Release  

---

# 13. Erstellung der Testdaten
- Firestore Fake-Collection für Testzwecke  
- GPS-Simulation im Android Emulator  
- iOS Location Simulation  
- Manuelle Meldungen durch Tester  
- Offline-Datensatz durch Caching erzeugt  

---

# 14. Dokumentation der Testergebnisse
Erfolgt über:
- GitHub Issues  
- Screenshots & Logs  
- Sprint Testing Overview  
- Testprotokolle (Markdown)  
- Fehlerberichte (Issue Templates)  

---

# 15. Testarten
| Testart | Ziel |
|---------|------|
| Unit-Test | Komponenten prüfen |
| Integrationstest | Zusammenspiel App ↔ Backend |
| Systemtest | Komplette App testen |
| Usability-Test | Benutzerfreundlichkeit |
| Sicherheitstest | DSGVO, Datenflüsse |
| Blackbox-Test | Anforderungen prüfen |
| Offline-Test | Verhalten ohne Internet |
| Performance-Test | Geschwindigkeit & Ressourcen |
| Regressionstest | Sicherstellen, dass alte Features nicht kaputt gehen |

---

# 16. Testaktivitäten
- Testplanung
- Testfalldefinition
- Testdurchführung
- Fehleranalyse
- Bugfixing
- Retest
- Regressionstest
- Abnahme
- Dokumentation

---

# 17. Zeitplan der Tests
| Phase | Zeitraum | Aktivität |
|--------|----------|-----------|
| Sprint 1–2 | Woche 1–4 | Unit & Integration |
| Sprint 3 | Woche 5–6 | Navigations- & UI-Tests |
| Sprint 4 | Woche 7–8 | Echtzeit-Tests & Pilotgruppe |
| Sprint 5 | Woche 9 | Blackbox & DSGVO-Tests |
| Sprint 6 | Woche 10 | Abnahme & Release |

---

# 18. Beteiligte Personen
- **Tester / QA:** 1 Person  
- **Entwickler:** 1–2 Personen  
- **Pilotgruppe:** 20 Personen  
- **Projektleiter:** verantwortlich für Abnahme  
- **Coach / Lehrperson:** Qualitätskontrolle  
