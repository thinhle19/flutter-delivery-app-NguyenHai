import 'package:flutter/material.dart';
import 'package:google_map/screen/home_screen.dart';

class MapMenu extends StatefulWidget {
  const MapMenu({Key? key}) : super(key: key);

  @override
  _MapMenuState createState() => _MapMenuState();
}

class _MapMenuState extends State<MapMenu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Image.asset(
            'assets/icons/ic_profile.jpg',
          ),
          title: const Text(
            "My Profile",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/ic_notification.png',
          ),
          title: const Text(
            "Notifications",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        ListTile(
          leading: Image.asset(
            'assets/icons/ic_help.png',
          ),
          title: const Text(
            "Help & Support",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        ListTile(
          onTap: () {
            AlertDialog(
              title: Text("Accept?"),
              content: Text("Do you accept?"),
              // actions: [
              //   TextButton("No"),
              //   TextButton("Yes"),
              // ],
            );
            // Navigator.push(context, MaterialPageRoute(builder: gotoLogin));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()),
                ModalRoute.withName('/'));
          },
          leading: Image.asset(
            'assets/icons/ic_logout.png',
          ),
          title: const Text(
            "Logout",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    );
  }
  // Widget gotoLogin(BuildContext context) {
  //   return LoginScreen();
  // }
}
