import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_app/components/location_services.dart';

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
      // appBar: AppBar(title: const Text("searching..."),),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: "search by city",
                  ),
                  onChanged: (value) {
                    print(value);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () async {
                  var place = await LocationService().getPlace(_searchController.text);
                  _goToplace(place);
                },
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

  Future<void> _goToplace(Map<String, dynamic> place) async {
    double lat = place["lat"];
    double long = place["lng"];
    mymarker.add(
        Marker(
        markerId: const MarkerId("searched loc:"),
        position: LatLng(lat, long), // LatLng for the marker
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Marker search',
          snippet: 'search loc',
        ),
      ),
    );
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, long),
      zoom: 20,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {});
  }
}
