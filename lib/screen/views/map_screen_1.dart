import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/Loading.dart';
import '../home_page_screen.dart';

class MapScreen1 extends StatefulWidget {
  const MapScreen1({Key? key}) : super(key: key);

  @override
  State<MapScreen1> createState() => _MapScreen1State();
}

class _MapScreen1State extends State<MapScreen1> {
  String id_vehicle = "2";
  String status = "";
  bool vehicle_status = false;
  final Completer<GoogleMapController> _controller = Completer();
  static const String google_api_key =
      "AIzaSyCkyruhKSYxXABYVzFEHLpehHBbDmdHVfU";

  static const LatLng sourceLocation =
      LatLng(10.760233298204733, 106.68222611137368);
  static const LatLng destination =
      LatLng(10.757155546553568, 106.67811696725234);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 18,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      if (mounted) {
        setState(() {});
      }
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/icons/warehouse.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/marker/pakage.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/marker/driver.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    // getUserData();
    // getToken();
    setCustomMarkerIcon();
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "MAP",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
            child: Container(
          constraints: BoxConstraints.expand(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned.fill(
                child: currentLocation == null
                    ? Center(child: Text("Loading"))
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          zoom: 13.5,
                        ),
                        polylines: {
                          Polyline(
                            polylineId: PolylineId("route"),
                            points: polylineCoordinates,
                            color: Colors.blue,
                            width: 6,
                          ),
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId("currentLocation"),
                            icon: currentLocationIcon,
                            infoWindow: InfoWindow(
                              title:"Driver",
                            ),
                            position: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                          ),
                          Marker(
                            markerId: MarkerId("source"),
                            infoWindow: InfoWindow(
                              title:"Warehouse",
                            ),
                            icon: sourceIcon,
                            position: sourceLocation,
                          ),
                          Marker(
                            markerId: MarkerId("destination"),
                            icon: destinationIcon,
                            infoWindow: InfoWindow(
                              title:"Customer",
                            ),
                            position: destination,
                          ),
                        },
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                      ),
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
                          top: 10, bottom: 10, left: 165, right: 0),
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
                                        // onPressed: () async {
                                        //   await Check(
                                        //       id_vehicle, vehicle_status);
                                        //   Navigator.pushAndRemoveUntil(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (BuildContext
                                        //           context) =>
                                        //               HomePageScreen()),
                                        //       ModalRoute.withName('/'));
                                        // },
                                        onPressed: (){},
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
                  ],
                ),
              )

            ],
          ),
        ),),);
  }
  // Future<String> getToken() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   print(sharedPreferences.get("token"));
  //   return (sharedPreferences.get("token") ?? "") as String;
  // }

  // Future<void> getUserData() async {
  //   String token = await getToken();
  //   var jsonResponse;
  //   final response = await http.get(
  //       Uri.parse("https://localsearch-vrp.herokuapp.com/api/auth/userinfo"),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       });
  //   jsonResponse = json.decode(response.body);
  //   print(jsonResponse);
    // vehicle_status = jsonResponse['vehicle']['status'] != null
    //     ? jsonResponse['vehicle']['status']!
    //     : false;
    // if (vehicle_status == false) {
    //   status = "Available";
    // } else if (vehicle_status == true) {
    //   status = "Busy";
    // }
    // id_vehicle = jsonResponse['vehicle']['id_vehicle'] != null
    //     ? jsonResponse['vehicle']['id_vehicle']!.toString()
    //     : "";
    // print("id_vehicle" + id_vehicle);
    // print("status" + status);
    // if (mounted) setState(() {});
  }

  // getColor() {
  //   if (vehicle_status == false) {
  //     return Colors.green[600];
  //   } else if (vehicle_status == true) {
  //     return Colors.red[600];
  //   }
  // }

  // Future<void> Check(String idVehicle, bool vehicle_status) async {
  //   String token = await getToken();
  //   vehicle_status = !vehicle_status;
  //   var jsonResponse;
  //   var response = await http.put(
  //     Uri.parse(
  //         "https://localsearch-vrp.herokuapp.com/api/auth/vehicle/${idVehicle}"),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       "id_vehicle": id_vehicle,
  //       "status": vehicle_status,
  //     }),
  //   );
  //   jsonResponse = json.decode(response.body);
  //   print(jsonResponse['id_vehicle']);
  // }
// }
