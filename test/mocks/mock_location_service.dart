/// Mock Location Service for testing GPS functionality
/// 
/// Simulates GPS location services without requiring actual device hardware
library mock_location_service;

import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

class MockLocationService {
  double? _latitude;
  double? _longitude;
  bool _isGpsEnabled = true;
  bool _hasPermission = true;

  /// Set mock location
  void setLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
  }

  /// Get current location
  Future<Map<String, double>?> getCurrentLocation() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (!_isGpsEnabled) {
      throw Exception('GPS is disabled');
    }

    if (!_hasPermission) {
      throw Exception('Location permission not granted');
    }

    if (_latitude == null || _longitude == null) {
      return null;
    }

    return {
      'latitude': _latitude!,
      'longitude': _longitude!,
    };
  }

  /// Check if GPS is enabled
  bool isGpsEnabled() {
    return _isGpsEnabled;
  }

  /// Set GPS enabled state
  void setGpsEnabled(bool enabled) {
    _isGpsEnabled = enabled;
  }

  /// Check if location permission is granted
  bool hasLocationPermission() {
    return _hasPermission;
  }

  /// Set location permission state
  void setLocationPermission(bool granted) {
    _hasPermission = granted;
  }

  /// Request location permission (mock)
  Future<bool> requestLocationPermission() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return _hasPermission;
  }

  /// Calculate distance between two coordinates in kilometers
  double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // kilometers
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_degreesToRadians(lat1)) *
      math.cos(_degreesToRadians(lat2)) *
      math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final double c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Reset mock to default state
  void reset() {
    _latitude = null;
    _longitude = null;
    _isGpsEnabled = true;
    _hasPermission = true;
  }
}
