import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Flutter Example'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco coordinates
          zoom: 12.0,
        ),
        mapType: _currentMapType,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.zoomIn(),
              );
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.zoomOut(),
              );
            },
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _changeMapType(MapType.normal);
            },
            child: const Icon(Icons.map),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _changeMapType(MapType.hybrid);
            },
            child: const Icon(Icons.satellite),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _changeMapType(MapType.satellite);
            },
            child: const Icon(Icons.satellite),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _changeMapType(MapType.terrain);
            },
            child: const Icon(Icons.terrain),
          ),
        ],
      ),
    );
  }

  void _changeMapType(MapType mapType) {
    setState(() {
      _currentMapType = mapType;
    });
  }
}
