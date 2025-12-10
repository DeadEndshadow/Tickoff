# TickOff Test Environment - Quick Reference

## Overview

The TickOff test environment provides comprehensive testing infrastructure for the Flutter-based tick tracking application.

## Quick Start

### 1. Run Tests Locally
```bash
cd tickoff
flutter pub get
flutter test
```

### 2. Start Test Infrastructure
```bash
cd infrastructure
docker-compose up -d
```

### 3. View Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Categories

| Category | Location | Command |
|----------|----------|---------|
| All Tests | `test/` | `flutter test` |
| Blackbox | `test/blackbox/` | `flutter test test/blackbox/` |
| Unit Tests | `test/` | `flutter test --exclude-tags integration` |
| Widget Tests | `test/widget_test.dart` | `flutter test test/widget_test.dart` |

## Blackbox Tests (BB-01 to BB-08)

| Test | File | Purpose |
|------|------|---------|
| BB-01 | `bb_01_map_loading_test.dart` | Map loads in < 3s |
| BB-02 | `bb_02_no_gps_test.dart` | GPS error handling |
| BB-03 | `bb_03_language_change_test.dart` | DE/EN/FR switching |
| BB-04 | `bb_04_offline_mode_test.dart` | Offline functionality |
| BB-05 | `bb_05_push_notifications_test.dart` | Hotspot notifications |
| BB-06 | `bb_06_first_aid_test.dart` | First aid info |
| BB-07 | `bb_07_navigation_test.dart` | App navigation |
| BB-08 | `bb_08_realtime_updates_test.dart` | Real-time sync |

## CI/CD Workflows

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| Unit Tests | `flutter_test.yml` | Push to `feature/*`, `develop`, `main` | Unit & integration tests |
| System Tests | `system_test.yml` | Push to `develop`, `main` | System & UI tests |
| Security | `security_scan.yml` | Push, weekly schedule | Security scanning |

## Infrastructure Services

| Service | Port | URL |
|---------|------|-----|
| Firebase Emulator UI | 4000 | http://localhost:4000 |
| Firestore Emulator | 9099 | localhost:9099 |
| Mock API | 8080 | http://localhost:8080 |
| PostgreSQL | 5432 | localhost:5432 |
| Nginx | 80 | http://localhost |

## Test Data

### Fixtures Location
- `test/fixtures/test_hotspots.json`
- `test/fixtures/test_tick_reports.json`
- `test/fixtures/test_first_aid.json`

### Test Locations (Switzerland)
- Zürich: 47.3769, 8.5417 (high risk)
- Bern: 46.9480, 7.4474 (medium risk)
- Basel: 47.5596, 7.5886 (low risk)

## Key Commands

```bash
# Install dependencies
flutter pub get

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/blackbox/bb_01_map_loading_test.dart

# Analyze code
flutter analyze

# Format code
dart format .

# Start Firebase emulator
cd infrastructure && firebase emulators:start

# Start Docker containers
cd infrastructure && docker-compose up -d

# Server setup (remote)
cd infrastructure && ./setup_server.sh
```

## Performance Targets

| Metric | Target |
|--------|--------|
| Map Loading | < 3 seconds |
| API Response | < 5 seconds |
| Real-time Update | < 2 seconds |
| Language Switch | < 100ms |
| Test Suite | < 5 minutes |

## Documentation

| Document | Location | Description |
|----------|----------|-------------|
| Test Environment | `doc/TESTUMGEBUNG.md` | Full setup guide |
| Test Concept | `doc/Testkonzept.md` | Testing strategy |
| Test Directory | `tickoff/test/README.md` | Test suite guide |
| Infrastructure | `infrastructure/README.md` | Infrastructure docs |

## Common Issues

### Tests Won't Run
```bash
flutter clean
flutter pub get
flutter test
```

### Firebase Emulator Issues
```bash
firebase emulators:exec --clear "echo 'Cleared'"
npm install -g firebase-tools
```

### Docker Problems
```bash
docker-compose down -v
docker-compose up --build
```

## Security & Privacy

- ✅ All test data is anonymized
- ✅ No PII (Personal Identifiable Information)
- ✅ DSGVO/GDPR compliant
- ✅ Firestore rules prevent personal data storage

## Support

1. Check documentation: `doc/TESTUMGEBUNG.md`
2. Review test README: `tickoff/test/README.md`
3. Create issue with `testing` label

## Version Info

- **Flutter**: ^3.9.0 (SDK constraint in pubspec.yaml)
- **Dart**: Included with Flutter
- **Test Framework**: flutter_test, integration_test
- **Mocking**: mockito ^5.4.4

---

**Quick Reference Version**: 1.0.0
**Last Updated**: December 2024
