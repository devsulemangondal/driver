// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:driver/app/modules/signup_screen/controllers/signup_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BasicDetailsWidget extends GetView<SignupScreenController> {
  const BasicDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: SignupScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: Stack(
            children: [
              Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTopWidget(context),
                    buildEmailPasswordWidget(context, controller),
                    spaceH(height: 34.h),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: RoundShapeButton(
                              title: "Next".tr,
                              buttonColor: controller.isFirstButtonEnabled.value
                                  ? AppThemeData.primary300
                                  : themeChange.isDarkTheme()
                                      ? AppThemeData.grey800
                                      : AppThemeData.grey200,
                              buttonTextColor: controller.isFirstButtonEnabled.value
                                  ? themeChange.isDarkTheme()
                                      ? AppThemeData.grey1000
                                      : AppThemeData.grey50
                                  : AppThemeData.grey500,
                              onTap: () async {
                                if (controller.firstNameController.value.text.trim().isEmpty) {
                                  ShowToastDialog.showToast("Please enter your first name".tr);
                                  return;
                                }
                                if (controller.lastNameController.value.text.trim().isEmpty) {
                                  ShowToastDialog.showToast("Please enter your last name".tr);
                                  return;
                                }
                                if (controller.mobileNumberController.value.text.trim().isEmpty) {
                                  ShowToastDialog.showToast("Please enter your mobile number".tr);
                                  return;
                                }
                                if (controller.emailController.value.text.trim().isEmpty) {
                                  ShowToastDialog.showToast("Please enter your email".tr);
                                  return;
                                }

                                if (controller.loginType.value == Constant.emailLoginType) {
                                  if (controller.passwordController.value.text.trim().isEmpty) {
                                    ShowToastDialog.showToast("Please enter your password".tr);
                                    return;
                                  }
                                  if (controller.confirmPasswordController.value.text.trim().isEmpty) {
                                    ShowToastDialog.showToast("Please confirm your password".tr);
                                    return;
                                  }
                                  if (controller.passwordController.value.text.trim() != controller.confirmPasswordController.value.text.trim()) {
                                    ShowToastDialog.showToast("Passwords do not match".tr);
                                    return;
                                  }
                                }

                                // If all checks passed
                                controller.nextStep();
                              },
                              size: Size(358.w, ScreenSize.height(6, context)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceH(height: 20),
                  ],
                ),
              ),
            ],
          )),
        );
      },
    );
  }

  SizedBox buildTopWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Enter Basic Details".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 24,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              )),
          Text("Please enter your basic details to set up your profile.".tr,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
              textAlign: TextAlign.start),
          spaceH(height: 32.h)
        ],
      ),
    );
  }

  Widget buildEmailPasswordWidget(
    BuildContext context,
    SignupScreenController controller,
  ) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        TextFieldWidget(
          title: "First Name".tr,
          hintText: "Enter First Name".tr,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
          controller: controller.firstNameController.value,
          onPress: () {},
        ),
        TextFieldWidget(
          title: "Last Name".tr,
          hintText: "Enter Last Name".tr,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
          controller: controller.lastNameController.value,
          onPress: () {},
        ),
        MobileNumberTextField(
          controller: controller.mobileNumberController.value,
          readOnly: controller.driverModel.value.loginType == Constant.phoneLoginType ? true : false,
          countryCode: controller.countryCode.value!,
          onPress: () {},
          title: "Mobile Number",
        ),
        Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldWidget(
                  title: "Email".tr,
                  hintText: "Enter Email".tr,
                  validator: (value) => Constant.validateEmail(value),
                  controller: controller.emailController.value,
                  onPress: () {},
                  readOnly: (controller.driverModel.value.loginType == Constant.googleLoginType || controller.driverModel.value.loginType == Constant.appleLoginType) ? true : false,
                ),
              ],
            )),
        if (controller.loginType.value == Constant.emailLoginType)
          Column(
            children: [
              Obx(() => TextFieldWidget(
                    title: "Password".tr,
                    hintText: "Enter Password".tr,
                    validator: (value) => Constant.validatePassword(value),
                    controller: controller.passwordController.value,
                    obscureText: controller.isPasswordVisible.value,
                    suffix: SvgPicture.asset(
                      controller.isPasswordVisible.value ? "assets/icons/ic_hide_password.svg" : "assets/icons/ic_show_password.svg",
                      color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                    ).onTap(() {
                      controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                    }),
                    onPress: () {},
                  )),
              Obx(() => TextFieldWidget(
                    title: "Confirm Password".tr,
                    hintText: "Enter Confirm Password".tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm password is required.".tr;
                      }
                      if (value != controller.passwordController.value.text) {
                        return "Passwords do not match.".tr;
                      }
                    },
                    controller: controller.confirmPasswordController.value,
                    obscureText: controller.isConfPasswordVisible.value,
                    suffix: SvgPicture.asset(
                      controller.isConfPasswordVisible.value ? "assets/icons/ic_hide_password.svg" : "assets/icons/ic_show_password.svg",
                      color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                    ).onTap(() {
                      controller.isConfPasswordVisible.value = !controller.isConfPasswordVisible.value;
                    }),
                    onPress: () {},
                  ))
            ],
          ),
        TextFieldWidget(
          title: "Refer Code".tr,
          hintText: "Enter Refer Code".tr,
          controller: controller.referralCodeController.value,
          onPress: () {},
        ),
      ],
    );
  }
}
