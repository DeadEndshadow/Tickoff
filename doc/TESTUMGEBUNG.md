# Testumgebung für TickOff

## Übersicht

Die Testumgebung für TickOff ist eine hybride Infrastruktur, die physische Geräte, Emulatoren und Cloud-Ressourcen kombiniert, um realistische, schnelle und skalierbare Tests zu ermöglichen.

## Ziele

1. **Automatisierte Tests**: Kontinuierliche Integration mit GitHub Actions
2. **Realistische Szenarien**: GPS-Simulation, Offline-Tests, Multi-Sprachen-Support
3. **Sicherheit**: DSGVO-konforme Datenverarbeitung und Schwachstellenscans
4. **Performance**: Schnelle Feedback-Zyklen für Entwickler
5. **Vollständigkeit**: Unit-, Integration-, System- und Blackbox-Tests

## Hardware-Anforderungen

### Empfohlene Testgeräte

#### Physische Geräte
- **Android**: Samsung Galaxy (min. Android 10)
- **iOS**: iPhone (min. iOS 14) - optional
- **Desktop**: Windows 10/11, Ubuntu 20.04+, macOS (optional)

#### Emulatoren/Simulatoren
- Android Emulator (über Android Studio)
- iOS Simulator (macOS only)
- Browser für Web-Tests (Chrome, Firefox)

### Server
- **Host**: 2025hs-sbu142147-stud-gibb-ch
- **IP**: 49.13.165.123
- **OS**: Ubuntu 20.04 LTS oder höher
- **RAM**: Mindestens 4 GB (8 GB empfohlen)
- **Storage**: Mindestens 20 GB frei

## Software und Tools

### Entwicklungsumgebung
- **Flutter SDK**: ^3.9.0 (siehe `pubspec.yaml`)
- **Dart SDK**: Enthalten in Flutter
- **Git**: Version Control
- **IDE**: VS Code oder Android Studio mit Flutter-Plugins

### CI/CD
- **GitHub Actions**: Automatisierte Workflows
  - `flutter_test.yml`: Unit- und Integrationstests
  - `system_test.yml`: System- und UI-Tests
  - `security_scan.yml`: Sicherheitstests

### Backend-Testing
- **Firebase Emulator Suite**: Lokale Firebase-Simulation
  - Firestore Emulator (Port 9099)
  - Auth Emulator (Port 8085)
  - Storage Emulator (Port 9199)
  - Functions Emulator (Port 5001)
  - Emulator UI (Port 4000)

### Containerisierung
- **Docker**: Test-Container-Verwaltung
- **Docker Compose**: Multi-Container-Orchestrierung

### Test-Frameworks
- **flutter_test**: Flutter's eingebautes Test-Framework
- **integration_test**: Für Integrationstests
- **mockito**: Mock-Objekte für Unit-Tests

## Setup-Anleitung

### Schritt 1: Repository klonen

```bash
git clone https://github.com/DeadEndshadow/Tickoff.git
cd Tickoff/tickoff
```

### Schritt 2: Flutter-Abhängigkeiten installieren

```bash
flutter pub get
```

### Schritt 3: Test-Fixtures überprüfen

Stellen Sie sicher, dass folgende Dateien vorhanden sind:
- `test/fixtures/test_hotspots.json`
- `test/fixtures/test_tick_reports.json`
- `test/fixtures/test_first_aid.json`

### Schritt 4: Mock-Services einrichten

Die Mock-Services befinden sich in `test/mocks/`:
- `mock_location_service.dart`: GPS-Simulation
- `mock_firebase_service.dart`: Firebase-Backend-Mock
- `mock_maps_service.dart`: Google Maps API-Mock

### Schritt 5: Lokale Tests ausführen

```bash
# Alle Tests ausführen
flutter test

# Nur Blackbox-Tests
flutter test test/blackbox/

# Mit Coverage-Report
flutter test --coverage

# Coverage-Report anzeigen
genhtml coverage/lcov.info -o coverage/html
```

### Schritt 6: Firebase Emulator starten (optional)

```bash
cd infrastructure
firebase emulators:start
```

Zugriff auf Emulator UI: http://localhost:4000

### Schritt 7: Docker-Container starten (optional)

```bash
cd infrastructure
docker-compose up -d
```

Dies startet:
- Firebase Emulator Suite
- Mock API Server
- Test-Datenbank
- Nginx Reverse Proxy

## Branch-spezifische Test-Strategie

### Feature Branches (`feature/*`)
- **Trigger**: Bei jedem Push und Pull Request
- **Tests**: Unit-Tests, Linting, Code-Analyse
- **Ziel**: Schnelles Feedback für Entwickler

