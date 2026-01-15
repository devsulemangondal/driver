// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver/app/widget/images_name_path.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({
    super.key,
    required this.onPressConfirm,
    required this.onPressConfirmBtnName,
    required this.onPressConfirmColor,
    required this.onPressCancel,
    required this.title,
    this.onPressCancelTextColor,
    // required this.content,
    required this.onPressCancelColor,
    this.subTitle,
    this.iconOrGifPath,
    required this.onPressCancelBtnName,
    this.isGif = false,
  });

  final Function() onPressConfirm;
  final String onPressConfirmBtnName;
  final Color onPressConfirmColor;
  final Function() onPressCancel;
  final String onPressCancelBtnName;
  final Color onPressCancelColor;
  final Color? onPressCancelTextColor;
  final String title;
  final String? iconOrGifPath;
  final String? subTitle;
  final bool isGif;

  // final String content;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.black : AppThemeData.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: isGif == true
                        ? Image.asset(
                            iconOrGifPath.toString(),
                            height: 62,
                            width: 62,
                          )
                        : SvgPicture.asset(
                            iconOrGifPath ?? userCirclePlus,
                            color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: subTitle != null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        subTitle ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.none, fontFamily: FontFamily.medium, fontSize: 14, fontWeight: FontWeight.w600, color: AppThemeData.gallery400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Row(
                      children: [
                        AppButton(
                          text: onPressCancelBtnName,
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: onPressCancelTextColor ?? (themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800),
                              fontFamily: FontFamily.bold),
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: radius(12),
                          ),
                          height: 58,
                          color: onPressCancelColor,
                          elevation: 0,
                          onTap: onPressCancel,
                        ).expand(),
                        15.width,
                        AppButton(
                          text: onPressConfirmBtnName,
                          textStyle: TextStyle(fontSize: 18, color: themeChange.isDarkTheme() ? AppThemeData.black : AppThemeData.white, fontFamily: FontFamily.bold),
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: radius(12),
                          ),
                          height: 58,
                          color: onPressConfirmColor,
                          elevation: 0,
                          onTap: onPressConfirm,
                        ).expand(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


