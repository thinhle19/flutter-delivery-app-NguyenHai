import 'dart:convert';
import 'dart:io';

import 'package:google_map/model/http/add_history_request.dart';
import 'package:google_map/model/http/history_response.dart';
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
        return true;
      } else if (response.statusCode == 400) {
        throw const FormatException(
            "There's at least 1 incorrect field! Please try again!");
      } else {
        print(response.statusCode);
        throw Exception('Internal Server Error');
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
        throw Exception('Error happened addHistory');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<HistoryResponse>> getHistoryFromDriver(
      String driverId) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl + '/vehicle/$driverId'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer ${await LocalStorage.getUserToken()}',
        },
      );
      if (response.statusCode == 200) {
        List<HistoryResponse> list = List<HistoryResponse>.from(
          (jsonDecode(response.body) as List<dynamic>).map(
            (e) => HistoryResponse.fromJson(e),
          ),
        );
        return list;
      } else {
        throw Exception('Error happened getHistory');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> getVehicleId(String username) async {
    try {
      final response = await http.post(Uri.parse(baseUrl + '/getIdVehicle'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer ${await LocalStorage.getUserToken()}',
          },
          body: jsonEncode({'username': username}));
      if (response.statusCode == 200) {
        return jsonDecode(response.body).toString();
      } else {
        throw Exception('Error happened getVehicleId');
      }
    } catch (e) {
      rethrow;
    }
  }
}
