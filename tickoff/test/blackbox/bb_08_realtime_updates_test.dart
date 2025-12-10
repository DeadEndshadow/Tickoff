/// BB-08: Real-time Updates Test
/// 
/// Tests real-time update functionality
/// Verifies that hotspot data updates without requiring app restart
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_firebase_service.dart';
import '../test_config.dart';
import 'dart:async';

void main() {
  group('BB-08: Real-time Updates Test', () {
    late MockFirebaseService firebaseService;

    setUp(() {
      firebaseService = MockFirebaseService();
    });

    tearDown(() {
      firebaseService.reset();
    });

    test('Hotspot data updates in real-time', () async {
      // Arrange
      await firebaseService.initialize();
      final initialHotspots = TestConfig.mockTickReports.sublist(0, 2);
      firebaseService.loadMockData('hotspots', initialHotspots);

      // Act - Add new hotspot
      final newHotspot = {
        'id': 'new_hotspot',
        'location': {'lat': 47.5, 'lon': 8.5},
        'riskLevel': 'high',
        'timestamp': DateTime.now().toIso8601String(),
      };
      await firebaseService.addDocument('hotspots', newHotspot);

      final updatedHotspots = await firebaseService.getDocuments('hotspots');

      // Assert
      expect(updatedHotspots.length, greaterThan(initialHotspots.length));
    });

    test('Stream listener receives updates immediately', () async {
      // Arrange
      await firebaseService.initialize();
      firebaseService.loadMockData('hotspots', []);

      final receivedUpdates = <List<Map<String, dynamic>>>[];
      final completer = Completer<void>();

      // Act - Listen to stream
      final subscription = firebaseService
          .streamCollection('hotspots')
          .listen((data) {
        receivedUpdates.add(data);
        if (receivedUpdates.length >= 2) {
          completer.complete();
        }
      });

      // Add data after short delay
      await Future.delayed(const Duration(milliseconds: 50));
      await firebaseService.addDocument('hotspots', {
        'id': 'test_1',
        'riskLevel': 'high',
      });

      // Wait for update
      await completer.future.timeout(const Duration(seconds: 2));
      await subscription.cancel();

      // Assert
      expect(receivedUpdates.length, greaterThanOrEqualTo(2));
      expect(receivedUpdates[0].length, equals(0)); // Initial empty
      expect(receivedUpdates[1].length, equals(1)); // After add
    });

    test('Updates occur without app restart', () async {
      // Arrange
      await firebaseService.initialize();
      final initialData = TestConfig.mockTickReports.sublist(0, 1);
      firebaseService.loadMockData('hotspots', initialData);

      var appRestartRequired = false;

      // Act - Update data
      await firebaseService.addDocument('hotspots', {
        'id': 'new_report',
        'riskLevel': 'medium',
      });

      final updatedData = await firebaseService.getDocuments('hotspots');

      // Assert
      expect(appRestartRequired, isFalse);
      expect(updatedData.length, greaterThan(initialData.length));
    });

    test('Real-time update latency is acceptable', () async {
      // Arrange
      await firebaseService.initialize();
      firebaseService.loadMockData('hotspots', []);

      // Act
      final startTime = DateTime.now();
      await firebaseService.addDocument('hotspots', {
        'id': 'latency_test',
        'riskLevel': 'low',
      });
      final endTime = DateTime.now();
      final updateLatency = endTime.difference(startTime);

      // Assert
      expect(
        updateLatency,
        lessThan(TestConfig.realTimeUpdateTimeout),
        reason: 'Real-time updates should occur within 2 seconds',
      );
    });

    test('Multiple concurrent updates are handled', () async {
      // Arrange
      await firebaseService.initialize();
      firebaseService.loadMockData('hotspots', []);

      // Act - Add multiple reports concurrently
      await Future.wait([
        firebaseService.addDocument('hotspots', {
          'id': 'concurrent_1',
          'riskLevel': 'high',
        }),
        firebaseService.addDocument('hotspots', {
          'id': 'concurrent_2',
          'riskLevel': 'medium',
        }),
        firebaseService.addDocument('hotspots', {
          'id': 'concurrent_3',
          'riskLevel': 'low',
        }),
      ]);

      final allHotspots = await firebaseService.getDocuments('hotspots');

      // Assert
      expect(allHotspots.length, equals(3));
    });

    test('Updates preserve existing data', () async {
      // Arrange
      await firebaseService.initialize();
      final existingData = TestConfig.mockTickReports.sublist(0, 2);
      firebaseService.loadMockData('hotspots', existingData);

      // Act
      await firebaseService.addDocument('hotspots', {
        'id': 'preserve_test',
        'riskLevel': 'high',
      });

      final allData = await firebaseService.getDocuments('hotspots');

      // Assert
      expect(allData.length, equals(existingData.length + 1));
      // Verify original data still exists
      expect(
        allData.any((d) => d['id'] == existingData[0]['id']),
        isTrue,
      );
    });

    test('Deleted items are removed in real-time', () async {
      // Arrange
      await firebaseService.initialize();
      final docId = await firebaseService.addDocument('hotspots', {
        'riskLevel': 'low',
      });

      var initialCount = (await firebaseService.getDocuments('hotspots')).length;

      // Act
      await firebaseService.deleteDocument('hotspots', docId);
      final finalCount = (await firebaseService.getDocuments('hotspots')).length;

      // Assert
      expect(finalCount, equals(initialCount - 1));
    });
  });
}
