import 'package:flutter/material.dart';
import 'package:google_map/screen/login_screen.dart';
import 'package:google_map/screen/map_screen_demo.dart';
import 'package:google_map/screen/test_screen.dart';
import 'package:google_map/screen/views/map_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MapScreen(),
  ));
}
