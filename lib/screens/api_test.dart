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
  List<dynamic> users = [];
  Future<Post> fetchData() async {
    const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load");
    }
  }

  Future<void> getData() async {
    const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(apiUrl);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body);
      print(json);
    } else {
      throw Exception("Failed to load");
    }
  }

  Future<Post> postData(String userId, String latitude, String longitude, DateTime created) async {
    Map<String, dynamic> request = {
      "userId": userId,
      "latitude": latitude,
      "longitude": longitude,
      "created": created.toString(),
    };
    const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(apiUrl);
    final response = await http.post(uri, body: request);

    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
      throw Exception("Failed to load");
    }
  }

  Future<void> postTest() async {
    const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
    final uri = Uri.parse(apiUrl);
    String uid = const Uuid().v4().toString();
    final body = {
      "userId": uid,
      "title": "test",
      "body": "quia et suscipit suscipit recusandae consequuntur expedita et cum",
    };
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, "Success!");
      print(uid);
    } else {
      // Handle other status codes
      print(response.statusCode);
      print(uid);
      throw Exception("Failed to load");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postTest();
          // getData();
        },
        child: const Text("+"),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
}
