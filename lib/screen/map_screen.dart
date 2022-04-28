
import 'package:flutter/material.dart';
import 'package:google_map/Widgets/ride_picker.dart';
import 'package:google_map/Widgets/map_menu.dart';
import 'package:google_map/model/place_item_res.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  final Map<String, Marker> _markers = <String, Marker>{};
  late GoogleMapController _mapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.760170057049345, 106.68225829787944),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              // onMapCreated: (GoogleMapController controller) {
              //   _controller.complete(controller);
              // },
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    title: Text(
                      "Cargo Delivery App",
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: TextButton(
                      onPressed: () {
                        print("click-menu");
                        _scaffoldkey.currentState?.openDrawer();
                      },
                      child: Icon(
                        Icons.view_headline,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: RidePicker(onPlaceSelected),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: MapMenu(),
      ),
    );
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress){
    var MarkerId = fromAddress ? "fromAddress" :"toAddress";
    // _addMarker(MarkerId, place);
    // _moveCamera();
    // _checkDrawPoline();
  }

  // void _addMarker (String MarkerId, PlaceItemRes place) async {
  //   _markers.remove(MarkerId);
  //   _mapController.clearMarkers();
  //
  //   _markers[MarkerId] = Marker(
  //     MarkerId,
  //   );
  //
  // }
}
