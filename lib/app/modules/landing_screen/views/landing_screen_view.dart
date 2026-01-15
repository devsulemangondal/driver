// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:driver/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:driver/app/modules/login_screen/views/login_screen_view.dart';
import 'package:driver/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'dart:io';

class LandingScreenView extends StatelessWidget {
  const LandingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoginScreenController(),
        builder: (controller) {
          return Container(
            height: ScreenSize.height(100, context),
            width: ScreenSize.width(100, context),
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/landing_page.png"), fit: BoxFit.cover)),
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                children: [
                  spaceH(height: 440.h),
                  TextCustom(
                    title: "join_app".trParams({'appName': Constant.appName.value}),
                    color: AppThemeData.grey50,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: FontFamily.bold,
                  ),
                  TextCustom(
                    title: "Deliver Faster, Smarter, and Easier.".tr,
                    maxLine: 2,
                    color: AppThemeData.grey50,
                    fontSize: 16,
                    fontFamily: FontFamily.light,
                  ),
                  spaceH(height: 32.h),
                  RoundShapeButton(
                      size: Size(358.w, ScreenSize.height(6, context)),
                      title: "Sign up".tr,
                      buttonColor: AppThemeData.primary300,
                      buttonTextColor: AppThemeData.primaryWhite,
                      onTap: () {
                        // Get.to(AddDocumentsScreenView());
                        Get.to(() => SignupScreenView(), arguments: {"type": Constant.emailLoginType});
                      }),
                  spaceH(height: 12),
                  RoundShapeButton(
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_google.svg",
                        ),
                        const Spacer(),
                        Text(
                          "Continue with Google".tr,
                          style: const TextStyle(fontFamily: FontFamily.medium, color: AppThemeData.grey1000, fontSize: 16),
                        ),
                        const Spacer(),
                      ],
                    ),
                    buttonColor: AppThemeData.grey50,
                    buttonTextColor: AppThemeData.grey1000,
                    onTap: () {
                      controller.loginWithGoogle();
                    },
                    size: Size(358.w, ScreenSize.height(6, context)),
                    title: '',
                  ),
                  spaceH(height: 12),
                  if (Platform.isIOS)
                    RoundShapeButton(
                      titleWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/ic_apple.svg",
                            color: AppThemeData.grey1000,
                          ),
                          const Spacer(),
                          Text(
                            "Continue with Apple".tr,
                            style: const TextStyle(fontFamily: FontFamily.medium, color: AppThemeData.grey1000, fontSize: 16),
                          ),
                          const Spacer(),
                        ],
                      ),
                      buttonColor: AppThemeData.grey50,
                      buttonTextColor: AppThemeData.grey1000,
                      onTap: () {
                        controller.loginWithApple();
                      },
                      size: Size(358.w, ScreenSize.height(6, context)),
                      title: '',
                    ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(text: "Already have an account? ".tr, style: const TextStyle(fontSize: 14, color: AppThemeData.grey50, fontFamily: FontFamily.regular), children: [
                            TextSpan(
                              text: "Log in".tr,
                              style: TextStyle(fontSize: 14, color: AppThemeData.primary300, fontFamily: FontFamily.medium, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = () => Get.to(LoginScreenView()),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
