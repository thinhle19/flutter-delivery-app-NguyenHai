import 'package:flutter/material.dart';
import 'package:google_map/screen/views/home_screen_view.dart';
import 'package:google_map/screen/views/map_screen_view.dart';
import 'package:google_map/screen/views/profile_screen_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'map_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 0;
  String username ="";

  final List<Widget> _children =[
    HomeScreenView(),
    MapScreenView(),
    ProfileView(),
  ];

  @override
  void initState(){
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState((){
      username = sharedPreferences.getString("login")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Delivery App",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("LOGOUT"),
                        content: Text("Do you want to logout ?"),
                        actions: [
                          TextButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              await sharedPreferences.clear();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()),
                                  ModalRoute.withName('/'));
                            },
                          ),
                          TextButton(child: Text("No") , onPressed: (){
                            Navigator.of(context).pop();
                          },),
                        ],
                      ));
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
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
