import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../notification_screen.dart';
import 'map_screen_1.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  String fullname = "";


  @override
  void initState() {
    getUserToken();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        title: Text(
          "Home",
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              "Hello ${fullname}" ,
              // "Hello " ,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
                child: Image(image: AssetImage("assets/screen/Hello.jpg"))),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print("Tapped on Container");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MapScreen1()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrangeAccent,
                      ),
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/box.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "GoSend",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getUserToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print (sharedPreferences.get("token"));
    return (sharedPreferences.get("token") ?? "") as String;

  }

  Future<void> getData() async {
    String token = await getUserToken();
    var jsonResponse;
    final response = await http.get(
        Uri.parse("https://localsearch-vrp.herokuapp.com/api/auth/userinfo"),
        headers: {
          'Authorization': 'Bearer $token',
        });
    jsonResponse = json.decode(response.body);
    // print(jsonResponse);
    fullname = jsonResponse['fullname'];
    if (mounted) {
      setState(() {
      });
    }
  }

}
