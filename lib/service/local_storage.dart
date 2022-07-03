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
}
