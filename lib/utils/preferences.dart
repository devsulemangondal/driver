// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const languageCodeKey = "languageCodeKey";
  static const themKey = "themKey";
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";

  static late SharedPreferences pref;

  static Future<void> initPref() async {
    try {
      pref = await SharedPreferences.getInstance();
      developer.log("SharedPreferences initialized successfully");
    } catch (e,stack) {
      developer.log("Error:initializing SharedPreferences:", error: e, stackTrace: stack);
    }
  }

  static bool getBoolean(String key) {
    try {
      return pref.getBool(key) ?? false;
    } catch (e,stack) {
      developer.log("Error:getting boolean from SharedPreferences:", error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<void> setBoolean(String key, bool value) async {
    try {
      await pref.setBool(key, value);
    } catch (e,stack) {
      developer.log("Error:setting boolean in SharedPreferences:", error: e, stackTrace: stack);
    }
  }

  static String getString(String key) {
    try {
      return pref.getString(key) ?? "";
    } catch (e,stack) {
      developer.log("Error:getting string from SharedPreferences:", error: e, stackTrace: stack);
      return "";
    }
  }

  static Future<void> setString(String key, String value) async {
    try {
      await pref.setString(key, value);
    } catch (e,stack) {
      developer.log("Error:setting string in SharedPreferences:", error: e, stackTrace: stack);
    }
  }

  static int getInt(String key) {
    try {
      return pref.getInt(key) ?? 0;
    } catch (e,stack) {
      developer.log("Error:getting int from SharedPreferences:", error: e, stackTrace: stack);
      return 0;
    }
  }

  static Future<void> setInt(String key, int value) async {
    try {
      await pref.setInt(key, value);
    } catch (e,stack) {
      developer.log("Error:setting int in SharedPreferences:", error: e, stackTrace: stack);

    }
  }

  static Future<void> clearSharPreference() async {
    try {
      await pref.clear();
    } catch (e,stack) {
      developer.log("Error:clearing SharedPreferences:", error: e, stackTrace: stack);
    }
  }

  static Future<void> clearKeyData(String key) async {
    try {
      await pref.remove(key);
    } catch (e,stack) {
      developer.log("Error:clearing key data from SharedPreferences:", error: e, stackTrace: stack);
    }
  }

}
