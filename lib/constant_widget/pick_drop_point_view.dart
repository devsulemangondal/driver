
// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class PickDropPointView extends StatelessWidget {
  final String pickUpAddress;
  final String dropOutAddress;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;


  const PickDropPointView({
    super.key,
    required this.pickUpAddress,
    this.bgColor,
    this.padding,
    required this.dropOutAddress,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      padding: padding ?? EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 16),
      decoration: ShapeDecoration(
        color: bgColor ??  (themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.backGroundColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Timeline.tileBuilder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: 0,
        ),
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.basic,
          indicatorBuilder: (context, index) {
            return index == 0
                ? SvgPicture.asset(
              "assets/icons/ic_pick_up.svg",
              height: 24.h,
              color: AppThemeData.primary300,
            )
                : SvgPicture.asset(
              "assets/icons/ic_drop_out.svg",
              height: 24.h,
              color: AppThemeData.secondary300,
            );
          },
          connectorBuilder: (context, index, connectorType) {
            return SizedBox(
              height: 55.h,
              child: const DashedLineConnector(
                gap: 2,
                dash: 3,
                thickness: 1,
                endIndent: 00,
                color: Color(0xfd4A4AF2),
              ),
            );
          },
          contentsBuilder: (context, index) => index == 0
              ? Container(
            width: Responsive.width(100, context),
            // padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  title: "Pickup Point".tr,
                  fontSize: 14,
                  fontFamily: FontFamily.light,
                  textAlign: TextAlign.start,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                ),
                TextCustom(
                  title: pickUpAddress,
                  fontSize: 16,
                  maxLine: 3,
                  textAlign: TextAlign.start,
                  fontFamily: FontFamily.medium,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                ),
              ],
            ),
          )
              : Container(
            width: Responsive.width(100, context),
            // padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  title: "Dropout Point".tr,
                  fontSize: 14,
                  fontFamily: FontFamily.light,
                  textAlign: TextAlign.start,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                ),
                TextCustom(
                  title: dropOutAddress,
                  fontSize: 16,
                  maxLine: 3,
                  fontFamily: FontFamily.medium,
                  textAlign: TextAlign.start,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                ),
              ],
            ),
          ),
          itemCount: 2,
        ),
      ),
    );
  }
}
