import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Base HTTP client that automatically attaches JWT tokens to all requests
/// and handles transparent token refresh on 401 responses.
class ApiService {
  ApiService._internal();
  static final ApiService instance = ApiService._internal();

  // Base URL of the backend (Auth Service / Nginx gateway).
  // Override this in tests or via environment configuration.
  static String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:80',
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // ─── Token storage ──────────────────────────────────────────────────────

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // ─── HTTP helpers ───────────────────────────────────────────────────────

  Future<Map<String, String>> _authHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Attempt to refresh the access token using the stored refresh token.
  /// Returns true on success.
  Future<bool> _tryRefresh() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  // ─── Public request methods ─────────────────────────────────────────────

  Future<http.Response> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 401) {
      if (await _tryRefresh()) {
        return http.get(
          Uri.parse('$baseUrl$path'),
          headers: await _authHeaders(),
        );
      }
    }
    return response;
  }

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode == 401) {
      if (await _tryRefresh()) {
        return http.post(
          Uri.parse('$baseUrl$path'),
          headers: await _authHeaders(),
          body: jsonEncode(body),
        );
      }
    }
    return response;
  }

  Future<http.Response> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode == 401) {
      if (await _tryRefresh()) {
        return http.put(
          Uri.parse('$baseUrl$path'),
          headers: await _authHeaders(),
          body: jsonEncode(body),
        );
      }
    }
    return response;
  }

  Future<http.Response> delete(String path, [Map<String, dynamic>? body]) async {
    final request = http.Request('DELETE', Uri.parse('$baseUrl$path'));
    final headers = await _authHeaders();
    request.headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 401) {
      if (await _tryRefresh()) {
        final retryRequest = http.Request('DELETE', Uri.parse('$baseUrl$path'));
        retryRequest.headers.addAll(await _authHeaders());
        if (body != null) retryRequest.body = jsonEncode(body);
        final retryStream = await retryRequest.send();
        return http.Response.fromStream(retryStream);
      }
    }
    return response;
  }
}
