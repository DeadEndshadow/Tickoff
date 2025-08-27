# TickOff Dokumentation

## Akzeptanzkriterien für TickOff

### 1. Nutzerfreundlichkeit & Mehrsprachigkeit
- Die App besteht aus genau drei Hauptbuttons in der unteren Navigation:  
  - **Karte** (Standardansicht, zeigt Hotspots)  
  - **Zecke melden** (öffnet Reporting-Funktion)  
  - **Einstellungen/Info** (Sprache wählen, Erste-Hilfe-Infos, App-Infos)  
- Alle Texte und UI-Elemente sind in mindestens **3 Sprachen** verfügbar: Deutsch, Englisch, Französisch.  
- Die Sprache kann jederzeit im **Einstellungsmenü** gewechselt werden.  
- **80% der Testnutzer** (inkl. Senioren) schaffen es, eine Zeckenmeldung innerhalb von **1 Minute** erfolgreich durchzuführen.  
- Die **Info-Seite** enthält verständliche, bebilderte Erste-Hilfe-Anleitungen und Präventionstipps.  

---

### 2. Performance & Agilität
- Die App lädt die **Kartenansicht** in unter **3 Sekunden** auf einem durchschnittlichen Smartphone.  
- Eine Meldung (inkl. Standortdaten) wird in **maximal 30 Sekunden** in der Datenbank gespeichert und auf der Karte sichtbar.  
- Die App läuft stabil bei mindestens **1.000 gleichzeitigen Nutzern** ohne Absturz.  
- Neue Funktionen und Bugfixes können durch einen **agilen Entwicklungsprozess** (z. B. Sprints von 2 Wochen) eingespielt werden.  

---

### 3. Kernfunktionen
### Karte
- Zeigt Hotspots von Zeckenmeldungen.  
- Hotspots werden farblich markiert (z. B. grün, orange, rot).  

#### Zecke melden
- Meldungen sind nur mit **aktiviertem Standort** möglich.  
- Jede Meldung enthält: **Standort, Zeitstempel, Anzahl Zecken**.  

#### Einstellungen/Info
- Sprache wählen (Deutsch, Englisch, Französisch).  
- Erste-Hilfe-Anleitungen zu Zeckenbissen.  
- Informationen zu Prävention und Krankheiten (FSME, Borreliose).  

#### Benachrichtigungen
- Nutzer erhalten **Push-Notifications**, wenn sie sich in einem Gebiet mit vielen Meldungen befinden.  

#### Datenbank
- Meldungen werden **anonymisiert gespeichert**.  
- Datenbank ist **DSGVO-konform**.  

---

### 4. Sicherheit & Datenschutz
- Standortdaten werden **ausschliesslich** für die Zeckenmeldung verwendet.  
- Alle Meldungen werden **anonymisiert gespeichert**.  
- Die App entspricht den Anforderungen der **DSGVO**.  
- Nutzer können in den Einstellungen die **Standortfreigabe jederzeit deaktivieren**.  

---

### 5. Pilot-Testing & Feedback
- Vor dem offiziellen Launch wird ein Pilot-Test mit mindestens **20 Personen durchgeführt (inkl. Senioren, Jugendlichen, Hundebesitzern).  
- Es werden mindestens 50 konkrete Feedbackpunkte dokumentiert.  
- Die häufigsten 5 Probleme aus dem Feedback sind vor Launch behoben.  

--- 

### 6. Usability & Barrierefreiheit
- Die Schriftgrösse ist skalierbar (oder an das System angepasst).
- Buttons und Icons sind entsprechend Apple/Google UI-Richtlinien.  
- Die App erfüllt WCAG-Standards (z. B. Farbkontrast für Menschen mit Sehschwäche).  
- Ein einfacher Onboarding-Screen erklärt beim ersten Start in 3 Schritten, wie die App funktioniert.  

---

### 7. Offline-Funktionalität
- Die Karte bleibt auch **offline sichtbar**, zumindest mit den letzten geladenen Hotspots.  
- Zeckenmeldungen können **offline gespeichert** und beim nächsten Internetzugang hochgeladen werden.  
- Nutzer erhalten einen **Hinweis**, wenn sie ohne Internet keine Live-Daten sehen.  

