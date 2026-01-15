// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/themes/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/common_ui.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import '../controllers/about_screen_controller.dart';

class AboutScreenView extends GetView<AboutScreenController> {
  final String title;
  final String htmlData;
  const AboutScreenView({Key? key,required this.title, required this.htmlData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
        appBar: UiInterface.customAppBar(
          context,
          themeChange,
          () {
            Get.back();
          },
        ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextCustom(
                title: title.tr,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.bold,
              ),
            ),
            spaceH(height: 4.h),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: HtmlWidget(
                  htmlData.toString(),
                  textStyle: DefaultTextStyle.of(context).style,
                  key: const Key('uniqueKey'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
