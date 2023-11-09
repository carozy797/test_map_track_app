import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class API extends StatefulWidget {
  const API({super.key});

  @override
  State<API> createState() => _APIState();
}

class _APIState extends State<API> {
  Future<Post> fetchData() async {
    const String apiUrl = 'https://example.com/api/data';
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load");
    }
  }

  Future<Post> postData(String userId, String latitude, String longitude, DateTime created) async {
    Map<String, dynamic> request = {
      "userId": const Uuid().v4(),
      "latitude": latitude,
      "longitude": longitude,
      "created": created,
    };
    const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(apiUrl);
    final response = await http.post(uri, body: request);

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingActionButton(
        onPressed: () {
          // postData();
        },
        child: const Text("+"),
      ),
    );
  }
}
