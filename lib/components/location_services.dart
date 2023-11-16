//
import 'dart:convert';

import 'package:http/http.dart' as http;

class LocationService {
  final String key = "AIzaSyBlZX1imLwMMjQJJsSSeYy69SLWSc2lO8o";
  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    // final String url = 'https://places.googleapis.com/v1/places/GyuEmsRBfy61i59si0?fields=a$input&key=$key';

    final response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'];
    print(placeId);
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";

    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var results = json['result']['geometry']['location'];
    print(results);
    return results;
  }

  Future<Map<String, dynamic>> getViewport(String input) async {
    final placeId = await getPlaceId(input);
    final String url = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";

    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var results = json['result']['geometry']['viewport'];
    double latNorthEast = results["northeast"]["lat"];
    print(results);
    print(latNorthEast);
    return results;
  }

  Future<List?> getCordinatesForDay() async {
    const apiUrl = 'https://mvitracking.pro:9000/asset_location/';

    const assetUuid = '60e751f3-800b-43dd-80dd-2ae7b62d0e39';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final assetData = data.where((item) => item['asset_uuid'] == assetUuid).toList();

      final oneDayData = assetData.where((item) {
        final createdAt = DateTime.parse(item['created_at']);
        final date = '${createdAt.year}-${createdAt.month}-${createdAt.day}';
        return date == '2023-11-14'; // Replace with your any date later
      }).toList();
      print(oneDayData[0]['latitude']);
      return oneDayData;
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
    }
    return null;
  }
}
