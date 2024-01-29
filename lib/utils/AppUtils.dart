import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
class AppUtils {

  static getConfig(String key, dynamic defaultValue) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      if (!sp.containsKey(key)) return defaultValue;
      return sp.get(key);
    } catch (e) {}
    return defaultValue;
  }

  static setConfigString(String key, String value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(key, value);
  }

  static setConfigInt(String key, int value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt(key, value);
  }

  static setConfigDouble(String key, double value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setDouble(key, value);
  }


  static enterFullscreenMode() {
    if (html.document.fullscreenEnabled ?? false) {
      html.document.documentElement?.requestFullscreen();
    } else {
      print('Fullscreen mode not supported on this device.');
    }
  }
  static exitFullscreenMode(){
    if (html.document.fullscreenEnabled ?? false) {
      html.document.exitFullscreen();
    } else {
      print('Fullscreen mode not supported on this device.');
    }
  }


}
