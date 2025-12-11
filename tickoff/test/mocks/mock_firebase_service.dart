/// Mock Firebase Service for testing backend functionality
/// 
/// Simulates Firebase Firestore, Authentication, and Cloud Functions
import 'dart:async';

class MockFirebaseService {
  final Map<String, dynamic> _dataStore = {};
  final List<StreamController<List<Map<String, dynamic>>>> _listeners = [];
  bool _isOnline = true;

  /// Initialize mock Firebase
  Future<void> initialize() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  /// Add a document to a collection
  Future<String> addDocument(String collection, Map<String, dynamic> data) async {
    if (!_isOnline) {
      throw Exception('Firebase: No internet connection');
    }

    await Future<void>.delayed(const Duration(milliseconds: 50));
    
    final String id = 'mock_${DateTime.now().millisecondsSinceEpoch}';
    final Map<String, dynamic> docWithId = {...data, 'id': id};
    
    if (!_dataStore.containsKey(collection)) {
      _dataStore[collection] = <Map<String, dynamic>>[];
    }
    
    (_dataStore[collection] as List).add(docWithId);
    _notifyListeners(collection);
    
    return id;
  }

  /// Get documents from a collection
  Future<List<Map<String, dynamic>>> getDocuments(String collection) async {
    if (!_isOnline) {
      throw Exception('Firebase: No internet connection');
    }

    await Future<void>.delayed(const Duration(milliseconds: 100));
    
    if (!_dataStore.containsKey(collection)) {
      return [];
    }
    
    return List<Map<String, dynamic>>.from(_dataStore[collection] as List);
  }

  /// Update a document
  Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    if (!_isOnline) {
      throw Exception('Firebase: No internet connection');
    }

    await Future<void>.delayed(const Duration(milliseconds: 50));
    
    if (!_dataStore.containsKey(collection)) {
      throw Exception('Collection not found');
    }
    
    final List<Map<String, dynamic>> docs = _dataStore[collection] as List<Map<String, dynamic>>;
    final int index = docs.indexWhere((doc) => doc['id'] == docId);
    
    if (index == -1) {
      throw Exception('Document not found');
    }
    
    docs[index] = <String, dynamic>{...docs[index], ...data};
    _notifyListeners(collection);
  }

  /// Delete a document
  Future<void> deleteDocument(String collection, String docId) async {
    if (!_isOnline) {
      throw Exception('Firebase: No internet connection');
    }

    await Future<void>.delayed(const Duration(milliseconds: 50));
    
    if (!_dataStore.containsKey(collection)) {
      throw Exception('Collection not found');
    }
    
    final List<Map<String, dynamic>> docs = _dataStore[collection] as List<Map<String, dynamic>>;
    docs.removeWhere((doc) => doc['id'] == docId);
    _notifyListeners(collection);
  }

  /// Listen to real-time updates
  Stream<List<Map<String, dynamic>>> streamCollection(String collection) {
    final controller = StreamController<List<Map<String, dynamic>>>();
    _listeners.add(controller);
    
    // Send initial data
    controller.add(
      _dataStore.containsKey(collection)
        ? List<Map<String, dynamic>>.from(_dataStore[collection] as List)
        : []
    );
    
    return controller.stream;
  }

  /// Notify all listeners of changes
  void _notifyListeners(String collection) {
    final List<Map<String, dynamic>> data = _dataStore.containsKey(collection)
      ? List<Map<String, dynamic>>.from(_dataStore[collection] as List)
      : <Map<String, dynamic>>[];
    
    // Remove closed listeners and notify active ones
    _listeners.removeWhere((listener) => listener.isClosed);
    for (var listener in _listeners) {
      listener.add(data);
    }
  }

  /// Set online/offline state
  void setOnlineState(bool isOnline) {
    _isOnline = isOnline;
  }

  /// Check if service is online
  bool isOnline() {
    return _isOnline;
  }

  /// Clear all data
  void clearData() {
    _dataStore.clear();
    _notifyListeners('');
  }

  /// Load mock data for testing
  void loadMockData(String collection, List<Map<String, dynamic>> data) {
    _dataStore[collection] = List<Map<String, dynamic>>.from(data);
    _notifyListeners(collection);
  }

  /// Dispose all listeners
  void dispose() {
    for (var listener in _listeners) {
      listener.close();
    }
    _listeners.clear();
  }

  /// Reset to default state
  void reset() {
    clearData();
    _isOnline = true;
    dispose();
  }
}
