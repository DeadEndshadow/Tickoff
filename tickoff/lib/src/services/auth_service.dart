import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const _userIdKey = 'user_id';

  final ApiService _api = ApiService.instance;

  // ─── Token / session helpers ─────────────────────────────────────────────

  Future<String?> get userId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<bool> get isLoggedIn async {
    final token = await _api.getAccessToken();
    return token != null;
  }

  Future<void> _saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, id);
  }

  Future<void> _clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  // ─── Auth operations ─────────────────────────────────────────────────────

  /// Register a new user. Returns null on success, error message on failure.
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        await _api.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        await _saveUserId(data['userId'] as String);
        return null;
      }
      return data['error'] as String? ?? 'Registration failed';
    } catch (e) {
      return 'Network error: $e';
    }
  }

  /// Login with email and password. Returns null on success, error message on failure.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        await _api.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        await _saveUserId(data['userId'] as String);
        return null;
      }
      return data['error'] as String? ?? 'Login failed';
    } catch (e) {
      return 'Network error: $e';
    }
  }

  /// Logout – invalidates the refresh token on the server and clears local storage.
  Future<void> logout() async {
    try {
      final refreshToken = await _api.getRefreshToken();
      if (refreshToken != null) {
        await http.post(
          Uri.parse('${ApiService.baseUrl}/auth/logout'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );
      }
    } catch (_) {}
    await _api.clearTokens();
    await _clearUserId();
  }

  /// Verify the current access token. Returns true if still valid.
  Future<bool> verifyToken() async {
    try {
      final response = await _api.get('/auth/verify');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
