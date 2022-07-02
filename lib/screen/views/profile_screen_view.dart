import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_map/screen/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../notification_screen.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String username = "";
  String fullName = "";
  String age = "";
  String address = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NotificationScreen()));
          }, icon: const Icon(Icons.notifications)),
        ],
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
            SizedBox(
              height: 100,
              width: 100,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: const [
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                    radius: 50,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MaterialButton(
                onPressed: () {},
                color: const Color(0xFFF5F6F9),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MaterialButton(
                onPressed: () {},
                color: const Color(0xFFF5F6F9),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        fullName,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MaterialButton(
                onPressed: () {},
                color: const Color(0xFFF5F6F9),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.face,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        age,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MaterialButton(
                onPressed: () {},
                color: const Color(0xFFF5F6F9),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.add_location,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MaterialButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("LOGOUT"),
                            content: const Text("Do you want to logout ?"),
                            actions: [
                              TextButton(
                                child: const Text("Yes"),
                                onPressed: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  await sharedPreferences.clear();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginScreen()),
                                      ModalRoute.withName('/'));
                                },
                              ),
                              TextButton(
                                child: const Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                },
                color: const Color(0xFFF5F6F9),
                // padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: const <Widget>[
                    Icon(
                      Icons.logout,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                        child: Text(
                      "Log out",
                      style: TextStyle(fontSize: 20),
                    ))
                  ],
                ),
              ),
            ),
          ],
        ),
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
    username = jsonResponse['username'];
    fullName = jsonResponse['fullname'];
    age = jsonResponse['age'] != null ? jsonResponse['age']!.toString() : "";
    // jsonResponse['age'] != null: điều kiện
    // ? jsonResponse['age']!.toString(): cái sẽ thực hiện nếu điều kiện trả về true
    // : "": cái sẽ thực hiện nếu điều kiện trả về false
    // if (jsonResponse['age'] != null) {
    //   age = jsonResponse['age']!.toString();
    // } else {
    //   age = "";
    // }
    //
    address = jsonResponse['address'];
    if(mounted) setState(() {});
  }
}
