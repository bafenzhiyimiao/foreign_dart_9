import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



// 增、改
// sharedPreferences.setString(key, value);
// 删
// sharedPreferences.remove(key);
// 查
// sharedPreferences.get(key);

class LocalStorage {
  
  static Future getString(String key) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getString(key);
  }
  
  static Future setString(String key, String value) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(key,value);
  }

  static Future getJSON(String key) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var jsonstring = sharedPreferences.getString(key);
      try {
        return jsonDecode(jsonstring);
      }catch(e){
        return null;
      }
  }
  
  static Future setJSON(String key, value) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var jsonstring = jsonEncode(value);
      sharedPreferences.setString(key,jsonstring);
  }

  static Future getBool(String key) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.getBool(key);
  }

  static Future setBool(String key, bool value) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setBool(key, value);
  }

  static Future remove(String key) async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.remove(key);
  }
  static Future clear() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();
  }
}