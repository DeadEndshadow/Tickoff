# Testkonzept für TickOff (TickApp)

## 1. Testobjekt / Projektbeschreibung
**TickOff** ist eine mobile App, die Wanderern, Touristen, Familien und Hundebesitzern hilft, Zeckenrisiken in der Schweiz frühzeitig zu erkennen und zu melden.  

Die App bietet folgende Funktionen:
- Anzeige von Zecken-Hotspots auf einer Karte (farblich markiert nach Risiko)
- Zeckenmeldung mit Standort, Zeit und Anzahl Zecken
- Push-Benachrichtigungen bei Betreten von Hotspot-Gebieten
- Echtzeit-Aktualisierung der Hotspots
- Offline-Modus für Hotspots und Meldungen
- Mehrsprachigkeit (Deutsch, Englisch, Französisch)
- Bebilderte Erste-Hilfe- und Präventionstipps
- Einfache Navigation und benutzerfreundliche Oberfläche

**Zweck:** Verbesserung der Sicherheit bei Outdoor-Aktivitäten, Aufbau einer Community-Datenbank und Förderung der Prävention gegen Zeckenbisse.

---

## 2. User Stories (zu testende Funktionen)
- **Hotspot-Karte:** Als Wanderer möchte ich eine farbige Hotspot-Karte sehen, um Zeckenrisiken einzuschätzen.  
- **Zeckenmeldung:** Als Nutzer möchte ich eine Zecke nur mit aktiviertem Standort melden, damit die Meldung korrekt ist.  
- **Sprache ändern:** Als Nutzer möchte ich die Sprache ändern können, um die App zu verstehen.  
- **Push-Benachrichtigungen:** Als Elternteil möchte ich Push-Warnungen bei Hotspots erhalten, um meine Kinder zu schützen.  
- **Offline-Modus:** Als Wanderer möchte ich die letzten Hotspots auch offline sehen, um ohne Internet informiert zu sein.  
- **Erste Hilfe & Prävention:** Als Senior möchte ich bebilderte Anleitungen, damit ich im Notfall richtig handle.  
- **Navigation:** Als Nutzer möchte ich mich in der App klar zurechtfinden, um alle Funktionen einfach zu erreichen.  
- **Echtzeit-Updates:** Als Nutzer möchte ich, dass neue Hotspot-Daten in Echtzeit angezeigt werden, damit ich immer aktuelle Informationen sehe.  

---

## 3. Systemarchitektur
- **Frontend:** Flutter-App für Android, iOS und Web  
- **Backend:** Firebase (Cloud Firestore für Daten, Cloud Functions für Benachrichtigungen und Hotspot-Auswertung)  
- **APIs:** Google Maps API für die Kartenintegration  
- **Hosting:** Firebase Hosting  
- **Verbindung:** App ↔ Firebase (Datenbank, Auth, Cloud Functions) ↔ Google Maps API  
- **Datenschutz:** Standortdaten anonymisiert, DSGVO-konform  

---

## 4. Kritikalität der Funktionseinheiten

| Funktionseinheit | Kritikalität | Begründung |
|------------------|--------------|-------------|
| Zeckenmeldung | Hoch | Standortfehler oder fehlerhafte Meldung gefährden die Datenqualität |
| Push-Benachrichtigungen | Mittel | Nutzer könnten keine Warnungen erhalten |
| Echtzeit-Updates | Hoch | Verzögerte Daten können falsche Sicherheit vermitteln |
| Offline-Modus | Mittel | Fehlende Daten bei Offline-Nutzung beeinträchtigen Sicherheit |
| Karte & Hotspots | Hoch | Kernfunktion der App, muss korrekt angezeigt werden |
| Mehrsprachigkeit | Niedrig | Wichtig für Nutzerfreundlichkeit, aber nicht sicherheitskritisch |
| Navigation | Mittel | Wichtig für Usability, aber keine Sicherheitsgefahr |

**Risikoanalyse:**  
- Ungenaue GPS-Daten → falsche Hotspot-Darstellung  
- Datenschutzverletzung → Vertrauensverlust  
- App-Absturz bei hoher Nutzerzahl → Datenverlust / schlechte User Experience  

---

## 5. Release-Management
- **Strategie:** Agile Releases in 2-wöchigen Sprints, Big-Bang-Release erst nach Pilot-Test  
- **Release-Typen:**  
  - *Feature-Release*: nach Sprint, intern getestet  
  - *Emergency Release*: kritische Fehlerbehebung  
  - *LTS-Version*: alle 6 Monate für stabile Basis  
- **Deployment:** Phased Release für Beta-Nutzer, Rollback via Firebase-Versionierung  
- **Dokumentation:** Testergebnisse, Feedback und Bugs vor jedem Release dokumentiert  

---

## 6. Repository-Management
- **Branches:**  
  - `main`: stabile Version  
  - `develop`: aktuelle Sprint-Entwicklung  
  - `feature/*`: einzelne Features  
- **Merge-Strategie:** Pull Requests mit Peer-Review & automatisierten Tests  
- **Versionierung:** Semantic Versioning (Major.Minor.Patch)  
- **Tests je Branch:**  
  - `feature/*`: Unit- & Integrationstests  
  - `develop`: System- & Usability-Tests  
  - `main`: Abnahmetests & Blackbox-Test  

