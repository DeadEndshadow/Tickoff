import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tickoff/src/services/tick_bite_service.dart';

class RiskMapPage extends StatefulWidget {
  const RiskMapPage({super.key});

  @override
  State<RiskMapPage> createState() => _RiskMapPageState();
}

class _RiskMapPageState extends State<RiskMapPage> {
  final MapController _mapController = MapController();
  final TickBiteService _tickBiteService = TickBiteService();
  LatLng? _currentLocation;
  bool _isLoading = false;
  bool _isAddMode = false;

  static final LatLng _initialCenter =
      LatLng(37.42796133580664, -122.085749655962);
  static const double _initialZoom = 14.4746;
  static const double _circleRadiusMeters = 100.0; // Fixed radius in meters

  @override
  void initState() {
    super.initState();
    _askPermission();
  }

  Future<void> _askPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (mounted && status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_currentLocation!, _initialZoom);
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _addTickBiteAtLocation(LatLng location) async {
    setState(() => _isLoading = true);

    try {
      await _tickBiteService.addTickBite(location);
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isAddMode = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        title: const Text('Erfolgreich gespeichert!'),
        content: const Text(
          'Der Zeckenstich wurde erfolgreich gemeldet und auf der Karte markiert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _toggleAddMode() {
    setState(() => _isAddMode = !_isAddMode);
    if (_isAddMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tippe auf die Karte, um einen Zeckenstich zu markieren'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _addAtCurrentLocation() async {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Standort wird ermittelt...'),
          backgroundColor: Colors.orange,
        ),
      );
      await _getCurrentLocation();
      if (_currentLocation == null) return;
    }
    _addTickBiteAtLocation(_currentLocation!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Risiko Karte',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<TickBite>>(
            stream: _tickBiteService.getTickBitesStream(),
            builder: (context, snapshot) {
              final tickBites = snapshot.data ?? [];

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentLocation ?? _initialCenter,
                  initialZoom: _initialZoom,
                  onTap: _isAddMode && !_isLoading
                      ? (tapPosition, latLng) => _addTickBiteAtLocation(latLng)
                      : null,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.tickoff',
                  ),
                  CircleLayer(
                    circles: tickBites.map((bite) {
                      return CircleMarker(
                        point: bite.location,
                        radius: _circleRadiusMeters,
                        useRadiusInMeter: true,
                        color: Colors.red.withValues(alpha: 0.3),
                        borderColor: Colors.red,
                        borderStrokeWidth: 2,
                      );
                    }).toList(),
                  ),
                  if (_currentLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          if (_isAddMode)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tippe auf die Karte, um Zeckenstich zu markieren',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_mode',
            onPressed: _isLoading ? null : _toggleAddMode,
            backgroundColor: _isAddMode ? Colors.blue : Colors.grey,
            child: Icon(_isAddMode ? Icons.close : Icons.add_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_current',
            onPressed: _isLoading ? null : _addAtCurrentLocation,
            backgroundColor: Colors.red,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.my_location),
            label: const Text('Hier melden'),
          ),
        ],
      ),
    );
  }
}
