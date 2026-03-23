import 'dart:convert';
import 'api_service.dart';

class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class UserPreferences {
  final String language;
  final bool notificationsEnabled;
  final String theme;

  const UserPreferences({
    this.language = 'de',
    this.notificationsEnabled = true,
    this.theme = 'system',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] as String? ?? 'de',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      theme: json['theme'] as String? ?? 'system',
    );
  }

  Map<String, dynamic> toJson() => {
        'language': language,
        'notifications_enabled': notificationsEnabled,
        'theme': theme,
      };
}

class UserService {
  UserService._internal();
  static final UserService instance = UserService._internal();

  final ApiService _api = ApiService.instance;

  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _api.get('/api/users/$userId');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserProfile.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  Future<UserProfile?> updateProfile(
    String userId, {
    String? displayName,
  }) async {
    try {
      final response = await _api.put('/api/users/$userId', {
        if (displayName != null) 'display_name': displayName,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserProfile.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  Future<UserPreferences?> getPreferences(String userId) async {
    try {
      final response = await _api.get('/api/users/$userId/preferences');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserPreferences.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  Future<UserPreferences?> updatePreferences(
    String userId,
    UserPreferences prefs,
  ) async {
    try {
      final response = await _api.put(
        '/api/users/$userId/preferences',
        prefs.toJson(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserPreferences.fromJson(data);
      }
    } catch (_) {}
    return null;
  }

  /// DSGVO-compliant account deletion.
  Future<bool> deleteAccount(String userId) async {
    try {
      final response = await _api.delete('/api/users/$userId');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
