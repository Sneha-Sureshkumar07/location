import 'package:flutter/material.dart';
import 'package:location_app/Location/location_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location',
      debugShowCheckedModeBanner: false,
      home: LocationScreen(),
    );
  }
}
