import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class TickBite {
  final String id;
  final LatLng location;
  final DateTime timestamp;
  final String userId;

  TickBite({
    required this.id,
    required this.location,
    required this.timestamp,
    required this.userId,
  });

  factory TickBite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TickBite(
      id: doc.id,
      location: LatLng(
        data['latitude'] as double,
        data['longitude'] as double,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      userId: data['userId'] as String? ?? '',
    );
  }

  factory TickBite.fromJson(Map<String, dynamic> data, String id) {
    return TickBite(
      id: id,
      location: LatLng(
        (data['latitude'] as num).toDouble(),
        (data['longitude'] as num).toDouble(),
      ),
      timestamp: DateTime.parse(data['timestamp'] as String),
      userId: data['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class TickBiteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'tick_bites';
  static const String _deviceUserIdKey = 'tick_bite_device_user_id';

  // Simple device-based user ID (persists across app restarts)
  static String? _deviceUserId;

  Future<String> get deviceUserId async {
    if (_deviceUserId != null) return _deviceUserId!;

    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString(_deviceUserIdKey);
    if (storedId != null && storedId.isNotEmpty) {
      _deviceUserId = storedId;
      return storedId;
    }

    final generatedId = 'device_${DateTime.now().millisecondsSinceEpoch}';
    _deviceUserId = generatedId;
    await prefs.setString(_deviceUserIdKey, generatedId);
    return generatedId;
  }

  // Set user ID (call this once when app starts)
  static void setDeviceUserId(String id) {
    _deviceUserId = id;
  }

  Future<bool> isOwnedByCurrentUser(TickBite tickBite) async {
    return tickBite.userId == await deviceUserId;
  }

  /// Stream of all tick bites from Firestore (for map display).
  /// Falls back to Firebase if the backend is unreachable.
  Stream<List<TickBite>> getTickBitesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TickBite.fromFirestore(doc)).toList());
  }

  /// Stream of user's own tick bites (for history page)
  Stream<List<TickBite>> getUserTickBitesStream() {
    return Stream.fromFuture(deviceUserId).asyncExpand(
      (currentUserId) => _firestore
          .collection(_collection)
          .where('userId', isEqualTo: currentUserId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map(
            (snapshot) =>
                snapshot.docs.map((doc) => TickBite.fromFirestore(doc)).toList(),
          ),
    );
  }

  /// Add a new tick bite to the app store and mirror it anonymously to the backend when possible.
  Future<void> addTickBite(LatLng location) async {
    final currentUserId = await deviceUserId;

    await _firestore
        .collection(_collection)
        .add(
          TickBite(
            id: '',
            location: location,
            timestamp: DateTime.now(),
            userId: currentUserId,
          ).toFirestore(),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception(
              'Zeitüberschreitung - Bitte überprüfe deine Internetverbindung und Firebase-Konfiguration',
            );
          },
        );

    // Best-effort anonymous backend report for aggregated hotspots.
    try {
      await ApiService.instance.post('/api/reports', {
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
    } catch (_) {
      // Firestore is the source of truth for the in-app map/history experience.
    }
  }

  /// Get nearby hotspots from the backend.
  Future<List<Map<String, dynamic>>> getNearbyHotspots({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
  }) async {
    try {
      final response = await ApiService.instance.post('/api/hotspots/nearby', {
        'latitude': latitude,
        'longitude': longitude,
        'radius': radiusKm,
      });
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  /// Delete a tick bite from Firestore
  Future<void> deleteTickBite(TickBite tickBite) async {
    if (!await isOwnedByCurrentUser(tickBite)) {
      throw StateError('not-owner');
    }

    await _firestore.collection(_collection).doc(tickBite.id).delete();
  }
}

