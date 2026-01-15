// ignore_for_file: must_be_immutable, use_super_parameters, deprecated_member_use, depend_on_referenced_packages

import 'package:driver/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:driver/app/modules/login_screen/views/forget_password_view.dart';
import 'package:driver/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constant/constant.dart';
import '../../../../themes/screen_size.dart';
import '../../../widget/text_widget.dart';
import 'enter_mobile_number_view.dart';

class LoginScreenView extends GetView<LoginScreenController> {
  LoginScreenView({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LoginScreenController>(
      init: LoginScreenController(),
      builder: (controller) {
        controller.emailController.value.addListener(() => controller.checkFieldsFilled());
        controller.passwordController.value.addListener(() => controller.checkFieldsFilled());
        // controller.mobileNumberController.value.addListener(() => controller.checkFieldsFilled());

        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    ),
                  ),
                ),
              ),
            ),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                  child: Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTopWidget(context),
                    buildEmailPasswordWidget(context, controller),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: const ButtonStyle(padding: WidgetStatePropertyAll(EdgeInsets.zero)),
                          onPressed: () {
                            Get.to(() => ForgotPassword());
                          },
                          child: TextCustom(
                            title: "Forgot Password?".tr,
                            color: AppThemeData.accent300,
                            fontFamily: FontFamily.medium,
                            isUnderLine: true,
                            textAlign: TextAlign.right,
                          ),
                        ).flexible(),
                      ],
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: RoundShapeButton(
                              title: "Log in".tr,
                              buttonColor: controller.isLoginButtonEnabled.value
                                  ? AppThemeData.primary300
                                  : themeChange.isDarkTheme()
                                      ? AppThemeData.grey800
                                      : AppThemeData.grey200,
                              buttonTextColor: controller.isLoginButtonEnabled.value
                                  ? themeChange.isDarkTheme()
                                      ? AppThemeData.grey1000
                                      : AppThemeData.grey50
                                  : AppThemeData.grey500,
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  controller.emailSignIn();
                                } else {
                                  ShowToastDialog.showToast("Please provide correct and complete information".tr);
                                }
                              },
                              size: Size(358.w, ScreenSize.height(6, context)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceH(height: 20),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(child: Divider(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400)),
                        spaceW(),
                        Text(
                          "Or".tr,
                          style: TextStyle(fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400),
                          textAlign: TextAlign.right,
                        ),
                        spaceW(),
                        Expanded(child: Divider(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400)),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    spaceH(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: RoundShapeButton(
                            titleWidget: Text(
                              "Continue with mobile number".tr,
                              style: TextStyle(fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50, fontSize: 18),
                            ),
                            buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                            buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                            onTap: () {
                              Get.to(() => EnterMobileNumberView());
                            },
                            size: Size(358.w, ScreenSize.height(6, context)),
                            title: '',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'new_in'.trParams({'appName': Constant.appName.value}),
                        style: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900, fontFamily: FontFamily.regular),
                        children: [
                          TextSpan(
                            text: "Create account".tr,
                            style: TextStyle(fontSize: 14, color: AppThemeData.primary300, fontFamily: FontFamily.medium, decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => SignupScreenView(), arguments: {"type": Constant.emailLoginType}),
                          )
                        ]),
                  ),
                ],
              ),
            ));
      },
    );
  }

  SizedBox buildTopWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('welcome_back'.trParams({'appName': Constant.appName.value}),
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 28,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
              )),
          Text("Login to manage your Account.".tr,
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
    return MobileNumberTextField(controller: controller.mobileNumberController.value, countryCode: controller.countryCode.value!, onPress: () {}, title: "Mobile Number".tr);
  }

  Column buildEmailPasswordWidget(BuildContext context, LoginScreenController controller) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Column(
      children: [
        TextFieldWidget(
          title: "Email".tr,
          hintText: "Enter Email".tr,
          validator: (value) => Constant.validateEmail(value),
          controller: controller.emailController.value,
          onPress: () {},
        ),
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
            ))
      ],
    );
  }
}
