## Realisierungskonzept

### Ziel
Die mobile Applikation **TickOff** soll Wanderern, Touristen und Outdoor-Enthusiasten helfen, Zeckenrisiken in der Schweiz frühzeitig zu erkennen, zu melden und sich besser zu schützen.  
Das Realisierungskonzept beschreibt den technischen Aufbau, den Projektablauf, die Zuständigkeiten und die verwendeten Tools.

---

### 1. Technische Umsetzung

**Programmiersprache & Framework:**  
- Flutter (Dart) für Cross-Platform-Entwicklung (Android, iOS, Web).  
- Ermöglicht eine einheitliche Codebasis und schnelle Weiterentwicklung.  

**Backend & Datenbank:**  
- Firebase (Cloud Firestore) für Nutzerdaten, Meldungen und Authentifizierung.  
- Firebase Cloud Functions für Push-Benachrichtigungen und Hotspot-Auswertung.  
- Geodaten-Integration über **Google Maps API**.  

**Hosting & Infrastruktur:**  
- Firebase Hosting für App-Backend und statische Daten.  
- GitHub als Versionsverwaltung, inklusive CI/CD-Pipeline.  

**Datenschutz & Sicherheit:**  
- Standortdaten werden anonymisiert gespeichert.  
- DSGVO-konforme Datenverarbeitung.  
- Option zur Deaktivierung der Standortfreigabe in den App-Einstellungen.  

### 1.1 Einrichten der Entwicklungs- und Laufzeitumgebung

Für die Entwicklung von **TickOff** wird eine einheitliche Entwicklungsumgebung eingerichtet:
- **Flutter SDK (3.19.0 oder neuer)** auf macOS und Windows  
- **Android Studio** bzw. **Visual Studio Code** als IDE mit Flutter/Dart-Plugins  
- **GitHub Repository** zur Versionskontrolle und Teamarbeit  
- **GitHub Actions** als CI/CD-Pipeline (automatische Tests, Builds)  
- **Firebase Console** als Laufzeitumgebung für Datenbank, Hosting und Authentifizierung  

Die Umgebung ermöglicht plattformübergreifende Entwicklung (Android, iOS, Web)  
und stellt sicher, dass alle Teammitglieder identische Entwicklungsbedingungen haben.

---

### 2. Entwicklungsprozess

**Vorgehensmodell:**  
- Agiles Vorgehen nach **Scrum** mit zweiwöchigen Sprints.  
- Wöchentliche Teammeetings und Sprint-Reviews.  

**Phasenübersicht:**
| Phase | Zeitraum | Ziele |
|-------|-----------|-------|
| **Planung & Design** | Monat 1–2 | UX/UI-Konzept, technische Architektur, Datenschema |
| **Entwicklung MVP** | Monat 3–5 | Kartenansicht, Zeckenmeldung, Mehrsprachigkeit |
| **Beta-Test & Feedback** | Monat 6–7 | Pilotversuch mit 20 Testnutzern |
| **Optimierung & Launch** | Monat 8–9 | Bugfixes, Offline-Modus, App Store Release |
| **Wartung & Updates** | Ab Monat 10 | Monitoring, neue Features, Partnerintegration |

---

### 3. Rollen & Verantwortlichkeiten

| Teammitglied | Rolle | Aufgaben |
|---------------|--------|----------|
| **Sebastian** | Product Owner / Developer | Projektleitung, Kommunikation, Feature-Planung |
| **Tharun** | Frontend Developer | UI/UX, Kartenansicht, Benutzerinteraktion |
| **Luca** | Backend Developer | Firebase, API-Integration, Datenstruktur |
| **Terence** | Tester | Testfälle, Feedbackauswertung, Qualitätssicherung |
| **Team** | Zusammenarbeit | Wöchentliche Reviews, Code-Reviews, Bugfixes |

---

### 4. Tools & Infrastruktur

| Bereich | Tool | Zweck |
|----------|------|-------|
| Versionskontrolle | GitHub | Repository, Branching, Pull Requests |
| CI/CD | GitHub Actions | Automatische Tests & Builds |
| Projektmanagement | Notion / Trello | Aufgabenplanung & Fortschrittsübersicht |
| Kommunikation | Discord / Teams | Teamkoordination |
| Design | Figma | UI-Prototypen |
| Datenbank & Auth | Firebase | Speicherung, Authentifizierung, Hosting |

---

### 5. Qualitätssicherung

- **Code Reviews:** Jeder Merge in den Main-Branch erfolgt nur nach Peer-Review.  
- **Automatische Tests:** GitHub Actions führt bei jedem Push `flutter test` aus.  
- **Usability Tests:** Durch reale Testnutzer (Senioren, Wanderer, Touristen).  
- **Monitoring:** Firebase Analytics zur Auswertung von Nutzung & Stabilität.  

---

### 6. Zeitplan (übersicht)

| Meilenstein | Termin | Beschreibung |
|--------------|---------|--------------|
| Konzept & Design abgeschlossen | Monat 2 | UI-Design, Datenmodell fertig |
| MVP fertig | Monat 5 | Erste funktionsfähige Version |
| Beta-Test abgeschlossen | Monat 7 | 20 Testnutzer, Feedback integriert |
| App-Launch | Monat 9 | Veröffentlichung in App Stores |
| Erste Partnerschaften aktiv | Monat 10 | Kooperationen mit Apotheken & Tourismusstellen |

---

### 7. Risiken & Massnahmen

| Risiko | Beschreibung | Gegenmassnahme |
|--------|---------------|----------------|
| **Technische Komplexität** | API-Fehler, GPS-Genauigkeit | Frühzeitige Tests & Fallback-Mechanismen |
| **Datenschutzprobleme** | Standortdaten & DSGVO | Klare Einwilligung & Anonymisierung |
| **Fehlende Nutzerakzeptanz** | App wird nicht genutzt | Beta-Tests & gezieltes Feedback |
| **Finanzierungsengpass** | Sponsoren oder Einnahmen fehlen | Freemium-Modell + Tourismuspartner |
| **Überlastung der Infrastruktur** | Viele gleichzeitige Nutzer | Skalierung über Firebase & Cloud-Funktionen |

---

### 8. Erfolgskriterien

- App läuft stabil auf Android & iOS.  
- 80% der Testnutzer bewerten die App mit ≥ 4/5 Sternen.  
- Mindestens 1’000 aktive Nutzer innerhalb des ersten Jahres.  
- 500 Zeckenmeldungen in der ersten Saison.  
- Mindestens 3 aktive Partner (Apotheke, Tourismus, Versicherung).  

---

### Fazit
Das Realisierungskonzept von **TickOff** setzt auf moderne, skalierbare und benutzerfreundliche Technologien.  
Durch agile Entwicklung, eine klare Rollenverteilung und gezielte Partnerintegration wird sichergestellt,  
dass die App zuverlässig funktioniert, leicht erweiterbar bleibt und echten Mehrwert für Outdoor-Begeisterte bietet.
