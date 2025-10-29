# Testkonzept für TickOff (TickApp)

## 1. Testobjekt / Projektbeschreibung
**TickOff** ist eine mobile App, die Wanderern, Touristen, Familien und Hundebesitzern hilft, Zeckenrisiken in der Schweiz frühzeitig zu erkennen und zu melden.  
Die App bietet folgende Funktionen:
- Anzeige von Zecken-Hotspots auf einer Karte (farblich markiert nach Risiko)
- Zeckenmeldung mit Standort, Zeit und Anzahl Zecken
- Push-Benachrichtigungen bei Betreten von Hotspot-Gebieten
- Offline-Modus für Hotspots und Meldungen
- Mehrsprachigkeit (Deutsch, Englisch, Französisch)
- Bebilderte Erste-Hilfe- und Präventionstipps

Zweck: Verbesserung der Sicherheit bei Outdoor-Aktivitäten, Aufbau einer Community-Datenbank und Förderung der Prävention gegen Zeckenbisse.

---

## 2. User Stories (zu testende Funktionen)
- **Karte:** Als Wanderer möchte ich eine farbige Hotspot-Karte sehen, um Zeckenrisiken einzuschätzen.  
- **Zecke melden:** Als Nutzer möchte ich eine Zecke nur mit aktiviertem Standort melden, damit die Meldung korrekt ist.  
- **Einstellungen:** Als Nutzer möchte ich die Sprache ändern können, um die App zu verstehen.  
- **Benachrichtigungen:** Als Elternteil möchte ich Push-Warnungen bei Hotspots erhalten, um meine Kinder zu schützen.  
- **Offline-Funktion:** Als Wanderer möchte ich die letzten Hotspots auch offline sehen, um ohne Internet informiert zu sein.  
- **Erste Hilfe & Prävention:** Als Senior möchte ich bebilderte Anleitungen, damit ich im Notfall richtig handle.

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
|-----------------|--------------|------------|
| Zeckenmeldung | Hoch | Standortfehler oder fehlerhafte Meldung gefährdet die Datenqualität |
| Push-Benachrichtigungen | Mittel | Nutzer könnten keine Warnungen erhalten |
| Offline-Modus | Mittel | Fehlende Daten bei Offline-Nutzung beeinträchtigt Sicherheit |
| Karte & Hotspots | Hoch | Kernfunktion der App, muss korrekt angezeigt werden |
| Mehrsprachigkeit | Niedrig | Wichtig für Nutzerfreundlichkeit, aber nicht sicherheitskritisch |

**Risikoanalyse:**  
- GPS ungenau → falsche Hotspot-Darstellung  
- Datenschutzverletzung → Vertrauensverlust  
- App-Absturz bei hoher Nutzerzahl → Datenverlust / schlechte User Experience

---

## 5. Release-Management
- **Strategie:** Agile Releases, 2-wöchige Sprints, Big Bang Release nur nach erfolgreichem Pilot-Test  
- **Release-Typen:**  
  - Feature-Release (nach Sprint, intern getestet)  
  - Emergency Release (Fehlerbehebung kritisch)  
  - LTS (alle 6 Monate für stabile Version)  
- **Deployment:** Phased Release für Beta-Nutzer, Rollback über Firebase-Versionierung  
- **Dokumentation:** Testergebnisse, Feedbackpunkte und Bugs werden vor jedem Release dokumentiert

---

## 6. Repository-Management
- **Branches:**  
  - `main`: stabile Version  
  - `develop`: aktuelle Sprint-Entwicklung  
  - `feature/*`: einzelne Features  
- **Merge-Strategie:** Pull Requests nach Peer-Review, automatisierte Tests bei Merge  
- **Versionierung:** Semantic Versioning (Major.Minor.Patch)  
- **Tests je Branch:**  
  - `feature/*`: Unit- und Integrationstests  
  - `develop`: Systemtests, Performance, Usability  
  - `main`: Abnahmetests & Blackbox-Test

---

## 7. Code-Qualität
- **Standards:** Flutter/Dart Coding Guidelines  
- **Code-Reviews:** Jeder Pull Request mindestens ein Peer-Review  
- **Statische Analyse:** Linter und SonarQube  
- **Psychologische Sicherheit:** Entwickler können Änderungen testen, ohne Angst vor Regression

