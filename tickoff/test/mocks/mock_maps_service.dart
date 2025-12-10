/// Mock Maps Service for testing Google Maps functionality
/// 
/// Simulates Google Maps API without requiring actual API keys
import 'dart:async';

class MockMapsService {
  bool _isInitialized = false;
  final Map<String, dynamic> _mapState = {
    'zoom': 12.0,
    'center': {'lat': 47.3769, 'lon': 8.5417}, // Zurich default
  };
  final List<Map<String, dynamic>> _markers = [];
  bool _isMapLoaded = false;

  /// Initialize the maps service
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _isInitialized = true;
  }

  /// Check if service is initialized
  bool isInitialized() {
    return _isInitialized;
  }

  /// Load map
  Future<bool> loadMap() async {
    if (!_isInitialized) {
      throw Exception('Maps service not initialized');
    }

    // Simulate map loading time
    await Future.delayed(const Duration(milliseconds: 500));
    _isMapLoaded = true;
    return true;
  }

  /// Check if map is loaded
  bool isMapLoaded() {
    return _isMapLoaded;
  }

  /// Add marker to map
  void addMarker(Map<String, dynamic> marker) {
    if (!_isMapLoaded) {
      throw Exception('Map not loaded');
    }

    _markers.add(marker);
  }

  /// Remove marker from map
  void removeMarker(String markerId) {
    _markers.removeWhere((marker) => marker['id'] == markerId);
  }

  /// Get all markers
  List<Map<String, dynamic>> getMarkers() {
    return List<Map<String, dynamic>>.from(_markers);
  }

  /// Clear all markers
  void clearMarkers() {
    _markers.clear();
  }

  /// Set map center
  void setCenter(double latitude, double longitude) {
    _mapState['center'] = {'lat': latitude, 'lon': longitude};
  }

  /// Get map center
  Map<String, double> getCenter() {
    final center = _mapState['center'] as Map;
    return {
      'latitude': center['lat'] as double,
      'longitude': center['lon'] as double,
    };
  }

  /// Set zoom level
  void setZoom(double zoom) {
    if (zoom < 1.0 || zoom > 20.0) {
      throw ArgumentError('Zoom level must be between 1.0 and 20.0');
    }
    _mapState['zoom'] = zoom;
  }

  /// Get zoom level
  double getZoom() {
    return _mapState['zoom'] as double;
  }

  /// Add hotspot markers
  void addHotspots(List<Map<String, dynamic>> hotspots) {
    for (var hotspot in hotspots) {
      addMarker({
        'id': hotspot['id'],
        'position': hotspot['location'],
        'riskLevel': hotspot['riskLevel'],
        'icon': _getIconForRiskLevel(hotspot['riskLevel']),
      });
    }
  }

  /// Get icon for risk level
  String _getIconForRiskLevel(String riskLevel) {
    switch (riskLevel) {
      case 'high':
        return 'red_marker';
      case 'medium':
        return 'yellow_marker';
      case 'low':
        return 'green_marker';
      default:
        return 'default_marker';
    }
  }

  /// Simulate geocoding (address to coordinates)
  Future<Map<String, double>?> geocodeAddress(String address) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Mock geocoding for Swiss cities
    final Map<String, Map<String, double>> mockGeocodes = {
      'Zürich': {'latitude': 47.3769, 'longitude': 8.5417},
      'Bern': {'latitude': 46.9480, 'longitude': 7.4474},
      'Basel': {'latitude': 47.5596, 'longitude': 7.5886},
      'Genève': {'latitude': 46.2044, 'longitude': 6.1432},
    };
    
    return mockGeocodes[address];
  }

  /// Simulate reverse geocoding (coordinates to address)
  Future<String?> reverseGeocode(double latitude, double longitude) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Simple mock implementation
    return 'Mock Address, Switzerland';
  }

  /// Check if coordinates are within Switzerland bounds
  bool isInSwitzerland(double latitude, double longitude) {
    // Approximate Switzerland bounds
    const double minLat = 45.8;
    const double maxLat = 47.9;
    const double minLon = 5.9;
    const double maxLon = 10.6;
    
    return latitude >= minLat &&
           latitude <= maxLat &&
           longitude >= minLon &&
           longitude <= maxLon;
  }

  /// Reset to default state
  void reset() {
    _isInitialized = false;
    _isMapLoaded = false;
    _markers.clear();
    _mapState['zoom'] = 12.0;
    _mapState['center'] = {'lat': 47.3769, 'lon': 8.5417};
  }
}
