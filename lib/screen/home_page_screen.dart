import 'package:flutter/material.dart';
import 'package:google_map/screen/views/history_screen.dart';
import 'package:google_map/screen/views/home_screen_view.dart';
import 'package:google_map/screen/views/profile_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 0;
  // String username ="";

  final List<Widget> _children = [
    HomeScreenView(),
    ProfileView(),
    HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // getCred();
  }
  //
  // void getCred() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState((){
  //     username = sharedPreferences.getString("login")!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
