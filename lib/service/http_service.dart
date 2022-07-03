import 'dart:convert';
import 'dart:io';

import 'package:google_map/model/http/add_history_request.dart';
import 'package:google_map/service/local_storage.dart';

import 'package:http/http.dart' as http;

import '../model/http/register_request_model.dart';

class HttpService {
  static const baseUrl = 'https://localsearch-vrp.herokuapp.com/api/auth';

  static Future<bool> registerUser(RegisterRequestModel info) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + "/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(info.toJson()),
      );
      if (response.statusCode == 200) {
        LocalStorage.saveVehicleId(
            jsonDecode(response.body)['vehicle']['id_vehicle']!);
        return true;
      } else if (response.statusCode == 400) {
        throw const FormatException(
            "There's at least 1 incorrect field! Please try again!");
      } else {
        print(response.statusCode);
        throw Exception('Error happened');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> addHistory(AddHistoryRequestModel info) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + '/newhistoryRoutes'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${await LocalStorage.getUserToken()}',
        },
        body: jsonEncode(info.toJson()),
      );
      print(info.time);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error happened');
      }
    } catch (e) {
      rethrow;
    }
  }
}
