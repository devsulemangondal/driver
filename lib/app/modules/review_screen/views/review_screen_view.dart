import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/app/modules/review_screen/controllers/review_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/star_rating.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ReviewScreenView extends GetView {
  const ReviewScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ReviewScreenController>(
        init: ReviewScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: paddingEdgeInsets(horizontal: 0, vertical: 34),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    ),
                    height: 34.h,
                    width: 34.w,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "Customer Reviews".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  controller.reviewList.isEmpty
                      ? Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: Center(child: TextCustom(title: "No Reviews Found".tr)),
                      )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.reviewList.length,
                          itemBuilder: (context, index) {
                            ReviewModel reviewModel = controller.reviewList[index];
                            return Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100, borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                      future: FireStoreUtils.getCustomerUserData(reviewModel.customerId.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Center(
                                            child: Constant.loader(),
                                          );
                                        }
                                        if (!snapshot.hasData || snapshot.data == null) {
                                          return Container();
                                        }
                                        CustomerUserModel customerModel = snapshot.data ?? CustomerUserModel();
                                        return NetworkImageWidget(
                                          imageUrl: customerModel.profilePic.toString(),
                                          isProfile: true,
                                          height: 48.h,
                                          width: 48.w,
                                          borderRadius: 50,
                                        );
                                      }),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                            future: FireStoreUtils.getCustomerUserData(reviewModel.customerId.toString()),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return Center(
                                                  child: Constant.loader(),
                                                );
                                              }
                                              if (!snapshot.hasData || snapshot.data == null) {
                                                return Container();
                                              }
                                              CustomerUserModel customerModel = snapshot.data ?? CustomerUserModel();
                                              return TextCustom(
                                                title: customerModel.fullNameString(),
                                                fontSize: 14,
                                                fontFamily: FontFamily.bold,
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                              );
                                            }),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        StarRating(
                                          onRatingChanged: (rating) {},
                                          color: AppThemeData.ratingBarColor,
                                          starCount: 5,
                                          rating: reviewModel.rating != null ? double.tryParse(reviewModel.rating.toString()) ?? 0.0 : 0.0,
                                        ),
                                        TextCustom(
                                          title: reviewModel.comment.toString(),
                                          fontSize: 12,
                                          maxLine: 2,
                                          textAlign: TextAlign.start,
                                          fontFamily: FontFamily.regular,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                ],
              ),
            ),
          );
        });
  }
}
