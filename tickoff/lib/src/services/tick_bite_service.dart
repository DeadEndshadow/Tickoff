import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
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

  // Simple device-based user ID (persists across app restarts)
  static String? _deviceUserId;

  String get deviceUserId {
    _deviceUserId ??= 'device_${DateTime.now().millisecondsSinceEpoch}_$hashCode';
    return _deviceUserId!;
  }

  // Set user ID (call this once when app starts)
  static void setDeviceUserId(String id) {
    _deviceUserId = id;
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
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: deviceUserId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TickBite.fromFirestore(doc)).toList());
  }

  /// Add a new tick bite. Tries the backend API first, falls back to Firebase.
  Future<void> addTickBite(LatLng location) async {
    // Try backend API first (routes through auth service gateway)
    try {
      final response = await ApiService.instance.post('/api/reports', {
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
      if (response.statusCode == 201) return;
    } catch (_) {
      // Backend unavailable – fall through to Firebase
    }

    // Firebase fallback
    await _firestore
        .collection(_collection)
        .add(
          TickBite(
            id: '',
            location: location,
            timestamp: DateTime.now(),
            userId: deviceUserId,
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
  Future<void> deleteTickBite(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

