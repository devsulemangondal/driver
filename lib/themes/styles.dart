import 'package:flutter/material.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:flutter/services.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor: isDarkTheme ? AppThemeData.gallery950 : AppThemeData.gallery50,
        primaryColor: isDarkTheme ? AppThemeData.primary : AppThemeData.primary,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // Android → black
            statusBarBrightness: Brightness.light, // iOS → black
          ),
        ));
  }
}
