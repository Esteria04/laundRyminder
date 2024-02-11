import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late final SharedPreferences preferences;
  static bool _init = false;
  static Future init() async {
    if (_init) return;
    preferences = await SharedPreferences.getInstance();
    _init = true;
    return preferences;
  }

  static setStringValue(String key, String value) {
    preferences.setString(key, value);
  }

  static setIntValue(String key, int value) {
    preferences.setInt(key, value);
  }

  static setDoubleValue(String key, double value) {
    preferences.setDouble(key, value);
  }

  static setBoolValue(String key, bool value) {
    preferences.setBool(key, value);
  }

  static String getStringValue(String key) {
    return preferences.getString(key) ?? "";
  }

  static int getIntValue(String key) {
    int? value = preferences.getInt(key);
    if (value == null) {
      throw Exception("Null value returned");
    }
    return value;
  }

  static bool getBoolValue(String key) {
    bool? value = preferences.getBool(key);
    if (value == null) {
      throw Exception("Null value returned");
    }
    return value;
  }

  static double getDoubleValue(String key) {
    double? value = preferences.getDouble(key);
    if (value == null) {
      throw Exception("Null value returned");
    }
    return value;
  }

  static Future<bool> removeValue(String key) {
    return preferences.remove(key);
  }
}
