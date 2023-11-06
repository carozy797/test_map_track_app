import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyTrack extends StatefulWidget {
  Location p_location;
  LatLng p_loc_lat_long;
  MyTrack({
    super.key,
    required this.p_loc_lat_long,
    required this.p_location,
  });

  @override
  State<MyTrack> createState() => _MyTrackState();
}

class _MyTrackState extends State<MyTrack> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  LatLng? source_address;

  List<LatLng> polylineCoordinates = [];

  final List<Marker> mymarker = [];
  final List<Marker> myMarkerList = const [
    // Marker(
    //   markerId: MarkerId("marker_2"),
    //   position: source_address, // LatLng for the marker
    //   icon: BitmapDescriptor.defaultMarker,
    //   infoWindow: InfoWindow(
    //     title: 'Marker Title',
    //     snippet: 'Marker 2',
    //   ),
    // ),
    // Marker(
    //   markerId: MarkerId("marker_1"),
    //   position: destination, // LatLng for the marker
    //   icon: BitmapDescriptor.defaultMarker,
    //   infoWindow: InfoWindow(
    //     title: 'Marker Title',
    //     snippet: 'Marker 1',
    //   ),
    // ),
  ];
  Location location = Location();
  final Set<Polyline> _polyline = {};

  LocationData? currentLocation;
  @override
  void initState() {
    super.initState();
    mymarker.addAll(myMarkerList);
    getCurrentLocation(context);
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    source_address = widget.p_loc_lat_long;
    mymarker.add(
      Marker(
        markerId: MarkerId("marker_2"),
        position: source_address!, // LatLng for the marker
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: 'Marker Title',
          snippet: 'Marker 2',
        ),
      ),
    );
    final GoogleMapController googleMapController = await _controller.future;
    widget.p_location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      print("--------------------------------");
      print("now");
      print(currentLocation);
      mymarker.add(Marker(
        markerId: const MarkerId("current position"),
        position: LatLng(
          newLoc.latitude!,
          newLoc.longitude!,
        ), // LatLng for the marker
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Marker position',
          snippet: 'location',
        ),
      ));
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            ),
          ),
        ),
      );
      setState(() {});
      _polyline.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: [source_address!, destination],
          color: Colors.purple,
          width: 8,
        ),
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // currentLocation == null
          // ? const Center(child: Text("Loading"))
          // :
          GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: widget.p_loc_lat_long,
          zoom: 13.5,
        ),
        markers: Set<Marker>.of(mymarker),
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        // polylines: _polyline,
      ),
    );
  }
}
