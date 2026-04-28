import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _collection = 'Auth';

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Session helpers ------------------------------------------------------

  Future<String?> get userId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> _saveSession(String userId, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  // --- Crypto helpers -------------------------------------------------------

  static const _passwordSalt = 'tickoff_2026_salt';

  String _hashPassword(String password) {
    final bytes = utf8.encode(password + _passwordSalt);
    return sha256.convert(bytes).toString();
  }

  String _generateToken() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  // --- Firestore lookup helpers ---------------------------------------------

  Future<DocumentSnapshot?> _findByEmail(String email) async {
    final q = await _db
        .collection(_collection)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return q.docs.isEmpty ? null : q.docs.first;
  }

  Future<DocumentSnapshot?> _findByUsername(String username) async {
    final q = await _db
        .collection(_collection)
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return q.docs.isEmpty ? null : q.docs.first;
  }

  Future<DocumentSnapshot?> _findByIdentifier(String identifier) async {
    final byEmail = await _findByEmail(identifier);
    if (byEmail != null) return byEmail;
    return _findByUsername(identifier);
  }

  // --- Auth operations ------------------------------------------------------

  /// Register a new user. Returns null on success, error message on failure.
  Future<String?> register({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      final existingEmail = await _findByEmail(email);
      if (existingEmail != null) return 'E-Mail bereits registriert';

      if (username != null && username.isNotEmpty) {
        final existingUsername = await _findByUsername(username);
        if (existingUsername != null) return 'Benutzername bereits vergeben';
      }

      final token = _generateToken();
      final docRef = _db.collection(_collection).doc();
      await docRef.set({
        'email': email,
        'username': username ?? '',
        'passwort': _hashPassword(password),
        'token': token,
      });

      await _saveSession(docRef.id, token);
      return null;
    } catch (e) {
      return 'Fehler: $e';
    }
  }

  /// Login with email or username. Returns null on success, error message on failure.
  Future<String?> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final doc = await _findByIdentifier(identifier);
      if (doc == null) return 'Ungueltige Anmeldedaten';

      final data = doc.data() as Map<String, dynamic>;
      if (data['passwort'] != _hashPassword(password)) {
        return 'Ungueltige Anmeldedaten';
      }

      final token = _generateToken();
      await doc.reference.update({'token': token});
      await _saveSession(doc.id, token);
      return null;
    } catch (e) {
      return 'Fehler: $e';
    }
  }

  /// Logout - clears token from Firestore and local storage.
  Future<void> logout() async {
    try {
      final id = await userId;
      if (id != null) {
        await _db.collection(_collection).doc(id).update({'token': ''});
      }
    } catch (_) {}
    await _clearSession();
  }

  /// Returns current user data map (email, username) or null if not logged in.
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final id = await userId;
      if (id == null) return null;
      final doc = await _db.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>;
      return {'email': data['email'] ?? '', 'username': data['username'] ?? ''};
    } catch (_) {
      return null;
    }
  }

  /// Update username. Returns null on success, error message on failure.
  Future<String?> updateUsername(String newUsername) async {
    try {
      if (newUsername.isEmpty) return 'Benutzername darf nicht leer sein';
      final existing = await _findByUsername(newUsername);
      if (existing != null) return 'Benutzername bereits vergeben';
      final id = await userId;
      if (id == null) return 'Nicht angemeldet';
      await _db.collection(_collection).doc(id).update({'username': newUsername});
      return null;
    } catch (e) {
      return 'Fehler: $e';
    }
  }

  /// Update email. Returns null on success, error message on failure.
  Future<String?> updateEmail(String newEmail) async {
    try {
      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(newEmail)) {
        return 'Ungültige E-Mail-Adresse';
      }
      final existing = await _findByEmail(newEmail);
      if (existing != null) return 'E-Mail bereits registriert';
      final id = await userId;
      if (id == null) return 'Nicht angemeldet';
      await _db.collection(_collection).doc(id).update({'email': newEmail});
      return null;
    } catch (e) {
      return 'Fehler: $e';
    }
  }

  /// Change password. Returns null on success, error message on failure.
  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (newPassword.length < 8) return 'Passwort muss mindestens 8 Zeichen haben';
      final id = await userId;
      if (id == null) return 'Nicht angemeldet';
      final doc = await _db.collection(_collection).doc(id).get();
      if (!doc.exists) return 'Benutzer nicht gefunden';
      final data = doc.data() as Map<String, dynamic>;
      if (data['passwort'] != _hashPassword(currentPassword)) {
        return 'Aktuelles Passwort ist falsch';
      }
      await doc.reference.update({'passwort': _hashPassword(newPassword)});
      return null;
    } catch (e) {
      return 'Fehler: $e';
    }
  }

  /// Delete account permanently.
  Future<String?> deleteAccount(String password) async {
    try {
      final id = await userId;
      if (id == null) return 'Nicht angemeldet';
      final doc = await _db.collection(_collection).doc(id).get();
      if (!doc.exists) return 'Benutzer nicht gefunden';
      final data = doc.data() as Map<String, dynamic>;
      if (data['passwort'] != _hashPassword(password)) {
        return 'Falsches Passwort';
      }
      await doc.reference.delete();
      await _clearSession();
      return null;
    } catch (e) {
      return 'Fehler: $e';
    }
  }
}
