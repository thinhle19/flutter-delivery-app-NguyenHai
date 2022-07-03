import 'package:flutter/material.dart';
import 'package:google_map/screen/home_page_screen.dart';
import 'package:google_map/screen/login_screen.dart';
import 'package:google_map/screen/map_screen_demo.dart';
import 'package:google_map/screen/test_screen.dart';
import 'package:google_map/screen/views/history_screen.dart';
import 'package:google_map/screen/views/map_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
    theme: ThemeData(
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headline3: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ));
}
