// ignore_for_file: depend_on_referenced_packages, use_super_parameters, deprecated_member_use

import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:driver/themes/app_colors.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: SplashScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: Responsive.width(100, context),
            height: Responsive.height(100, context),
            // color: AppColors.primary300,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const [0.0, 0.0],
                  colors: [const Color(0xffE7E7FD).withOpacity(0.65), Color(0xffE6FEF1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/icons/ic_splash_logo.svg",
                    height: 63.h,
                    width: 90.w,
                  ),
                ),
                spaceH(height: 16),
                TextCustom(
                  title: '${Constant.appName}'.tr,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppThemeData.grey1000,
                ),
                TextCustom(
                  title: "Quick Bites, Big Delights".tr,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: FontFamily.italic,
                  color: AppThemeData.grey600,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
