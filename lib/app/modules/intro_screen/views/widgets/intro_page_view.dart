import 'package:driver/app/modules/intro_screen/controllers/intro_screen_controller.dart';
import 'package:driver/app/modules/landing_screen/views/landing_screen_view.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../../themes/responsive.dart';
import '../../../../../themes/screen_size.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IntroScreenPage extends StatelessWidget {
  final String title;
  final String body;
  final Color textColor;
  final String imageDarkMode;
  final String imageLightMode;

  const IntroScreenPage({
    super.key,
    required this.title,
    required this.body,
    required this.textColor,
    required this.imageDarkMode,
    required this.imageLightMode,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
        init: IntroScreenController(),
        builder: (controller) {
          int index = controller.currentPage.value;

          return Container(
            width: Responsive.width(100, context),
            height: Responsive.height(100, context),
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
            decoration: BoxDecoration(
                gradient: index == 0
                    ? LinearGradient(
                        colors: themeChange.isDarkTheme()
                            ? [const Color(0xff180202), const Color(0xff09090B)]
                            : [const Color(0xffFDE7E7), const Color(0xffFAFAFA)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)
                    : index == 1
                        ? LinearGradient(
                            colors: themeChange.isDarkTheme()
                                ? [const Color(0xff04150E), const Color(0xff09090B)]
                                : [const Color(0xffEAFBF3), const Color(0xffFAFAFA)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)
                        : index == 2
                            ? LinearGradient(
                                colors: themeChange.isDarkTheme()
                                    ? [const Color(0xff00171A), const Color(0xff09090B)]
                                    : [const Color(0xffE5FCFF), const Color(0xffFAFAFA)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)
                            : const LinearGradient(
                                colors: [Color(0xffE6FEF1), Color(0xffFAFAFA)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                index != 0
                    ? Padding(
                        padding: paddingEdgeInsets(horizontal: 16, vertical: 30),
                        child: GestureDetector(
                          onTap: () {
                            index = index - 1;
                            controller.pageController.jumpToPage(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                            ),
                            width: 40,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 20,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: paddingEdgeInsets(horizontal: 16, vertical: 30),
                        child: SizedBox(
                          height: 34.h,
                          width: 34.w,
                        ),
                      ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 28, fontFamily: FontFamily.bold, color: textColor))
                          .paddingOnly(left: 16, right: 16),
                      const SizedBox(height: 7),
                      Text(
                        body,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: FontFamily.light,
                          fontSize: 16,
                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                        ),
                      ).paddingOnly(left: 16, right: 16),
                      spaceH(height: 18),
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: themeChange.isDarkTheme() ? imageDarkMode : imageLightMode,
                          height: 390.h,
                          width: 408.w,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Constant.loader(),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundShapeButton(
                              size: Size(166.w, ScreenSize.height(6, context)),
                              title: "Skip".tr,
                              buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey700 : AppThemeData.grey300,
                              buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.textBlack,
                              onTap: () {
                                Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                Get.offAll(() => LandingScreenView());
                              }).paddingOnly(left: 16),
                          RoundShapeButton(
                              size: Size(166.w, ScreenSize.height(6, context)),
                              title: "Next".tr,
                              buttonColor: AppThemeData.primary300,
                              buttonTextColor: AppThemeData.primaryWhite,
                              onTap: () {
                                if (index == controller.onboardingList.length - 1) {
                                  Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                  Get.offAll(() => LandingScreenView());
                                } else {
                                  index = index + 1;
                                  controller.pageController.jumpToPage(index);
                                }
                              }).paddingOnly(right: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
