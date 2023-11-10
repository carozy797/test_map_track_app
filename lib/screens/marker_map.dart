import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyMarker extends StatefulWidget {
  const MyMarker({super.key});

  @override
  State<MyMarker> createState() => _MyMarkerState();
}

class _MyMarkerState extends State<MyMarker> {
  final Completer<GoogleMapController> _controller = Completer();

  List<LatLng> polylineCordinates = [];
  final Set<Polyline> _polyline = {};
  LatLng? userLocation;

  static CameraPosition _pGooglePlex = const CameraPosition(
    target: _source, // Accra, Ghana coordinates
    zoom: 14,
  );

  static const LatLng _source = LatLng(5.560014, -0.205744);

  Future<Uint8List> getImagesFromMarkers(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  getCustomeMarker() async {
    final Uint8List iconMaker = await getImagesFromMarkers("assets/box-truck.png", 90);
    mymarker.add(Marker(
      markerId: const MarkerId("customized position"),
      position: _destination,
      icon: BitmapDescriptor.fromBytes(iconMaker),
      infoWindow: const InfoWindow(
        title: 'Marker customeized',
        snippet: 'custom',
      ),
    ));
    setState(() {});
  }

  static const LatLng _destination = LatLng(5.551614, -0.195244);
  final List<Marker> mymarker = [];
  final List<Marker> myMarkerList = const [
    // Marker(
    //   markerId: MarkerId("marker_2"),
    //   position: _destination, // LatLng for the marker
    //   icon: BitmapDescriptor.defaultMarker,
    //   infoWindow: InfoWindow(
    //     title: 'Marker Title',
    //     snippet: 'Marker 2',
    //   ),
    // )
  ];

  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  late GoogleMapController mapController;
  MapType _currentMapType = MapType.normal;
  List<MapType> mapTypes = [
    MapType.normal,
    MapType.hybrid,
    MapType.satellite,
    MapType.terrain,
  ];
  int currentMapTypeIndex = 0;

  Future<dynamic> getUserLocation() async {
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
    _locationData = await location.getLocation();
    return _locationData;
  }

  packData() {
    getUserLocation().then((value) async {
      print("My location");
      print('$value.latitude, $value.longitude');
      userLocation = LatLng(value.latitude, value.longitude);

      _pGooglePlex = CameraPosition(
        target: userLocation ?? LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      mymarker.add(Marker(
        markerId: const MarkerId("current position"),
        position: userLocation ?? LatLng(value.latitude, value.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Marker position',
          snippet: 'location',
        ),
      ));
      CameraPosition cameraPosition = CameraPosition(
        target: userLocation ?? LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});

      if (userLocation != null) {
        _polyline.add(
            Polyline(
            polylineId: const PolylineId("route"),
            points: [userLocation!, _destination],
            color: Colors.purple,
            width: 8,
          ),
        );
      } else {
        const Center(
          child: CircularProgressIndicator(),
        );
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    mymarker.addAll(myMarkerList);
    packData();
    getCustomeMarker();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _changeMapType,
            child: const Icon(Icons.map),
          ),
        ],
      ),
      body: GoogleMap(
        mapType: _currentMapType,
        polylines: _polyline,
        initialCameraPosition: _pGooglePlex,
        markers: Set<Marker>.of(mymarker),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
        },
      ),
    );
  }

  void _changeMapType() {
    setState(() {
      currentMapTypeIndex = (currentMapTypeIndex + 1) % mapTypes.length;
      _currentMapType = mapTypes[currentMapTypeIndex];
    });
  }
}
