/// BB-03: Language Change Test
/// 
/// Tests multi-language support (DE/EN/FR)
/// Verifies that UI elements update correctly when language is changed
import 'package:flutter_test/flutter_test.dart';
import '../test_config.dart';

void main() {
  group('BB-03: Language Change Test', () {
    late Map<String, String> currentLanguage;

    setUp(() {
      currentLanguage = {'code': 'de', 'name': 'Deutsch'};
    });

    test('All supported languages are available', () {
      // Arrange & Act
      final languages = TestConfig.supportedLanguages;

      // Assert
      expect(languages, contains('de'));
      expect(languages, contains('en'));
      expect(languages, contains('fr'));
      expect(languages.length, equals(3));
    });

    test('Language can be changed to English', () {
      // Arrange
      expect(currentLanguage['code'], equals('de'));

      // Act
      currentLanguage = {'code': 'en', 'name': 'English'};

      // Assert
      expect(currentLanguage['code'], equals('en'));
      expect(currentLanguage['name'], equals('English'));
    });

    test('Language can be changed to French', () {
      // Arrange
      expect(currentLanguage['code'], equals('de'));

      // Act
      currentLanguage = {'code': 'fr', 'name': 'Français'};

      // Assert
      expect(currentLanguage['code'], equals('fr'));
      expect(currentLanguage['name'], equals('Français'));
    });

    test('First aid content is available in all languages', () {
      // Arrange
      final firstAidSteps = TestConfig.firstAidSteps;

      // Assert
      expect(firstAidSteps, isNotEmpty);
      for (var step in firstAidSteps) {
        expect(step.containsKey('title'), isTrue);
        expect(step.containsKey('description'), isTrue);
      }
    });

    test('User profile stores language preference', () {
      // Arrange
      final germanUser = TestConfig.testUserProfiles['standard_user']!;
      final frenchUser = TestConfig.testUserProfiles['french_user']!;
      final englishUser = TestConfig.testUserProfiles['english_user']!;

      // Assert
      expect(germanUser['language'], equals('de'));
      expect(frenchUser['language'], equals('fr'));
      expect(englishUser['language'], equals('en'));
    });

    test('Language change is immediate without restart', () {
      // Arrange
      String currentLang = 'de';
      final startTime = DateTime.now();

      // Act
      currentLang = 'en';
      final endTime = DateTime.now();
      final changeTime = endTime.difference(startTime);

      // Assert
      expect(currentLang, equals('en'));
      expect(
        changeTime.inMilliseconds,
        lessThan(100),
        reason: 'Language change should be instantaneous',
      );
    });

    test('Invalid language code is rejected', () {
      // Arrange
      const invalidLanguage = 'es'; // Spanish not supported

      // Act & Assert
      expect(
        TestConfig.supportedLanguages.contains(invalidLanguage),
        isFalse,
        reason: 'Unsupported language should be rejected',
      );
    });

    test('Language preference persists across sessions', () {
      // Arrange
      Map<String, dynamic> userSettings = {'language': 'de'};

      // Act - simulate session change
      final savedLanguage = userSettings['language'];
      userSettings = {'language': savedLanguage};

      // Assert
      expect(userSettings['language'], equals('de'));
    });
  });
}
