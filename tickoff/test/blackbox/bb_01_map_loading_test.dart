/// BB-01: Map Loading Test
/// 
/// Tests that the map loads successfully with GPS enabled
/// and displays hotspots within 3 seconds
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_location_service.dart';
import '../mocks/mock_maps_service.dart';
import '../mocks/mock_firebase_service.dart';
import '../test_config.dart';

void main() {
  group('BB-01: Map Loading Test', () {
    late MockLocationService locationService;
    late MockMapsService mapsService;
    late MockFirebaseService firebaseService;

    setUp(() {
      locationService = MockLocationService();
      mapsService = MockMapsService();
      firebaseService = MockFirebaseService();
    });

    tearDown(() {
      locationService.reset();
      mapsService.reset();
      firebaseService.reset();
    });

    test('Map loads successfully when GPS is enabled', () async {
      // Arrange
      final zurich = TestConfig.testLocations['zurich']!;
      locationService.setLocation(
        zurich['lat'] as double,
        zurich['lon'] as double,
      );
      locationService.setGpsEnabled(true);
      locationService.setLocationPermission(true);

      await mapsService.initialize();

      // Act
      final startTime = DateTime.now();
      final location = await locationService.getCurrentLocation();
      await mapsService.loadMap();
      final endTime = DateTime.now();
      final loadTime = endTime.difference(startTime);

      // Assert
      expect(location, isNotNull);
      expect(location!['latitude'], equals(zurich['lat']));
      expect(location['longitude'], equals(zurich['lon']));
      expect(mapsService.isMapLoaded(), isTrue);
      expect(
        loadTime,
        lessThan(TestConfig.mapLoadTimeout),
        reason: 'Map should load within 3 seconds',
      );
    });

    test('Map displays hotspots correctly', () async {
      // Arrange
      await mapsService.initialize();
      await mapsService.loadMap();

      final hotspots = TestConfig.mockTickReports;

      // Act
      mapsService.addHotspots(hotspots);
      final markers = mapsService.getMarkers();

      // Assert
      expect(markers.length, equals(hotspots.length));
      expect(
        markers.every((marker) => marker.containsKey('riskLevel')),
        isTrue,
        reason: 'All markers should have risk level',
      );
    });

    test('Map centers on user location', () async {
      // Arrange
      final bern = TestConfig.testLocations['bern']!;
      locationService.setLocation(
        bern['lat'] as double,
        bern['lon'] as double,
      );

      await mapsService.initialize();
      await mapsService.loadMap();

      // Act
      final location = await locationService.getCurrentLocation();
      mapsService.setCenter(
        location!['latitude']!,
        location['longitude']!,
      );
      final center = mapsService.getCenter();

      // Assert
      expect(center['latitude'], equals(bern['lat']));
      expect(center['longitude'], equals(bern['lon']));
    });

    test('Map loads within performance criteria', () async {
      // Arrange
      await mapsService.initialize();

      // Act
      final startTime = DateTime.now();
      await mapsService.loadMap();
      final endTime = DateTime.now();
      final loadTime = endTime.difference(startTime);

      // Assert
      expect(mapsService.isMapLoaded(), isTrue);
      expect(
        loadTime.inMilliseconds,
        lessThan(3000),
        reason: 'Map must load in under 3 seconds',
      );
    });
  });
}
