import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoffeeShopsMapTab extends StatefulWidget {
  @override
  _CoffeeShopsMapTabState createState() => _CoffeeShopsMapTabState();
}

class _CoffeeShopsMapTabState extends State<CoffeeShopsMapTab> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _createMarkers(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(45.521563, -122.677433),
        infoWindow: InfoWindow(title: 'Coffee Shop 1'),
      ),
      Marker(
        markerId: MarkerId('2'),
        position: LatLng(45.531563, -122.687433),
        infoWindow: InfoWindow(title: 'Coffee Shop 2'),
      ),
    };
  }
}
