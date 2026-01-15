import 'package:driver/app/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:driver/app/modules/my_wallet/views/my_wallet_view.dart';
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

class CompleteWithdrawView extends StatelessWidget {
  const CompleteWithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: HomeScreenController(),
        builder: (controller) {
          return Container(
            height: ScreenSize.height(100, context),
            width: ScreenSize.width(100, context),
            decoration: BoxDecoration(
                gradient: themeChange.isDarkTheme()
                    ? const LinearGradient(colors: [
                        Color(0xff04BF55),
                        Color(0xff9AE9BD),
                      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                    : const LinearGradient(colors: [
                        Color(0xff04BF55),
                        Color(0xff025024),
                      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(
              children: [
                spaceH(height: 240.h),
                SizedBox(
                  height: 140.h,
                  width: 140.w,
                  child: Image.asset(
                    "assets/animation/order_delivered.gif",
                  ),
                ),
                spaceH(height: 42.h),
                Padding(
                  padding: paddingEdgeInsets(horizontal: 16, vertical: 0),
                  child: TextCustom(
                    title: "Withdrawal Successful!".tr,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                    fontSize: 28,
                    fontFamily: FontFamily.bold,
                  ),
                ),
                Padding(
                  padding: paddingEdgeInsets(horizontal: 27, vertical: 0),
                  child: TextCustom(
                    title: "Your withdrawal request has been processed successfully. The amount will be credited to your bank account shortly.".tr,
                    maxLine: 4,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                    fontSize: 16,
                    fontFamily: FontFamily.regular,
                  ),
                ),
                spaceH(height: 52),
                RoundShapeButton(
                    size: Size(358.w, ScreenSize.height(6, context)),
                    title: "Continue".tr,
                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                    buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                    onTap: () {
                      Get.offAll(() => MyWalletView());
                    }),
              ],
            ),
          );
        });
  }
}
