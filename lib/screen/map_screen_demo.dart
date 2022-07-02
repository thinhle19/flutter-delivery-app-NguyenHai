import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_map/screen/home_page_screen.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreendemo extends StatefulWidget {
  const MapScreendemo({Key? key}) : super(key: key);

  @override
  State<MapScreendemo> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreendemo> {
  String id_vehicle = "2";
  String status = "";
  bool vehicle_status = false;
  Completer<GoogleMapController> _controller = Completer();

  Uint8List? markerImage;


  static const CameraPosition _kGoogleFlex = CameraPosition(
      target: LatLng(10.760233298204733, 106.68222611137368), zoom: 14);

  List<String> images = [
    'assets/marker/driver.png',
    'assets/marker/pakage.png',
    'assets/marker/pakage.png',
    'assets/marker/pakage.png',
  ];

  final Set<Polyline> _polyline = {};
  final List<Marker> _markers = <Marker>[];
  final List<LatLng> polylineCoordinates = <LatLng>[
    LatLng(10.760233298204733, 106.68222611137368),
    LatLng(10.758704966569558, 106.68034856520568),
    LatLng(10.761919724121412, 106.67695288885037),
    LatLng(10.763184537367485, 106.68205981442739),
    LatLng(10.760233298204733, 106.68222611137368)
  ];



  loadData() async {
    for (int i = 0; i < images.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(images[i], 100);
      _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: polylineCoordinates[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow:
              InfoWindow(title: 'this is title marker:' + i.toString())));
      setState(() {});
    }

    _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: polylineCoordinates,
        visible: true,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
        color: Colors.blue,
        width: 3));
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    loadData();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: GoogleMap(
                    compassEnabled: false,
                    tiltGesturesEnabled: true,
                    // zoomControlsEnabled: true,
                    mapType: MapType.normal,
                    // markers: _markers,
                    // initialCameraPosition: initialCameraPosition,
                    initialCameraPosition: _kGoogleFlex,
                    markers: Set<Marker>.of(_markers),
                    polylines: _polyline,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    }),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 80, right: 50),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset.zero),
                          ]),
                      child: Row(
                        children: <Widget>[
                          MaterialButton(
                            minWidth: 50,
                            height: 40,
                            child: const Text("Check"),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Check"),
                                        content: const Text(
                                            "Have you delivered successfully?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () async {
                                              await Check(
                                                  id_vehicle, vehicle_status);
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          HomePageScreen()),
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
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 50),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset.zero),
                          ]),
                      child: Row(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 100,
                            height: 50,
                            child: Center(
                              child: Text(
                                status,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getColor()),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
    print(jsonResponse);
    vehicle_status = jsonResponse['vehicle']['status'] != null
        ? jsonResponse['vehicle']['status']!
        : false;
    if (vehicle_status == false) {
      status = "Available";
    } else if (vehicle_status == true) {
      status = "Busy";
    }
    id_vehicle = jsonResponse['vehicle']['id_vehicle'] != null
        ? jsonResponse['vehicle']['id_vehicle']!.toString()
        : "";
    print("id_vehicle" + id_vehicle);
    print("status" + status);
    if (mounted) setState(() {});
  }

  getColor() {
    if (vehicle_status == false) {
      return Colors.green[600];
    } else if (vehicle_status == true) {
      return Colors.red[600];
    }
  }

  Future<void> Check(String idVehicle, bool vehicle_status) async {
    String token = await getToken();
    vehicle_status = !vehicle_status;
    var jsonResponse;
    var response = await http.put(
      Uri.parse(
          "https://localsearch-vrp.herokuapp.com/api/auth/vehicle/${idVehicle}"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        "id_vehicle": id_vehicle,
        "status": vehicle_status,
      }),
    );
    jsonResponse = json.decode(response.body);
    print(jsonResponse['id_vehicle']);
  }
}