### Develop Branch
- **Trigger**: Bei jedem Push und Pull Request
- **Tests**: Unit-, Integration-, Blackbox- und System-Tests
- **Ziel**: Umfassende Qualitätssicherung vor Merge zu Main

### Main Branch
- **Trigger**: Bei jedem Push und Pull Request
- **Tests**: Vollständige Test-Suite inkl. Security-Scans
- **Ziel**: Production-Ready-Code sicherstellen

## Test-Kategorien

### 1. Unit-Tests
**Pfad**: `test/`
**Kommando**: `flutter test`

Testen einzelne Funktionen und Klassen isoliert.

### 2. Blackbox-Tests
**Pfad**: `test/blackbox/`
**Tests**: BB-01 bis BB-08

- **BB-01**: Map Loading Test (< 3 Sekunden)
- **BB-02**: No GPS Error Handling
- **BB-03**: Language Change (DE/EN/FR)
- **BB-04**: Offline Mode
- **BB-05**: Push Notifications
- **BB-06**: First Aid Information
- **BB-07**: Navigation
- **BB-08**: Real-time Updates

### 3. Integration-Tests
**Pfad**: `integration_test/`
**Kommando**: `flutter test integration_test/`

Testen Zusammenspiel mehrerer Komponenten.

### 4. System-Tests
**Ausführung**: Über `system_test.yml` Workflow

Testen das komplette System End-to-End.

## Performance-Kriterien

- **Map Loading**: < 3 Sekunden
- **API Calls**: < 5 Sekunden
- **Real-time Updates**: < 2 Sekunden
- **Language Switch**: Sofort (< 100ms)
- **Test Execution**: Unter 5 Minuten für vollständige Suite

## Wartungshinweise

### Regelmäßige Aufgaben

#### Wöchentlich
- Security-Scan läuft automatisch (Montag 00:00 UTC)
- Test-Fixtures auf Aktualität prüfen
- Firebase Emulator-Daten bereinigen

#### Monatlich
- Flutter und Abhängigkeiten aktualisieren: `flutter pub upgrade`
- Docker-Images aktualisieren: `docker-compose pull`
- Test-Coverage überprüfen und verbessern

#### Bei Bedarf
- Mock-Services erweitern für neue Features
- Test-Daten aktualisieren
- Dokumentation aktualisieren

### Test-Daten-Management

**Anonymisierung**: Alle Test-Daten sind anonymisiert und enthalten keine PII (Personal Identifiable Information).

**DSGVO-Konformität**:
- Keine echten Nutzerdaten in Tests
- Keine IP-Adressen oder Geräte-IDs
- Nur aggregierte, anonymisierte Standortdaten

### Troubleshooting

#### Tests schlagen fehl
1. Prüfen Sie die Flutter-Version: `flutter --version`
2. Abhängigkeiten neu installieren: `flutter pub get`
3. Cache löschen: `flutter clean`

#### Firebase Emulator startet nicht
1. Port-Konflikte prüfen: `lsof -i :9099`
2. Firebase Tools aktualisieren: `npm install -g firebase-tools`
3. Emulator-Daten löschen: `firebase emulators:exec --clear`

#### Docker-Container starten nicht
1. Docker-Status prüfen: `docker ps`
2. Logs anzeigen: `docker-compose logs`
3. Container neu bauen: `docker-compose up --build`

## Server-Setup

Für die Server-Einrichtung auf 49.13.165.123:

```bash
# Setup-Script ausführen
cd infrastructure
chmod +x setup_server.sh
./setup_server.sh
```

Das Script installiert automatisch:
- Flutter SDK
- Firebase CLI
- Docker & Docker Compose
- Nginx
- Alle erforderlichen Abhängigkeiten

## Nützliche Befehle

```bash
# Tests mit verbose Output
flutter test --reporter expanded

# Nur spezifische Test-Datei
flutter test test/blackbox/bb_01_map_loading_test.dart

# Tests im Watch-Modus
flutter test --watch

# Code formatieren
dart format .

# Statische Analyse
flutter analyze

# Abhängigkeiten prüfen
flutter pub outdated

# Build für verschiedene Plattformen
flutter build apk --release
flutter build web
flutter build linux
```

## Ressourcen

- [Flutter Testing Dokumentation](https://docs.flutter.dev/testing)
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)
- [Docker Compose Dokumentation](https://docs.docker.com/compose/)
- [GitHub Actions Dokumentation](https://docs.github.com/en/actions)

## Support

Bei Fragen oder Problemen:
1. Prüfen Sie die [Dokumentation](../doc/)
2. Suchen Sie in den [Issues](https://github.com/DeadEndshadow/Tickoff/issues)
3. Erstellen Sie ein neues Issue mit dem Label `testing`

---

**Version**: 1.0.0  
**Letzte Aktualisierung**: Dezember 2024
