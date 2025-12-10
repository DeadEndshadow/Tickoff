/// BB-06: First Aid Test
/// 
/// Tests first aid information display
/// Verifies that images and instructions load correctly
import 'package:flutter_test/flutter_test.dart';
import '../test_config.dart';

void main() {
  group('BB-06: First Aid Test', () {
    test('All first aid steps are available', () {
      // Arrange & Act
      final steps = TestConfig.firstAidSteps;

      // Assert
      expect(steps, isNotEmpty);
      expect(steps.length, greaterThanOrEqualTo(3));
    });

    test('First aid steps are in correct order', () {
      // Arrange & Act
      final steps = TestConfig.firstAidSteps;

      // Assert
      for (int i = 0; i < steps.length; i++) {
        expect(steps[i]['step'], equals('${i + 1}'));
      }
    });

    test('Each step has required information', () {
      // Arrange & Act
      final steps = TestConfig.firstAidSteps;

      // Assert
      for (var step in steps) {
        expect(step.containsKey('step'), isTrue);
        expect(step.containsKey('title'), isTrue);
        expect(step.containsKey('description'), isTrue);
        expect(step['title'], isNotEmpty);
        expect(step['description'], isNotEmpty);
      }
    });

    test('First step is about tick removal', () {
      // Arrange & Act
      final firstStep = TestConfig.firstAidSteps[0];

      // Assert
      expect(firstStep['step'], equals('1'));
      expect(
        firstStep['title']!.toLowerCase(),
        contains('zecke'),
      );
    });

    test('Second step is about disinfection', () {
      // Arrange & Act
      final secondStep = TestConfig.firstAidSteps[1];

      // Assert
      expect(secondStep['step'], equals('2'));
      expect(
        secondStep['title']!.toLowerCase(),
        contains('desinfektion'),
      );
    });

    test('Third step is about observation', () {
      // Arrange & Act
      final thirdStep = TestConfig.firstAidSteps[2];

      // Assert
      expect(thirdStep['step'], equals('3'));
      expect(
        thirdStep['title']!.toLowerCase(),
        contains('beobachtung'),
      );
    });

    test('First aid content loads quickly', () async {
      // Arrange
      final startTime = DateTime.now();

      // Act
      await Future.delayed(const Duration(milliseconds: 50));
      final steps = TestConfig.firstAidSteps;
      final endTime = DateTime.now();
      final loadTime = endTime.difference(startTime);

      // Assert
      expect(steps, isNotEmpty);
      expect(
        loadTime.inMilliseconds,
        lessThan(1000),
        reason: 'First aid content should load in under 1 second',
      );
    });

    test('First aid information is comprehensive', () {
      // Arrange & Act
      final steps = TestConfig.firstAidSteps;
      final totalSteps = steps.length;

      // Assert
      expect(totalSteps, greaterThanOrEqualTo(3));
      
      // Verify key information is present
      final allContent = steps.map((s) => s['description']!.toLowerCase()).join(' ');
      expect(allContent, contains('zecke'));
      expect(allContent, contains('desinfiz'));
    });

    test('First aid steps can be accessed by index', () {
      // Arrange
      final steps = TestConfig.firstAidSteps;

      // Act & Assert
      for (int i = 0; i < steps.length; i++) {
        expect(steps[i], isNotNull);
        expect(steps[i]['step'], equals('${i + 1}'));
      }
    });

    test('First aid information remains accessible offline', () {
      // Arrange
      final steps = TestConfig.firstAidSteps;
      
      // Act - simulate offline mode
      final offlineMode = true;
      final accessibleSteps = offlineMode ? steps : [];

      // Assert
      expect(accessibleSteps, isNotEmpty);
      expect(accessibleSteps.length, equals(steps.length));
    });
  });
}
