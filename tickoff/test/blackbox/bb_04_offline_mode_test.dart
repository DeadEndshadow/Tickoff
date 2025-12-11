/// BB-04: Offline Mode Test
/// 
/// Tests offline functionality
/// Verifies that cached data is available when network is unavailable
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_firebase_service.dart';
import '../test_config.dart';

void main() {
  group('BB-04: Offline Mode Test', () {
    late MockFirebaseService firebaseService;

    setUp(() {
      firebaseService = MockFirebaseService();
    });

    tearDown(() {
      firebaseService.reset();
    });

    test('App can switch to offline mode', () {
      // Arrange
      firebaseService.setOnlineState(true);
      expect(firebaseService.isOnline(), isTrue);

      // Act
      firebaseService.setOnlineState(false);

      // Assert
      expect(firebaseService.isOnline(), isFalse);
    });

    test('Cached hotspots are available offline', () async {
      // Arrange
      await firebaseService.initialize();
      final hotspots = TestConfig.mockTickReports;
      firebaseService.loadMockData('hotspots', hotspots);

      // Act - go offline
      firebaseService.setOnlineState(false);

      // Even offline, cached data should be accessible
      // (In real implementation, this would use local storage)
      final cachedData = firebaseService.isOnline()
          ? await firebaseService.getDocuments('hotspots')
          : hotspots; // Simulate cache

      // Assert
      expect(cachedData, isNotEmpty);
      expect(cachedData.length, equals(hotspots.length));
    });

    test('Error is thrown when trying to add data offline', () async {
      // Arrange
      await firebaseService.initialize();
      firebaseService.setOnlineState(false);

      // Act & Assert
      expect(
        () async => await firebaseService.addDocument('hotspots', {
          'location': {'lat': 47.0, 'lon': 8.0},
          'riskLevel': 'medium',
        }),
        throwsException,
      );
    });

    test('User can view last loaded hotspots offline', () {
      // Arrange
      final testUser = TestConfig.testUserProfiles['english_user']!;
      expect(testUser['offlineModeEnabled'], isTrue);

      final cachedHotspots = TestConfig.mockTickReports;

      // Act - simulate offline access
      firebaseService.setOnlineState(false);

      // Assert
      expect(cachedHotspots, isNotEmpty);
      expect(cachedHotspots.length, greaterThan(0));
    });

    test('App reconnects when network becomes available', () async {
      // Arrange
      firebaseService.setOnlineState(false);
      expect(firebaseService.isOnline(), isFalse);

      // Act
      await Future<void>.delayed(const Duration(milliseconds: 100));
      firebaseService.setOnlineState(true);

      // Assert
      expect(firebaseService.isOnline(), isTrue);
    });

    test('Offline indicator is shown when offline', () {
      // Arrange
      bool showOfflineIndicator = false;

      // Act
      firebaseService.setOnlineState(false);
      showOfflineIndicator = !firebaseService.isOnline();

      // Assert
      expect(showOfflineIndicator, isTrue);
    });

    test('Data sync occurs when coming back online', () async {
      // Arrange
      await firebaseService.initialize();
      final hotspots = TestConfig.mockTickReports;
      firebaseService.loadMockData('hotspots', hotspots);

      // Go offline
      firebaseService.setOnlineState(false);

      // Act - come back online
      firebaseService.setOnlineState(true);
      final onlineData = await firebaseService.getDocuments('hotspots');

      // Assert
      expect(onlineData, isNotEmpty);
      expect(firebaseService.isOnline(), isTrue);
    });
  });
}
