import 'package:driver/app/modules/home_screen/views/home_screen_view.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/signup_screen_controller.dart';

class AccountCreatedSuccessfullyView extends StatelessWidget {
  const AccountCreatedSuccessfullyView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SignupScreenController>(
        init: SignupScreenController(),
        builder: (controller) {
          return Container(
            height: ScreenSize.height(100, context),
            width: ScreenSize.width(100, context),
            decoration: BoxDecoration(
                gradient: themeChange.isDarkTheme()
                    ? LinearGradient(colors: [Color(0xff7E7EF6), Color(0xff4A4AF2), Color(0xff7E7EF6)], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                    : LinearGradient(colors: [Color(0xff3232AA), Color(0xff4A4AF2), Color(0xff3232AA)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(
              children: [
                spaceH(height: 240.h),
                SizedBox(
                  height: 140.h,
                  width: 140.w,
                  child: Image.asset(
                    "assets/images/account_successfully_created.png",
                  ),
                ),
                spaceH(height: 42.h),
                Padding(
                  padding: paddingEdgeInsets(horizontal: 39, vertical: 0),
                  child: TextCustom(
                    title: "Documents Uploaded Successfully".tr,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
                    fontSize: 28,
                    fontFamily: FontFamily.bold,
                  ),
                ),
                Padding(
                  padding: paddingEdgeInsets(horizontal: 30, vertical: 0),
                  child: TextCustom(
                    title: "Thank you for submitting your documents. We are currently reviewing your information to verify your identity. ".tr,
                    maxLine: 3,
                    color: themeChange.isDarkTheme() ? AppThemeData.secondary500 : AppThemeData.secondary100,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.regular,
                  ),
                ),
                spaceH(height: 52),
                RoundShapeButton(
                    size: Size(259.w, ScreenSize.height(6, context)),
                    title: "Continue".tr,
                    buttonColor: AppThemeData.primary300,
                    buttonTextColor: AppThemeData.primaryWhite,
                    onTap: () {
                      Get.offAll(()=>HomeScreenView());
                    }),
              ],
            ),
          );
        });
  }
}
