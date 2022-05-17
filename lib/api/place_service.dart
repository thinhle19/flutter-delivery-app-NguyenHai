import 'dart:convert';
import 'dart:async';
import 'package:google_map/model/place_item_res.dart';
import 'package:http/http.dart' as http;

class PlaceService {
  static Future<List<PlaceItemRes>> searchPlace(String keyword) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyAtTc2lrpq2Nd0FFj3TcYp_5rwwM2vnJvU" +
            "&language=vi&region=VN&query=" +
            Uri.encodeQueryComponent(keyword);

    print("search >>:" + url);
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {

      print("res : " +  res.body);
      return PlaceItemRes.fromJson(json.decode(res.body));
    } else {
      return [];
    }
  }
}
