import 'package:flutter/material.dart';

import '../map_screen.dart';

class MapScreenView extends StatelessWidget {
  const MapScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children:<Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 250, 50, 0),
                child: MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "MOVE TO MAP",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MapScreen()));
                  },
                ),
              ),
            ),
          ]
      ),
    );
  }
}
