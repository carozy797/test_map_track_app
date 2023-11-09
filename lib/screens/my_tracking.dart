// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MyTrack extends StatefulWidget {
//   final Location pLocation;
//   final LatLng pLocLatLng;

//   MyTrack({
//     Key? key,
//     required this.pLocLatLng,
//     required this.pLocation,
//   });

//   @override
//   State<MyTrack> createState() => _MyTrackState();
// }

// class _MyTrackState extends State<MyTrack> {
//   final Completer<GoogleMapController> _controller = Completer();
//   LatLng? sourceAddress;
//   late GoogleMapController mapController;

//   List<LatLng> polylineCoordinates = [];
//   final List<Marker> mymarker = [];
//   final Set<Polyline> _polyline = {};

//   LocationData? currentLocation;
//   List<LatLng> allLocations = []; // List to store all location points
//   final List<Marker> myMarkerList = const [];

//   double zoom = 12.0; // Initial zoom level

//   @override
//   void initState() {
//     super.initState();
//     mymarker.addAll(myMarkerList);
//     getCurrentLocation(context);
//   }

//   Future<void> getCurrentLocation(BuildContext context) async {
//     sourceAddress = widget.pLocLatLng;
//     print("Source ===============================================");
//     print(sourceAddress);
//     mymarker.add(
//       Marker(
//         markerId: const MarkerId("marker_2"),
//         position: sourceAddress!,
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: const InfoWindow(
//           title: 'Marker Title',
//           snippet: 'Source',
//         ),
//       ),
//     );

//     final GoogleMapController googleMapController = await _controller.future;

//     widget.pLocation.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;
//       print("Current ===============================================");
//       print(currentLocation);
//       print(DateTime.now());
//       // Add the new location to the list
//       allLocations.add(LatLng(newLoc.latitude!, newLoc.longitude!));

//       // Add a new segment to the polyline
//       if (allLocations.length > 1) {
//         polylineCoordinates.add(allLocations[allLocations.length - 2]);
//         polylineCoordinates.add(allLocations.last);
//       }
//       mymarker.add(Marker(
//         markerId: const MarkerId("current position"),
//         position: LatLng(
//           newLoc.latitude!,
//           newLoc.longitude!,
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: const InfoWindow(
//           title: 'Marker position',
//           snippet: 'location',
//         ),
//       ));

//       googleMapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             zoom: zoom,
//             target: LatLng(
//               newLoc.latitude!,
//               newLoc.longitude!,
//             ),
//           ),
//         ),
//       );

//       // Update the polyline with the new set of coordinates
//       setState(() {
//         _polyline.clear();
//         _polyline.add(
//           Polyline(
//             polylineId: const PolylineId("route"),
//             points: polylineCoordinates,
//             color: Colors.purple,
//             width: 4,
//           ),
//         );
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onScaleUpdate: (details) {
//           setState(() {
//             zoom += details.scale - 1; // Adjust the zoom level
//             zoom = zoom.clamp(1.0, 20.0); // Limit the zoom level within a reasonable range
//             mapController.animateCamera(
//               CameraUpdate.newCameraPosition(
//                 CameraPosition(
//                   target: widget.pLocLatLng,
//                   zoom: zoom,
//                 ),
//               ),
//             );
//           });
//         },
//         child: Stack(
//           children: <Widget>[
//             GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: widget.pLocLatLng,
//                 zoom: zoom,
//               ),
//               markers: Set<Marker>.of(mymarker),
//               onMapCreated: (controller) {
//                 _controller.complete(controller);
//                 mapController = controller;
//               },
//               polylines: _polyline,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyTrack extends StatefulWidget {
  final Location pLocation;
  final LatLng pLocLatLng;

  MyTrack({
    Key? key,
    required this.pLocLatLng,
    required this.pLocation,
  });

  @override
  State<MyTrack> createState() => _MyTrackState();
}

class _MyTrackState extends State<MyTrack> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? sourceAddress;
  late GoogleMapController mapController;


  List<LatLng> polylineCoordinates = [];
  final List<Marker> mymarker = [];
  final List<Marker> myMarkerList = const [];
  Location location = Location();
  final Set<Polyline> _polyline = {};

  LocationData? currentLocation;
  List<LatLng> allLocations = []; // List to store all location points

  @override
  void initState() {
    super.initState();
    mymarker.addAll(myMarkerList);
    getCurrentLocation(context);
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    sourceAddress = widget.pLocLatLng;
    print("Source ===============================================");
    print(sourceAddress);
    print(DateTime.now());
    mymarker.add(
      Marker(
        markerId: const MarkerId("marker_2"),
        position: sourceAddress!,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(
          title: 'Marker Title',
          snippet: 'Source',
        ),
      ),
    );

    final GoogleMapController googleMapController = await _controller.future;

    widget.pLocation.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      print("Current ===============================================");
      print(currentLocation);
      print(DateTime.now());

      // Add the new location to the list
      allLocations.add(LatLng(newLoc.latitude!, newLoc.longitude!));

      // Add a new segment to the polyline
      if (allLocations.length > 1) {
        polylineCoordinates.add(allLocations[allLocations.length - 2]);
        polylineCoordinates.add(allLocations.last);
      }
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
            zoom: 12,
            target: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            ),
          ),
        ),
      );

      // Update the polyline with the new set of coordinates
      setState(() {
        _polyline.clear();
        _polyline.add(
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.purple,
            width: 8,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: widget.pLocLatLng,
          zoom: 12.5,
        ),
        markers: Set<Marker>.of(mymarker),
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
        polylines: _polyline,
      ),
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class MyTrack extends StatefulWidget {
//   Location p_location;
//   LatLng p_loc_lat_long;
//   MyTrack({
//     super.key,
//     required this.p_loc_lat_long,
//     required this.p_location,
//   });

//   @override
//   State<MyTrack> createState() => _MyTrackState();
// }

// class _MyTrackState extends State<MyTrack> {
//   final Completer<GoogleMapController> _controller = Completer();

//   // ignore: non_constant_identifier_names
//   LatLng? source_address;

//   List<LatLng> polylineCoordinates = [];

//   final List<Marker> mymarker = [];
//   final List<Marker> myMarkerList = const [];
//   Location location = Location();
//   final Set<Polyline> _polyline = {};

//   LocationData? currentLocation;
//   @override
//   void initState() {
//     super.initState();
//     mymarker.addAll(myMarkerList);
//     getCurrentLocation(context);
//   }

//   Future<void> getCurrentLocation(BuildContext context) async {
//     source_address = widget.p_loc_lat_long;
//     print("Sourec ---================================================================");
//     print(source_address);
//     print(DateTime.now());
//     mymarker.add(
//       Marker(
//         markerId: const MarkerId("marker_2"),
//         position: source_address!, // LatLng for the marker
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: const InfoWindow(
//           title: 'Marker Title',
//           snippet: 'Source',
//         ),
//       ),
//     );
//     final GoogleMapController googleMapController = await _controller.future;
//     widget.p_location.onLocationChanged.listen((newLoc) {
//       currentLocation = newLoc;
//       print("--------------------------------");
//       print("now");
//       print(currentLocation);
//       print(DateTime.now());
//       mymarker.add(Marker(
//         markerId: const MarkerId("current position"),
//         position: LatLng(
//           newLoc.latitude!,
//           newLoc.longitude!,
//         ), // LatLng for the marker
//         icon: BitmapDescriptor.defaultMarker,
//         infoWindow: const InfoWindow(
//           title: 'Marker position',
//           snippet: 'location',
//         ),
//       ));
//       googleMapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             zoom: 13.5,
//             target: LatLng(
//               newLoc.latitude!,
//               newLoc.longitude!,
//             ),
//           ),
//         ),
//       );
//       setState(() {});
//       _polyline.add(
//         Polyline(
//           polylineId: const PolylineId("route"),
//           points: [source_address!, LatLng(newLoc.latitude!, newLoc.longitude!)],
//           color: Colors.purple,
//           width: 8,
//         ),
//       );
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//           target: widget.p_loc_lat_long,
//           zoom: 13.5,
//         ),
//         markers: Set<Marker>.of(mymarker),
//         onMapCreated: (mapController) {
//           _controller.complete(mapController);
//         },
//         polylines: _polyline,
//       ),
//     );
//   }
// }
