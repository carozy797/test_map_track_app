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
  GoogleMapController? mapController;
  static const CameraPosition _pGooglePlex = CameraPosition(
    target: _source, // Accra, Ghana coordinates
    zoom: 14,
  );
  static const LatLng _source = LatLng(5.560014, -0.205744);
  static const LatLng _destination = LatLng(5.551614, -0.205244); // Adjusted latitude and longitude
  final List<Marker> mymarker = [];
  final Set<Polyline> _polyline = {};
  final Set<Polygon> _polygons = {};

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
    // _polyline.add(
    //   const Polyline(
    //     polylineId: PolylineId("route"),
    //     points: [_source, _destination],
    //     color: Colors.purple,
    //     width: 8,
    //   ),
    // );
    setState(() {});
  }

  final TextEditingController _searchController = TextEditingController();
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
                    hintText: "search by city, area, street, etc",
                  ),
                  onChanged: (value) {
                    // print(value);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () async {
                  var dayData = await LocationService().getCordinatesForDay();

                  // Initialize empty list for LatLng coordinates
                  List<LatLng> latlngCoordinates = [];

                  // Iterate through the data and extract latitudes and longitudes
                  for (var entry in dayData!) {
                    double latitude = double.parse(entry["latitude"]);
                    double longitude = double.parse(entry["longitude"]);
                    latlngCoordinates.add(LatLng(latitude, longitude));
                  }
                  print(latlngCoordinates);
                  // var viewport = await LocationService().getViewport(_searchController.text);
                  // var place = await LocationService().getPlace(_searchController.text);
                  // _goToplace(place);
                  // _plotPolygon(viewport);
                },
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              polylines: _polyline,
              polygons: _polygons,
              initialCameraPosition: _pGooglePlex,
              markers: Set<Marker>.of(mymarker),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                // _plotPolygon();
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
      zoom: 14,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }

  Future<void> _plotPolygon(Map<String, dynamic> viewport) async {
    double latNorthEast = viewport["northeast"]["lat"];
    double longNorthEast = viewport["northeast"]["lng"];
    double latSouthWest = viewport["southwest"]["lat"];
    double longSouthWest = viewport["southwest"]["lng"];
    print(latNorthEast);
    print(longNorthEast);
    // draw polygon
    LatLng northeast = LatLng(latNorthEast, longNorthEast);
    LatLng southwest = LatLng(latSouthWest, longSouthWest);

    // Calculate the bounds of the square
    LatLngBounds bounds = LatLngBounds(
      southwest: southwest,
      northeast: northeast,
    );
    // Create a square polygon
    Polygon polygon = Polygon(
      polygonId: const PolygonId('square_polygon'),
      points: [
        bounds.southwest,
        LatLng(bounds.northeast.latitude, bounds.southwest.longitude),
        bounds.northeast,
        LatLng(bounds.southwest.latitude, bounds.northeast.longitude),
      ],
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.transparent,
    );
    // Add the polygon to the set
    _polygons.add(polygon);

    // Update the GoogleMap with the new set of polygons
    if (mapController != null) {
      // mapController!.clearPolygons();
      // mapController!.addPolygons(_polygons);
    }

    setState(() {});
  }
}