---

### 8. Wartbarkeit & Erweiterbarkeit
- Der **Quellcode** ist so strukturiert, dass neue Sprachen oder zusätzliche Features (z. B. Tiermeldungen) ohne komplette Neuentwicklung ergänzt werden können.  
- Die App verwendet **modulare APIs**.  
- **Updates** können ohne Datenverlust eingespielt werden.  

---

### 9. Monitoring & Erfolgsmessung
- Es gibt ein **Analytics-Dashboard** (z. B. Firebase), das anzeigt:  
  - Anzahl aktiver Nutzer pro Monat  
  - Anzahl Meldungen pro Region  
  - Aufrufrate der Erste-Hilfe-Seite  
- **Projektziel:** Mindestens 1.000 monatlich aktive Nutzer innerhalb des ersten Jahres.  
- Nutzer können anonym **Feedback** über die App geben (1–5 Sterne + Kommentar).

# SMART-Ziele für TickOff

### 1. Nutzerfreundlichkeit & Einfachheit
- **Spezifisch:** Die App soll für alle Altersgruppen leicht verständlich sein, mit einer Hauptansicht „Karte“ und maximal 2 Unterseiten („Zecke melden“ & „Einstellungen“).  
- **Messbar:** Mindestens 80% der Testnutzer (junge Erwachsene + Senioren) schaffen es, innerhalb von 1 Minute einen Zeckenfund zu melden.  
- **Attraktiv/Erreichbar:** Durch klare Icons, grosse Buttons und Vermeidung von unnötigen Menüs.  
- **Relevant:** Einfache Bedienung = höhere Akzeptanz bei älteren Nutzern.  
- **Terminiert:** Erreichen bis zur Beta-Version (6 Monate nach Projektstart).  

---

### 2. Mehrsprachigkeit & Inklusion
- **Spezifisch:** Die App wird in mindestens 3 Sprachen angeboten (Deutsch, Englisch, Französisch), später optional Italienisch.  
- **Messbar:** Alle Kernfunktionen (Karte, Meldung, Einstellungen) sind sprachlich übersetzt und werden im Usability-Test von Muttersprachlern verstanden.  
- **Attraktiv/Erreichbar:** Nutzung von standardisierten Übersetzungstools & Muttersprachler-Tests.  
- **Relevant:** Touristen (wie bei der Persona „Tourismus“) sollen die App ebenfalls nutzen können.  
- **Terminiert:** Bis zum offiziellen Launch (12 Monate nach Projektstart).  

---

### 3. Community & Datenqualität
- **Spezifisch:** Aufbau einer Datenbasis durch Nutzerberichte (Crowdsourcing).  
- **Messbar:** Mindestens 500 Zeckenmeldungen in der ersten Saison (Mai–September/Oktober) durch Nutzer.  
- **Attraktiv/Erreichbar:** Mit Push-Benachrichtigungen („Warst du heute draussen? Hast du eine Zecke gesehen?“) und einfacher Reporting-Funktion.  
- **Relevant:** Ohne Daten keine verlässliche Risikokarte → Kernfunktion.  
- **Terminiert:** Innerhalb der ersten 5 Monate nach Launch.   

---

### 4. Pilot-Testing & Feedback
- **Spezifisch:** Durchführung eines Pilot-Tests mit mindestens 20 Personen (darunter Senioren, Jugendliche und Hundebesitzer).  
- **Messbar:** Sammeln von 50 konkreten Feedbackpunkten zu Bedienung, Nützlichkeit und Verständlichkeit.  
- **Attraktiv/Erreichbar:** Rekrutierung über Familie, Vereine, Wandergruppen.  
- **Relevant:** Nur durch Nutzerfeedback lässt sich die App wirklich optimieren.  
- **Terminiert:** Innerhalb von 3 Monaten nach MVP-Release.  

# Rollenverteilung
- Tharun: Developer (Frontend)
- Luca: Developer (Backend)
- Terence: Tester
- Sebastian: Product owner, developer
