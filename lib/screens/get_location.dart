import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:test_app/screens/empty_page.dart';
import 'package:test_app/screens/my_tracking.dart';
import 'package:test_app/screens/track.dart';

class GetLoc extends StatefulWidget {
  const GetLoc({super.key});

  @override
  State<GetLoc> createState() => _GetLocState();
}

class _GetLocState extends State<GetLoc> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  Location location = Location();
  LatLng? userLocation;

  LocationData? currentLocation;

  Future<void> getCurrentLocation(BuildContext context) async {
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
        print(currentLocation);
        print("--------------------------------");
        userLocation = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
        print(userLocation);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyTrack(
              p_loc_lat_long: userLocation!,
              p_location: location,
            ),
          ),
        );

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => Empty(),
        //   ),
        // );
      } else {
        // Handle the case where initial location is not available.
      }
    } catch (e) {
      print("Error fetching current location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // mymarker.addAll(myMarkerList);
    getCurrentLocation(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null ? CircularProgressIndicator() : Container(),
    );
  }
}
