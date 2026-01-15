// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, use_super_parameters

import 'dart:developer' as developer;

import 'package:driver/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:driver/app/modules/login_screen/views/login_screen_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends GetView<LoginScreenController> {
  ForgotPassword({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LoginScreenController>(
      init: LoginScreenController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
          ),
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTopWidget(context),
                  buildEmailPasswordWidget(context),
                  34.height,
                  Row(
                    children: [
                      Expanded(
                        child: RoundShapeButton(
                          title: "Send".tr,
                          buttonColor: AppThemeData.primary300,
                          buttonTextColor: AppThemeData.primaryWhite,
                          onTap: () async {
                            ShowToastDialog.showLoader("Please Wait..".tr);
                            if (controller.resetEmailController.value.text.isNotEmpty) {
                              await controller.resetPassword(controller.resetEmailController.value.text).then((value) {
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.showToast("Forgot password link send successfully".tr);
                                Get.offAllNamed(Routes.LOGIN_SCREEN);
                              }).catchError((e, stack) {
                                developer.log("Error in reset password", error: e, stackTrace: stack);
                                ShowToastDialog.showToast("Error");
                                log("Error : $e");
                                ShowToastDialog.closeLoader();
                              });
                            } else {
                              ShowToastDialog.showToast("Please enter a valid email".tr);
                            }
                          },
                          size: const Size(350, 55),
                        ),
                      ),
                    ],
                  ),
                  spaceH(height: 20),
                  GestureDetector(
                    onTap: () => Get.offAll(() => LoginScreenView()),
                    child: Text(
                      "Back to Sign In".tr,
                      style: TextStyle(fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000, decoration: TextDecoration.underline),
                      textAlign: TextAlign.right,
                    ).center(),
                  ),
                ],
              ),
            )),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: "Didn’t have an account? ".tr,
                      style: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.light),
                      children: [
                        TextSpan(
                          text: "Sign Up".tr,
                          style: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.primary200 : AppThemeData.primary500, fontFamily: FontFamily.medium),
                          recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => LoginScreenView()),
                        )
                      ]),
                ),
              ],
            ),
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
          Text("Forgot Your Password?".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 24,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              )),
          Text("Enter the email to recover the password".tr,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
              textAlign: TextAlign.center),
          18.height
        ],
      ),
    );
  }

  TextFieldWidget buildEmailPasswordWidget(BuildContext context) {
    return TextFieldWidget(
      title: "Email".tr,
      hintText: "Enter Email".tr,
      validator: (value) => Constant.validateEmail(value),
      controller: controller.resetEmailController.value,
      onPress: () {},
    );
  }
}
