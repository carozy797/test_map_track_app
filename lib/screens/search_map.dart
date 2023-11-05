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
  final List<Marker> myMarkerList = const [
    Marker(
      markerId: MarkerId("source"),
      position: _destination, // LatLng for the marker
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Marker Source',
        snippet: 'Marker 1',
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    mymarker.addAll(myMarkerList);
    setState(() {});
  }

  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search,),
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              // polylines: _polyline,
              initialCameraPosition: _pGooglePlex,
              markers: Set<Marker>.of(mymarker),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              // Use the Set of markers here
            ),
          ),
        ],
      ),
    );
  }
}
