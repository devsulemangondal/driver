// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver/app/widget/images_name_path.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class HomeWidget {
  HomeWidget({Key? key});

  static Expanded mediumBox(
    BuildContext context, {
    required String image,
    required String title,
    required String subtitle,
    final Function()? onTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: ShapeDecoration(

            color: themeChange.isDarkTheme() ? AppThemeData.black01 : AppThemeData.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(image, height: 36, width: 36),
              12.height,
              Text(
                title,
                style: TextStyle(
                    color: themeChange.isDarkTheme() ? AppThemeData.gallery100 : AppThemeData.gallery800, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: FontFamily.regular),
              ),
              4.height,
              Text(
                subtitle,
                style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.violet400 : AppThemeData.gallery800, fontSize: 20, fontWeight: FontWeight.w700, fontFamily: FontFamily.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
  static InkWell onlineHandyMan(
    BuildContext context, {
    required String name,
    required String services,
    required String profileImage,
    required bool isActive,
    final Function()? onTap,
    final Function()? callOnTap,
    final Function()? messageOnTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
          height: 92,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeChange.isDarkTheme() ? AppThemeData.black01 : AppThemeData.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              NetworkImageWidget(
                imageUrl: profileImage,
                height: 60,
                width: 60,
                borderRadius: 8,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isActive ? AppThemeData.primaryGreen : AppThemeData.gallery300,
                          shape: BoxShape.circle,
                        ),
                      ),
                      4.width,
                      Text(
                        name,
                        style: TextStyle(
                          color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
                          fontSize: 14,
                          fontFamily: FontFamily.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  6.height,
                  Text(
                    services,
                    style: TextStyle(
                      color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
                      fontSize: 14,
                      fontFamily: FontFamily.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 34,
                        width: 34,
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.gallery950 : AppThemeData.gallery,
                        ),
                        child: SvgPicture.asset(
                          icPhone,
                          color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
                        ),
                      ).onTap(() => callOnTap),
                      2.width,
                      Container(
                        height: 34,
                        width: 34,
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(
                          boxShape: BoxShape.circle,
                          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.gallery950 : AppThemeData.gallery,
                        ),
                        child: SvgPicture.asset(
                          email,
                          color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
                        ),
                      ).onTap(() => messageOnTap),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static InkWell upcomingBooking(
    BuildContext context, {
    required String services,
    required String price,

    required String bookingNumber,
    required String profileImage,
    required String status,
    final Function()? onTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: SizedBox(
          height: 250,
          width: 230,
          child: Stack(
            children: [
              NetworkImageWidget(
                imageUrl: profileImage,
                height: 250,
                width: 230,
                borderRadius: 10,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 68,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: themeChange.isDarkTheme() ? AppThemeData.black01 : AppThemeData.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          services,
                          style: TextStyle(
                              color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                  color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontFamily.medium),
                            ),
                            Text(
                              status,
                              style: TextStyle(color: AppThemeData.yellow04, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: themeChange.isDarkTheme() ? const Color(0xff4B4B4B).withOpacity(0.8) : const Color(0xffF8F8F8).withOpacity(0.8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        )),
                    child: Text(
                      "ID:$bookingNumber",
                      style: TextStyle(
                          color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static InkWell jobRequestList(
    BuildContext context, {
    required String service,
    required String name,
    required String price,
    required String date,
    required String profileImage,
    required String status,
    final Function()? onTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Container(
          height: 134,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppThemeData.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: NetworkImageWidget(
                      imageUrl: profileImage,
                      height: 52,
                      width: 52,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                            color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: FontFamily.regular),
                      ),
                      10.height,
                      Text(
                        status,
                        style: TextStyle(color: AppThemeData.primaryGreen, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: FontFamily.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
                      ),
                      Text(
                        service,
                        style: TextStyle(
                            color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
                      )
                    ],
                  ),
                  Text(
                    Constant.amountShow(amount: price),
                    style: TextStyle(
                        color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: FontFamily.medium),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
