// ignore_for_file: must_be_immutable

import 'package:driver/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../themes/screen_size.dart';

class EnterMobileNumberView extends GetView<LoginScreenController> {
  EnterMobileNumberView({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: LoginScreenController(),
      builder: (controller) {
        controller.mobileNumberController.value.addListener(() => controller.checkFieldsFilled());

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                ),
                // height: 34.h,
                // width: 34.w,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                ),
              ),
            ),
          ),
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTopWidget(context),
                  buildMobileNumberWidget(context),
                  spaceH(height: 130.h),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: RoundShapeButton(
                            title: "Get OTP".tr,
                            buttonColor: controller.isMobileNumberButtonEnabled.value
                                ? AppThemeData.primary300
                                : themeChange.isDarkTheme()
                                    ? AppThemeData.grey800
                                    : AppThemeData.grey200,
                            buttonTextColor: controller.isMobileNumberButtonEnabled.value
                                ? themeChange.isDarkTheme()
                                    ? AppThemeData.grey1000
                                    : AppThemeData.grey50
                                : AppThemeData.grey500,
                            onTap: () {
                              if (controller.mobileNumberController.value.text.isNotEmpty) {
                                controller.sendCode();
                              } else {
                                ShowToastDialog.showToast("Please enter a valid number".tr);
                              }
                            },
                            size: Size(358.w, ScreenSize.height(6, context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
        );
      },
    );
  }

  SizedBox buildTopWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Enter Your Mobile Number".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 28,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
              )),
          Text("Provide your mobile number for order updates.".tr,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
              ),
              textAlign: TextAlign.start),
        ],
      ),
    );
  }

  MobileNumberTextField buildMobileNumberWidget(BuildContext context) {
    return MobileNumberTextField(
      controller: controller.mobileNumberController.value,
      countryCode: controller.countryCode.value!,
      onPress: () {},
      title: "Mobile Number",
    );
  }
}
