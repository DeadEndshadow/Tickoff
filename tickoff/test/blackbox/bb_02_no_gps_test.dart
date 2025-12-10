/// BB-02: No GPS Test
/// 
/// Tests error handling when GPS is disabled or unavailable
/// Verifies that appropriate error messages are displayed
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_location_service.dart';
import '../mocks/mock_maps_service.dart';

void main() {
  group('BB-02: No GPS Test', () {
    late MockLocationService locationService;
    late MockMapsService mapsService;

    setUp(() {
      locationService = MockLocationService();
      mapsService = MockMapsService();
    });

    tearDown(() {
      locationService.reset();
      mapsService.reset();
    });

    test('Error displayed when GPS is disabled', () async {
      // Arrange
      locationService.setGpsEnabled(false);
      locationService.setLocationPermission(true);

      // Act & Assert
      expect(
        () async => await locationService.getCurrentLocation(),
        throwsException,
      );
      expect(locationService.isGpsEnabled(), isFalse);
    });

    test('Error displayed when location permission is denied', () async {
      // Arrange
      locationService.setGpsEnabled(true);
      locationService.setLocationPermission(false);

      // Act & Assert
      expect(
        () async => await locationService.getCurrentLocation(),
        throwsException,
      );
      expect(locationService.hasLocationPermission(), isFalse);
    });

    test('Permission request can be made', () async {
      // Arrange
      locationService.setLocationPermission(false);

      // Act
      final beforeRequest = locationService.hasLocationPermission();
      locationService.setLocationPermission(true);
      final permissionGranted = await locationService.requestLocationPermission();

      // Assert
      expect(beforeRequest, isFalse);
      expect(permissionGranted, isTrue);
    });

    test('App handles GPS disabled gracefully', () async {
      // Arrange
      locationService.setGpsEnabled(false);

      // Act
      final isEnabled = locationService.isGpsEnabled();
      Exception? caughtException;

      try {
        await locationService.getCurrentLocation();
      } catch (e) {
        caughtException = e as Exception;
      }

      // Assert
      expect(isEnabled, isFalse);
      expect(caughtException, isNotNull);
      expect(caughtException.toString(), contains('GPS is disabled'));
    });

    test('Location returns null when not set and GPS enabled', () async {
      // Arrange
      locationService.setGpsEnabled(true);
      locationService.setLocationPermission(true);
      // Don't set location

      // Act
      final location = await locationService.getCurrentLocation();

      // Assert
      expect(location, isNull);
    });

    test('Map can handle missing location data', () async {
      // Arrange
      await mapsService.initialize();

      // Act - try to load map without location
      final loaded = await mapsService.loadMap();

      // Assert
      expect(loaded, isTrue);
      expect(mapsService.isMapLoaded(), isTrue);
      // Map should load with default center even without user location
    });
  });
}
