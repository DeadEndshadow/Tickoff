# TickOff Test Suite

This directory contains the complete test suite for the TickOff application.

## Test Structure

```
test/
├── blackbox/              # Blackbox tests (BB-01 to BB-08)
├── fixtures/              # Test data (JSON files)
├── mocks/                 # Mock services for testing
├── flutter_test_config.dart  # Test runner configuration
├── test_config.dart       # Test configuration and constants
└── widget_test.dart       # Widget tests
```

## Test Categories

### 1. Blackbox Tests (`blackbox/`)

These tests verify application functionality from a user's perspective without knowledge of internal implementation.

- **BB-01: Map Loading Test** (`bb_01_map_loading_test.dart`)
  - Verifies map loads within 3 seconds with GPS enabled
  - Tests hotspot display on map
  - Validates map centering on user location

- **BB-02: No GPS Test** (`bb_02_no_gps_test.dart`)
  - Tests error handling when GPS is disabled
  - Verifies permission request flow
  - Checks graceful degradation

- **BB-03: Language Change Test** (`bb_03_language_change_test.dart`)
  - Tests switching between DE/EN/FR
  - Verifies UI updates without restart
  - Validates language persistence

- **BB-04: Offline Mode Test** (`bb_04_offline_mode_test.dart`)
  - Tests offline functionality
  - Verifies cached data access
  - Validates sync on reconnection

- **BB-05: Push Notifications Test** (`bb_05_push_notifications_test.dart`)
  - Tests notification triggers in hotspot areas
  - Verifies notification permissions
  - Checks risk-level-based notifications

- **BB-06: First Aid Test** (`bb_06_first_aid_test.dart`)
  - Tests first aid information loading
  - Verifies step-by-step instructions
  - Validates multi-language support

- **BB-07: Navigation Test** (`bb_07_navigation_test.dart`)
  - Tests app navigation flow
  - Verifies all menu items accessible
  - Checks back navigation

- **BB-08: Real-time Updates Test** (`bb_08_realtime_updates_test.dart`)
  - Tests real-time data synchronization
  - Verifies updates without restart
  - Validates concurrent updates

### 2. Mock Services (`mocks/`)

Mock implementations for testing without external dependencies:

- **mock_location_service.dart**: GPS and location simulation
- **mock_firebase_service.dart**: Firebase Firestore mocking
- **mock_maps_service.dart**: Google Maps API simulation

### 3. Test Fixtures (`fixtures/`)

JSON files with test data:

- **test_hotspots.json**: Simulated tick hotspots in Switzerland
- **test_tick_reports.json**: Anonymized tick reports
- **test_first_aid.json**: First aid instructions (DE/EN/FR)

### 4. Configuration (`test_config.dart`)

Central configuration for all tests including:
- GPS test coordinates for Swiss cities
- Mock tick reports
- Test user profiles
- Performance criteria
- Supported languages

## Running Tests

### All Tests
```bash
flutter test
```

### Specific Test File
```bash
flutter test test/blackbox/bb_01_map_loading_test.dart
```

### Blackbox Tests Only
```bash
flutter test test/blackbox/
```

### With Coverage
```bash
flutter test --coverage
```

### Verbose Output
```bash
flutter test --reporter expanded
```

### Watch Mode
```bash
flutter test --watch
```

## Test Data

### GPS Coordinates (Switzerland)

| City | Latitude | Longitude | Risk Level |
|------|----------|-----------|------------|
| Zürich | 47.3769 | 8.5417 | high |
| Bern | 46.9480 | 7.4474 | medium |
| Basel | 47.5596 | 7.5886 | low |
| Genève | 46.2044 | 6.1432 | medium |
| Luzern | 47.0502 | 8.3093 | high |

### Test User Profiles

- **standard_user**: German language, notifications enabled
- **french_user**: French language, notifications enabled
- **english_user**: English language, offline mode enabled
- **privacy_conscious_user**: Notifications disabled, offline mode

## Performance Criteria

| Metric | Target |
|--------|--------|
| Map Loading | < 3 seconds |
| API Calls | < 5 seconds |
| Real-time Updates | < 2 seconds |
| Language Switch | < 100ms |

## Writing New Tests

### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import '../test_config.dart';

void main() {
  group('Feature Name', () {
    setUp(() {
      // Setup code
    });

    tearDown(() {
      // Cleanup code
    });

    test('Should do something', () {
      // Arrange
      
      // Act
      
      // Assert
    });
  });
}
```

### Using Mock Services

```dart
import '../mocks/mock_location_service.dart';

final locationService = MockLocationService();
locationService.setLocation(47.3769, 8.5417);
final location = await locationService.getCurrentLocation();
```

## Best Practices

1. **Isolation**: Each test should be independent
2. **Cleanup**: Always reset mocks in `tearDown()`
3. **Naming**: Use descriptive test names
4. **Assertions**: Clear and specific assertions
5. **Anonymization**: No PII in test data
6. **Documentation**: Comment complex test logic

## DSGVO/GDPR Compliance

All test data is:
- ✅ Anonymized (no personal information)
- ✅ Aggregated (no individual tracking)
- ✅ Synthetic (generated for testing)
- ✅ GDPR-compliant (no real user data)

## Troubleshooting

### Tests Fail to Run

1. Check Flutter version: `flutter --version`
2. Get dependencies: `flutter pub get`
3. Clean build: `flutter clean`

### Mock Service Issues

```dart
// Always reset mocks in tearDown
tearDown(() {
  locationService.reset();
  mapsService.reset();
  firebaseService.reset();
});
```

### Test Data Not Found

Ensure fixture files exist:
```bash
ls -la test/fixtures/
```

## CI/CD Integration

Tests run automatically on:
- Push to `feature/*`, `develop`, `main` branches
- Pull requests
- See `.github/workflows/` for CI configuration

## Resources

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Test Configuration](test_config.dart)
- [Test Environment Docs](../doc/TESTUMGEBUNG.md)

## Contributing

When adding new tests:
1. Follow existing naming conventions
2. Add test documentation
3. Update this README
4. Ensure tests pass locally before PR
5. Add to appropriate test category

---

**Test Coverage Goal**: > 80%
**Last Updated**: December 2024
