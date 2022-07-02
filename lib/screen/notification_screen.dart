import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/vehicle_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String Capacity = "";
  String Cost = "";
  String Loading = "";

  @override
  void initState() {
    getToken();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset.zero),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        image: AssetImage('assets/images/box.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capacity: $Capacity ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      Text(
                        'Cost: $Cost',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      Text(
                        'Loading: $Loading',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.get("token"));
    return (sharedPreferences.get("token") ?? "") as String;
  }

  Future<void> getUserData() async {
    String token = await getToken();
    var jsonResponse;
    final response = await http.get(
        Uri.parse("https://localsearch-vrp.herokuapp.com/api/auth/userinfo"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    jsonResponse = json.decode(response.body);
    Capacity = jsonResponse['vehicle']['capacity'] != null
        ? jsonResponse['vehicle']['capacity']!.toString()
        : "";
    Cost = jsonResponse['vehicle']['cost'] != null
        ? jsonResponse['vehicle']['cost']!.toString()
        : "";
    Loading = jsonResponse['vehicle']['loading'] != null
        ? jsonResponse['vehicle']['loading']!.toString()
        : "";

    print(jsonResponse['vehicle']['capacity']);

    if (mounted) setState(() {});
  }
}
