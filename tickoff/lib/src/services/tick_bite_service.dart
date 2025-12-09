import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class TickBite {
  final String id;
  final LatLng location;
  final DateTime timestamp;

  TickBite({
    required this.id,
    required this.location,
    required this.timestamp,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}

class TickBiteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'tick_bites';

  /// Stream of all tick bites from Firestore
  Stream<List<TickBite>> getTickBitesStream() {
    return _firestore
        .collection(_collection)
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
      ).toFirestore(),
    );
  }

  /// Delete a tick bite from Firestore
  Future<void> deleteTickBite(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
