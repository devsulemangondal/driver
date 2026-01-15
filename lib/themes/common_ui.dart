// ignore_for_file: deprecated_member_use

import 'package:driver/app/widget/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class UiInterface {
  UiInterface({Key? key});

  static AppBar customAppBar(
    BuildContext context,
    themeChange,
      Function()? onBackTap,
  ) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      centerTitle: false,
      leading: GestureDetector(
        onTap: onBackTap ?? () => Get.back(),
        child: Padding(
          padding: paddingEdgeInsets(horizontal: 0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
