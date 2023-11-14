import 'package:flutter/material.dart';
import 'package:test_app/screens/api_test.dart';
import 'package:test_app/screens/changing_maptype.dart';
import 'package:test_app/screens/get_location.dart';
import 'package:test_app/screens/map_page.dart';
import 'package:test_app/screens/marker_map.dart';
import 'package:test_app/screens/search_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchMap(),
      // home: MapSample(),
    );
  }
}
