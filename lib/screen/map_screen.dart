import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map/Widgets/ride_picker.dart';
import 'package:google_map/model/place_item_res.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  // late BitmapDescriptor sourceIcon;
  // late BitmapDescriptor destinationIcon;

  late GoogleMapController _mapController;
  var currentLocation;


  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.760170057049345, 106.68225829787944),
    zoom: 15,
  );

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Container(
        constraints: BoxConstraints.expand(),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            GoogleMap(
                // myLocationButtonEnabled: true,
                // myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: Set<Marker>.of(_markers.values),
                onMapCreated: _onMapCreated),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                      iconSize: 25,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    // title: Text(
                    //   " Delivery App",
                    //   style: TextStyle(color: Colors.black),
                    // ),
                    // leading: TextButton(
                    //   onPressed: () {
                    //     print("click-menu");
                    //     _scaffoldkey.currentState?.openDrawer();
                    //   },
                    //   child: Icon(
                    //     Icons.view_headline,
                    //     color: Colors.black,
                    //   ),
                    // ),
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
      // drawer: Drawer(
      //    child: MapMenu(),
      // ),
    );
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    // var markerId = fromAddress ? "from_address" : "to_address";
    _addMarker(fromAddress, place);
    // _moveCamera();
    // _checkDrawPoline();
  }

  void _addMarker(bool isFromAddress, PlaceItemRes place) async {
    final MarkerId markerId =
        MarkerId(isFromAddress ? 'from_address' : 'to_address');
    _markers.remove(markerId);
    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        isFromAddress ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
      ),
      position: LatLng(place.lat, place.lng),
      infoWindow: InfoWindow(
        title: place.name,
        snippet: place.address,
      ),
    );

    setState(() {
      // adding a new marker to map
      _markers[markerId] = marker;

    });

  }

}
