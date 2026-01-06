import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

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

  Map<String, dynamic> toFirestore() {
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
    };
  }
}

class TickBiteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'tick_bites';
  
  // Simple device-based user ID (persists across app restarts)
  static String? _deviceUserId;
  
  String get deviceUserId {
    _deviceUserId ??= 'device_${DateTime.now().millisecondsSinceEpoch}_${hashCode}';
    return _deviceUserId!;
  }
  
  // Set user ID (call this once when app starts)
  static void setDeviceUserId(String id) {
    _deviceUserId = id;
  }

  /// Stream of all tick bites from Firestore (for map display)
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

  /// Add a new tick bite to Firestore
  Future<void> addTickBite(LatLng location) async {
    await _firestore.collection(_collection).add(
      TickBite(
        id: '',
        location: location,
        timestamp: DateTime.now(),
        userId: deviceUserId,
      ).toFirestore(),
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Zeitüberschreitung - Bitte überprüfe deine Internetverbindung und Firebase-Konfiguration');
      },
    );
  }

  /// Delete a tick bite from Firestore
  Future<void> deleteTickBite(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
