import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiskMapPage extends StatefulWidget {
  const RiskMapPage({Key? key}) : super(key: key);

  @override
  State<RiskMapPage> createState() => _RiskMapPageState();

  
}

class _RiskMapPageState extends State<RiskMapPage> {
  late GoogleMapController _mapController;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // Beispielhafte Risikopunkte für die Schweiz
  final Set<Marker> _riskMarkers = {
    Marker(
      markerId: MarkerId('risk1'),
      position: LatLng(47.3769, 8.5417), // Zürich
      infoWindow: InfoWindow(title: 'Risiko: Hoch'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ),
    Marker(
      markerId: MarkerId('risk2'),
      position: LatLng(46.9480, 7.4474), // Bern
      infoWindow: InfoWindow(title: 'Risiko: Mittel'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
    Marker(
      markerId: MarkerId('risk3'),
      position: LatLng(46.2044, 6.1432), // Genf
      infoWindow: InfoWindow(title: 'Risiko: Niedrig'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Risikokarte')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(46.8182, 8.2275), // Schweiz Mitte
          zoom: 7,
        ),
        markers: _riskMarkers,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}