---

## 8. Testumgebung und Verfahren
- **Geräte:** Android (Samsung A52, Pixel), iPhone (11/14)  
- **Betriebssysteme:** Android 10+, iOS 14+  
- **Netzwerke:** WLAN, 4G/5G, Offline  
- **Testverfahren:** Unit Tests, Integrationstests, Systemtests, Usability-Tests, Performance-Tests, Sicherheitstests, Pilot-Test  
- **Testdatenerstellung:** GPS-Koordinaten, simulierte Zeckenmeldungen, verschiedene Nutzerprofile  
- **Dokumentation:** Testprotokolle, Fehlerberichte, Feedbackbogen

---

## 9. Testarten und Aktivitäten
| Testart | Beschreibung | Verantwortlich |
|---------|-------------|----------------|
| Unit Test | Einzelne Komponenten testen | Entwickler |
| Integrationstest | Zusammenspiel von App & Backend | Entwickler |
| Systemtest | App auf realen Geräten | Tester |
| Usability-Test | Bedienbarkeit, Verständlichkeit, Barrierefreiheit | Tester + Nutzer |
| Performance-Test | Ladezeiten, Nutzerlast | Entwickler |
| Sicherheitstest | DSGVO, Anonymisierung, Berechtigungen | Tester |
| Offline-Test | Hotspots & Meldungen offline | Tester |
| Pilot-Test | 20 reale Nutzer, Feedback sammeln | Team |

---

## 10. Zeitplan der Testaktivitäten
| Phase | Zeitraum | Aktivität |
|-------|---------|----------|
| Sprint 1–2 | Woche 1–4 | Unit- & Integrationstests, Systemarchitektur prüfen |
| Sprint 3 | Woche 5–6 | Usability-Tests, Performance-Test vorbereiten |
| Sprint 4 | Woche 7–8 | Pilot-Test mit 20 Personen, Feedback sammeln |
| Sprint 5 | Woche 9 | Abnahme, Blackbox-Test, Fehlerbehebung |
| Sprint 6 | Woche 10 | Release-Vorbereitung & Go-Live |

---

## 11. Blackbox-Testprotokoll (Beispiel)

| Testfall-ID | User Story / Anforderung | Beschreibung | Testdaten | Vorbedingungen | Schritte | Erwartetes Ergebnis | Tatsächliches Ergebnis | Abweichung | Ursache | Massnahmen |
|-------------|------------------------|--------------|-----------|----------------|---------|-------------------|----------------------|------------|--------|------------|
| BB-01 | Karte anzeigen | Prüfen, ob Karte Hotspots korrekt lädt | GPS-Koordinaten Zürich | App installiert, GPS aktiv | 1. App starten 2. Karte öffnen | Karte zeigt Hotspots in <3 Sek | | | | |
| BB-02 | Zecke melden ohne GPS | Prüfen, ob Fehlermeldung erscheint | - | GPS deaktiviert | Zecke melden versuchen | Fehlermeldung „Standort aktivieren“ | | | | |
| BB-03 | Sprache ändern auf Französisch | Prüfen der Mehrsprachigkeit | - | App geöffnet | Einstellungen → Sprache Französisch | Texte & UI in Französisch | | | | |
| BB-04 | Offline-Modus | Prüfen, ob letzte Hotspots sichtbar sind | letzte Hotspots gespeichert | Offline-Modus aktiv | App starten | Letzte Hotspots sichtbar + Hinweis „Keine Live-Daten“ | | | | |
| BB-05 | Push-Warnung Hotspot | Prüfen der Benachrichtigungen | GPS-Koordinaten Hotspot | App installiert, Push aktiviert | In Hotspot gehen | Benachrichtigung erscheint | | | | |

---

## 12. Fazit
Dieses Testkonzept definiert die **Teststrategie, Testmethoden, Testumgebungen und Verantwortlichkeiten** für die TickOff-App.  
Durch die systematische Planung, klare Rollenverteilung, Blackbox-Tests, Pilot-Tests und automatisierte Tests wird sichergestellt, dass die App **funktional, benutzerfreundlich, sicher und stabil** ist.  
Das Konzept fördert zudem die **Codequalität**, die **Teamarbeit** und die **psychologische Sicherheit** der Entwickler.
