import 'dart:async';
import 'dart:convert';
import 'package:google_map/common/credentials.dart';
import 'package:google_map/common/helper.dart';
import 'package:google_map/model/http/add_history_request.dart';
import 'package:google_map/service/http_service.dart';
import 'package:google_map/service/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/Loading.dart';
import '../../model/http/register_response_model.dart';
import '../home_page_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String id_vehicle = "2";
  String status = "";
  bool _isInit = true;
  bool _isLoading = false;
  bool vehicle_status = false;
  GoogleMapController? _controller;
  Location _currentLocation = Location();
  static const String google_api_key = GOOGLE_API_KEY;

  static const LatLng sourceLocation =
      LatLng(10.760233298204733, 106.68222611137368);
  LocationData _currentLocationData = LocationData.fromMap(
      {'longitude': 10.760233298204733, 'latitude': 106.68222611137368});
  static const LatLng destination =
      LatLng(10.757155546553568, 106.67811696725234);

  List<LatLng> polylineCoordinates = [];
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    setState(() {
      getLocation();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      setMarkersIcon();
    });
    super.didChangeDependencies();
  }

  void getLocation() async {
    var location = await _currentLocation.getLocation();
    _currentLocationData = location;
    _currentLocation.onLocationChanged.listen((LocationData loc) {
      _controller
          ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        target: LatLng(loc.latitude ?? 0.0, loc.longitude ?? 0.0),
        zoom: 12.0,
      )));
      print(loc.latitude);
      print(loc.longitude);
      _currentLocationData = loc;
    });
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

  void setMarkersIcon() {
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
                child: /*  currentLocation == null
                    ? Center(child: Text("Loading"))
                    :  */
                    GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: /* LatLng(
                        currentLocation!.latitude!,
                        currentLocation!
                            .longitude!) */
                        sourceLocation,
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
                  myLocationEnabled: true,
                  markers: {
                    Marker(
                      markerId: const MarkerId("currentLocation"),
                      icon: currentLocationIcon,
                      infoWindow: InfoWindow(
                        title: "Driver",
                      ),
                      position: LatLng(_currentLocationData.latitude!,
                          _currentLocationData.longitude!),
                    ),
                    Marker(
                      markerId: MarkerId("source"),
                      infoWindow: InfoWindow(
                        title: "Warehouse",
                      ),
                      icon: sourceIcon,
                      position: sourceLocation,
                    ),
                    Marker(
                      markerId: MarkerId("destination"),
                      icon: destinationIcon,
                      infoWindow: InfoWindow(
                        title: "Customer",
                      ),
                      position: destination,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
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
                                      onPressed: () async {
                                        // Navigator.of(context).pop();
                                        showLoadingDialog(context);
                                        try {
                                          await HttpService.addHistory(
                                            AddHistoryRequestModel(
                                              time: DateTime.now()
                                                  .toIso8601String(),
                                              costRoute: '123',
                                              capacityRoute: '123',
                                              statusRoute: true,
                                              vehicle: Vehicle(
                                                  capacity: 332,
                                                  cost: 22,
                                                  idVehicle:
                                                      VEHICLE_ID /* (await LocalStorage
                                                      .getVehicleId())! */
                                                  ,
                                                  loading: 332,
                                                  nodes: [],
                                                  status: true),
                                              loadingRoute: '3232',
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          showSuccessDialog(
                                              'Checked Route!', context);
                                        } catch (e) {
                                          Navigator.of(context).pop();
                                          showErrorDialog(
                                              e.toString(), context);
                                        }
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("No"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
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
        ),
      ),
    );
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
