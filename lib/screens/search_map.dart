import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchMap extends StatefulWidget {
  const SearchMap({super.key});

  @override
  State<SearchMap> createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  
  final Completer<GoogleMapController> _controller = Completer();
  
  static const CameraPosition _pGooglePlex = CameraPosition(
    target: _source, // Accra, Ghana coordinates
    zoom: 14,
  );
  static const LatLng _source = LatLng(5.560014, -0.205744);
  static const LatLng _destination = LatLng(5.551614, -0.205244); // Adjusted latitude and longitude

  final Set<Marker> _markers = {};

  final List<Marker> mymarker = [];

  @override
  void initState() {
    super.initState();
    // mymarker.addAll(myMarkerList

    setState(() {});
  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // polylines: _polyline,
        initialCameraPosition: _pGooglePlex,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        // Use the Set of markers here
      ),
    );
  }
}