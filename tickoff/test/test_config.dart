/// Test configuration for TickOff test environment
/// 
/// This file contains test data and configuration for various testing scenarios
/// including GPS coordinates in Switzerland, mock tick reports, and test user profiles.
class TestConfig {
  // GPS test coordinates for Switzerland with risk levels
  static const Map<String, Map<String, dynamic>> testLocations = {
    'zurich': {
      'lat': 47.3769,
      'lon': 8.5417,
      'risk': 'high',
      'name': 'Zürich',
    },
    'bern': {
      'lat': 46.9480,
      'lon': 7.4474,
      'risk': 'medium',
      'name': 'Bern',
    },
    'basel': {
      'lat': 47.5596,
      'lon': 7.5886,
      'risk': 'low',
      'name': 'Basel',
    },
    'geneva': {
      'lat': 46.2044,
      'lon': 6.1432,
      'risk': 'medium',
      'name': 'Genève',
    },
    'lucerne': {
      'lat': 47.0502,
      'lon': 8.3093,
      'risk': 'high',
      'name': 'Luzern',
    },
  };

  // Simulated tick reports for testing
  static const List<Map<String, dynamic>> mockTickReports = [
    {
      'id': 'report_001',
      'location': {'lat': 47.3769, 'lon': 8.5417},
      'timestamp': '2024-06-15T10:30:00Z',
      'riskLevel': 'high',
      'verified': true,
      'reportCount': 15,
    },
    {
      'id': 'report_002',
      'location': {'lat': 46.9480, 'lon': 7.4474},
      'timestamp': '2024-06-14T14:20:00Z',
      'riskLevel': 'medium',
      'verified': true,
      'reportCount': 8,
    },
    {
      'id': 'report_003',
      'location': {'lat': 47.5596, 'lon': 7.5886},
      'timestamp': '2024-06-13T09:15:00Z',
      'riskLevel': 'low',
      'verified': false,
      'reportCount': 3,
    },
  ];

  // Test user profiles for different scenarios
  static const Map<String, Map<String, dynamic>> testUserProfiles = {
    'standard_user': {
      'id': 'user_001',
      'language': 'de',
      'notificationsEnabled': true,
      'offlineModeEnabled': false,
    },
    'french_user': {
      'id': 'user_002',
      'language': 'fr',
      'notificationsEnabled': true,
      'offlineModeEnabled': false,
    },
    'english_user': {
      'id': 'user_003',
      'language': 'en',
      'notificationsEnabled': false,
      'offlineModeEnabled': true,
    },
    'privacy_conscious_user': {
      'id': 'user_004',
      'language': 'de',
      'notificationsEnabled': false,
      'offlineModeEnabled': true,
    },
  };

  // Test timeouts and performance criteria
  static const Duration mapLoadTimeout = Duration(seconds: 3);
  static const Duration apiCallTimeout = Duration(seconds: 5);
  static const Duration realTimeUpdateTimeout = Duration(seconds: 2);

  // Supported languages
  static const List<String> supportedLanguages = ['de', 'en', 'fr'];

  // Test API endpoints (for mock server)
  static const String mockApiBaseUrl = 'http://localhost:8080/api';
  static const String mockFirebaseUrl = 'http://localhost:9099';

  // DSGVO compliance test data
  static const Map<String, dynamic> gdprTestData = {
    'anonymizedReport': {
      'location': {'lat': 47.3769, 'lon': 8.5417},
      'timestamp': '2024-06-15T10:30:00Z',
      'riskLevel': 'high',
      // No personal identifiable information
    },
  };

  // First aid information test data
  static const List<Map<String, String>> firstAidSteps = [
    {
      'step': '1',
      'title': 'Zecke entfernen',
      'description': 'Zecke vorsichtig mit Pinzette oder Zeckenkarte entfernen',
    },
    {
      'step': '2',
      'title': 'Desinfektion',
      'description': 'Einstichstelle desinfizieren',
    },
    {
      'step': '3',
      'title': 'Beobachtung',
      'description': 'Stichstelle für 4-6 Wochen beobachten',
    },
  ];
}
