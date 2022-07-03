import 'dart:convert';
import 'dart:io';

import 'package:google_map/model/register_request_model.dart';
import 'package:google_map/model/register_response_model.dart';

import 'package:http/http.dart' as http;

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
        throw Exception('Error happened');
      }
    } catch (e) {
      rethrow;
    }
  }
}
