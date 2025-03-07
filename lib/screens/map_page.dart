import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:test_app/components/constants.dart';

class MyMap extends StatefulWidget {
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final Completer<GoogleMapController> _controller = Completer();
  // LocationData? currentLocation;

  // void getCurrentLocation() {
  //   Location location = Location();
  //   location.getLocation().then((location) => currentLocation = location);
  // }

  List<LatLng> polylineCordinates = [];
  final Set<Polyline> _polyline = {};

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyARCZD-dk7cnxUwheGYfQJ4opipw4TcDzw",
      PointLatLng(
        _source.latitude,
        _source.longitude,
      ),
      PointLatLng(
        _destination.latitude,
        _destination.longitude,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  static const CameraPosition _pGooglePlex = CameraPosition(
    target: _source, // Accra, Ghana coordinates
    zoom: 14,
  );
  static const LatLng _source = LatLng(37.52078916, -122.35459618);
  static const LatLng other = LatLng(7.52133683, -1.35490229);
  static const LatLng _destination = LatLng(5.551614, -0.205244); // Adjusted latitude and longitude

  final Set<Marker> _markers = {};

  final List<Marker> mymarker = [];
  // final List<Marker> myMarkerList = const [
  //   Marker(
  //     markerId: MarkerId("marker_2"),
  //     position: _destination, // LatLng for the marker
  //     icon: BitmapDescriptor.defaultMarker,
  //     infoWindow: InfoWindow(
  //       title: 'Marker Title',
  //       snippet: 'Marker 2',
  //     ),
  //   )
  // ];

  @override
  void initState() {
    super.initState();
    // packData();
    // mymarker.addAll(myMarkerList);
    // getCurrentLocation();
    // getPolyPoints();
    // Create a Marker instance with a unique markerId and the desired LatLng for the position
    // const marker = Marker(
    //   markerId: MarkerId("marker_1"),
    //   position: _source, // LatLng for the marker
    //   icon: BitmapDescriptor.defaultMarker,
    //   infoWindow: InfoWindow(
    //     title: 'Marker Title',
    //     snippet: 'Marker 1',
    //   ),
    // );
    const marker2 = Marker(
      markerId: MarkerId("marker_2"),
      position: _destination, // LatLng for the marker
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: 'Marker Title',
        snippet: 'Marker 2',
      ),
    );

    // Add the marker to the _markers Set
    // _markers.add(marker);
    _markers.add(marker2);
    setState(() {});
    _polyline.add(
      const Polyline(
        polylineId: PolylineId("route"),
        points: [
          LatLng(37.52078916, -122.35459618),
          LatLng(37.52133683, -122.35490229),
          LatLng(37.52161402, -122.35505375),
          LatLng(37.5218905, -122.35519918),
          LatLng(37.52215906, -122.3553441),
          LatLng(37.52244224, -122.3554969),
          LatLng(37.52271289, -122.35564283),
          LatLng(37.52299544, -122.35580008),
          LatLng(37.52326547, -122.35596009),
          LatLng(37.52353239, -122.35612596),
          LatLng(37.52379571, -122.35631397),
          LatLng(37.52404792, -122.35651279),
          LatLng(37.52429661, -122.3567153),
          LatLng(37.52454815, -122.35693297),
          LatLng(37.52479646, -122.35715652),
          LatLng(37.52503451, -122.35737814),
          LatLng(37.52527918, -122.35759682),
          LatLng(37.52552611, -122.35781861),
          LatLng(37.52578192, -122.35804173),
        ],
        color: Colors.purple,
        width: 8,
      ),
    );
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) {
      print('error: $error');
    });
    return await Geolocator.getCurrentPosition();
  }

  packData() {
    getUserLocation().then((value) async {
      print("My location");
      print('$value.latitude, $value.longitude');

      _markers.add(Marker(
        markerId: const MarkerId("current position"),
        position: LatLng(value.latitude, value.longitude), // LatLng for the marker
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Marker position',
          snippet: 'location',
        ),
      ));
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        polylines: _polyline,
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
