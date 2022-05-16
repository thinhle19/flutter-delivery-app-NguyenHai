
import 'dart:async';

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
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  // late BitmapDescriptor sourceIcon;
  // late BitmapDescriptor destinationIcon;

  final Completer<GoogleMapController> _mapController = Completer();

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
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
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
                      " Delivery App",
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

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    var markerId = fromAddress ? "from_address" : "to_address";
    _addMarker(markerId, place);
    // _moveCamera();
    // _checkDrawPoline();
  }

  void _addMarker(String markerId, PlaceItemRes place) async {
    final MarkerId markerId = MarkerId('markerId');
    _markers.remove(markerId);
    // _mapController.;
    // creating a new MARKER
     Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
    //
    // for (var m in _markers.values) {
    // await _mapController.getVisibleRegion(m.position);
  }
  //
  // void _moveCamera() {
  //   print("Move camera: ");
  //   print(_markers);
  //   if (_markers.values.length > 1) {
  //     var fromLatLng = _markers["from_address"]?.position;
  //     var toLatLng = _markers["to_address"]?.position;
  //
  //     var sLat, sLng, nLat, nLng;
  //     if(fromLatLng?.latitude <= toLatLng!.latitude) {
  //       sLat = fromLatLng?.latitude;
  //       nLat = toLatLng.latitude;
  //     } else {
  //       sLat = toLatLng.latitude;
  //       nLat = fromLatLng?.latitude;
  //     }
  //
  //     if(fromLatLng?.longitude < toLatLng.longitude) {
  //       sLng = fromLatLng?.longitude;
  //       nLng = toLatLng.longitude;
  //     } else {
  //       sLng = toLatLng.longitude;
  //       nLng = fromLatLng?.longitude;
  //     }
  //
  //     LatLngBounds bounds = LatLngBounds(northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
  //     _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  //   } else {
  //     _mapController.animateCamera(CameraUpdate.newLatLng(
  //         _markers.values.elementAt(0).position));
  //   }
  // }
}