---

## 7. Code-Qualität
- **Standards:** Flutter/Dart Coding Guidelines  
- **Code-Reviews:** Jeder Pull Request mindestens ein Peer-Review  
- **Statische Analyse:** Linter + SonarQube  
- **Psychologische Sicherheit:** Entwickler dürfen Änderungen gefahrlos testen, ohne Angst vor Regressionen  

---

## 8. Testumgebung und Verfahren
- **Geräte:** Android (z. B. Samsung A52, Pixel), iPhone (11/14)  
- **Betriebssysteme:** Android 10+, iOS 14+  
- **Netzwerke:** WLAN, 4G/5G, Offline  
- **Testverfahren:** Unit-, Integration-, System-, Usability-, Performance-, Sicherheits- & Pilot-Tests  
- **Testdaten:** GPS-Koordinaten, simulierte Zeckenmeldungen, verschiedene Nutzerprofile  
- **Dokumentation:** Testprotokolle, Fehlerberichte, Feedbackbögen  

---

## 9. Testarten und Aktivitäten

| Testart | Beschreibung | Verantwortlich |
|----------|--------------|----------------|
| Unit Test | Einzelne Komponenten testen | Entwickler |
| Integrationstest | Zusammenspiel von App & Backend | Entwickler |
| Systemtest | App auf realen Geräten testen | Tester |
| Usability-Test | Bedienbarkeit, Verständlichkeit, Barrierefreiheit | Tester + Nutzer |
| Performance-Test | Ladezeiten, Nutzerlast | Entwickler |
| Sicherheitstest | DSGVO, Anonymisierung, Berechtigungen | Tester |
| Offline-Test | Hotspots & Meldungen offline testen | Tester |
| Pilot-Test | 20 reale Nutzer, Feedback sammeln | Team |

---

## 10. Zeitplan der Testaktivitäten

| Phase | Zeitraum | Aktivität |
|--------|-----------|------------|
| Sprint 1–2 | Woche 1–4 | Unit- & Integrationstests, Architekturprüfung |
| Sprint 3 | Woche 5–6 | Usability-Tests & Performance-Vorbereitung |
| Sprint 4 | Woche 7–8 | Pilot-Test mit 20 Personen, Feedback |
| Sprint 5 | Woche 9 | Abnahme, Blackbox- & Regressionstests |
| Sprint 6 | Woche 10 | Release-Vorbereitung & Go-Live |

---

## 11. Blackbox-Testprotokoll

| Testfall-ID | User Story / Anforderung | Beschreibung | Testdaten | Vorbedingungen | Schritte | Erwartetes Ergebnis |
|--------------|--------------------------|--------------|------------|----------------|----------|---------------------|
| **BB-01** | Karte anzeigen | Prüfen, ob Karte Hotspots korrekt lädt | GPS-Koordinaten Zürich | App installiert, GPS aktiv | 1. App starten<br>2. Karte öffnen | Karte zeigt Hotspots in <3 Sekunden |
| **BB-02** | Zecke melden ohne GPS | Prüfen, ob Fehlermeldung erscheint | – | GPS deaktiviert | Zeckenmeldung versuchen | Fehlermeldung „Standort aktivieren“ |
| **BB-03** | Sprache ändern | Prüfen der Mehrsprachigkeit | – | App geöffnet | Einstellungen → Sprache: Französisch | Texte & UI in Französisch |
| **BB-04** | Offline-Modus | Prüfen, ob letzte Hotspots sichtbar sind | Gespeicherte Hotspots | Offline-Modus aktiv | App starten | Letzte Hotspots sichtbar, Hinweis „Keine Live-Daten“ |
| **BB-05** | Push-Warnung | Prüfen der Benachrichtigungen | GPS-Koordinaten Hotspot | App installiert, Push aktiviert | In Hotspot-Bereich gehen | Push-Nachricht erscheint |
| **BB-06** | Erste-Hilfe-Seite | Prüfen der Erste-Hilfe-Anzeigen | – | App geöffnet | Erste-Hilfe-Menü öffnen | Bilder und Texte korrekt angezeigt |
| **BB-07** | Navigation | Prüfen der Navigation & Menüführung | – | App installiert | App öffnen, Menü und Karte aufrufen | Alle Hauptfunktionen erreichbar, keine toten Links |
| **BB-08** | Echtzeit-Hotspots | Prüfen der Live-Aktualisierung | Hotspot wird im Backend neu erstellt | GPS aktiv, Online-Modus | 1. Karte geöffnet lassen<br>2. Neuen Hotspot einfügen | Neuer Hotspot erscheint ohne App-Neustart |

---

## 12. Testziele
Dieses Testkonzept definiert die **Teststrategie, Testmethoden, Testumgebungen und Verantwortlichkeiten** für die TickOff-App.  
Durch systematische Planung, klare Rollen und realistische Tests wird sichergestellt, dass die App **funktional, benutzerfreundlich, sicher und stabil** ist.  

Die Erweiterung um Navigation und Echtzeitdaten sorgt für eine vollständige Abdeckung aller im Projekt definierten User Stories.  
Das Konzept stärkt zudem die **Codequalität**, die **Teamzusammenarbeit** und die **Zuverlässigkeit des Produkts**.
