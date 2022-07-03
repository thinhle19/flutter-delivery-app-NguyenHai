import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveVehicleId(String id) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('id_vehicle', id);
  }

  static Future<String?> getVehicleId() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_vehicle');
  }

  static Future<void> setUserToken(String token) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future<String> getUserToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.get("token") as String;
  }
}
