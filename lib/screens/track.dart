import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Track extends StatefulWidget {

  const Track({super.key});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  final List<Marker> mymarker = [];
  final List<Marker> myMarkerList = const [
    Marker(
      markerId: MarkerId("marker_2"),
      position: sourceLocation, // LatLng for the marker
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Marker Title',
        snippet: 'Marker 2',
      ),
    ),
    Marker(
      markerId: MarkerId("marker_1"),
      position: destination, // LatLng for the marker
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Marker Title',
        snippet: 'Marker 1',
      ),
    ),
  ];

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  Location location = Location();
    final Set<Polyline> _polyline = {};


  @override
  void initState() {
    super.initState();
    mymarker.addAll(myMarkerList);
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    try {
      currentLocation = await location.getLocation();
      if (currentLocation != null) {
        final GoogleMapController googleMapController = await _controller.future;
        print(currentLocation);
        location.onLocationChanged.listen((newLoc) {
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
          // // setState(() {});
          // _polyline.add(
          //   Polyline(
          //     polylineId: const PolylineId("route"),
          //     points: [LatLng(newLoc.latitude!, newLoc.longitude!), destination],
          //     color: Colors.purple,
          //     width: 8,
          //   ),
          // );
          setState(() {});
        });
      } else {
        // Handle the case where initial location is not available.
      }
    } catch (e) {
      print("Error fetching current location: $e");
    }
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
          target: sourceLocation,
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
