// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:driver/app/models/cart_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/models/vendor_model.dart';
import 'package:driver/app/modules/order_details_screen/controllers/orders_details_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/constant_widget/pick_drop_point_view.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/common_ui.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersDetailsScreen extends StatelessWidget {
  const OrdersDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: OrderDetailsScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
            appBar: UiInterface.customAppBar(
              context,
              themeChange,
              () {
                Get.back();
              },
            ),
            body: Obx(
              () => Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: controller.isLoading.value
                      ? Constant.loader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Order Details".tr,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontFamily.bold,
                            ),
                            spaceH(height: 4.h),
                            TextCustom(
                              title: "View the full details of the customer’s order below.".tr,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              maxLine: 2,
                              textAlign: TextAlign.start,
                            ),
                            spaceH(height: 32.h),
                            TextCustom(
                              title: "Order Details".tr,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            spaceH(height: 8.h),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // color: AppThemeData.backGroundColor,
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.backGroundColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        title: "Order ID".tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                        color: AppThemeData.grey600,
                                      ),
                                      TextCustom(
                                        title: Constant.showId(controller.orderModel.value.id!),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        title: "Date".tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                        color: AppThemeData.grey600,
                                      ),
                                      TextCustom(
                                        title: Constant.timestampToDateTime(controller.orderModel.value.createdAt!),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        title: "Payment".tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                        color: AppThemeData.grey600,
                                      ),
                                      TextCustom(
                                        title: controller.orderModel.value.paymentType!,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            spaceH(height: 20.h),
                            TextCustom(
                              title: "Delivery Location".tr,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.medium,
                            ),
                            spaceH(height: 8.h),
                            PickDropPointView(
                                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                pickUpAddress: controller.orderModel.value.vendorAddress!.address!,
                                dropOutAddress: controller.orderModel.value.customerAddress!.address!),
                            TextCustom(
                              title: "Restaurant Details".tr,
                              fontSize: 16,
                              fontFamily: FontFamily.medium,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                            ),
                            spaceH(height: 6),
                            ContainerCustomSub(
                              child: FutureBuilder(
                                  future: FireStoreUtils.getRestaurant(controller.orderModel.value.vendorId.toString()),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    VendorModel restaurant = snapshot.data ?? VendorModel();
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                  height: 45.h,
                                                  width: 45.h,
                                                  child: NetworkImageWidget(
                                                    imageUrl: restaurant.coverImage.toString(),
                                                    borderRadius: 50,
                                                  )),
                                              spaceW(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextCustom(
                                                      title: restaurant.vendorName.toString(),
                                                      fontSize: 16,
                                                      fontFamily: FontFamily.bold,
                                                      textAlign: TextAlign.start,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                    ),
                                                    TextCustom(
                                                      title: restaurant.address!.address.toString(),
                                                      fontSize: 14,
                                                      maxLine: 1,
                                                      textOverflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.start,
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        spaceW(width: 8),
                                        GestureDetector(
                                          onTap: () async {
                                            ShowToastDialog.showLoader('Please Wait..'.tr);
                                            await FireStoreUtils.getOwnerProfile(restaurant.ownerId.toString()).then((value) async {
                                              if (value != null) {
                                                OwnerModel ownerModel = value;
                                                final fullPhoneNumber = '${ownerModel.countryCode}${ownerModel.phoneNumber}';
                                                final url = 'tel:$fullPhoneNumber';
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                  ShowToastDialog.closeLoader();
                                                } else {
                                                  ShowToastDialog.closeLoader();
                                                }
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: AppThemeData.secondary300,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset("assets/icons/ic_call.svg"),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                            spaceH(height: 20.h),
                            TextCustom(
                              title: "Customer Details".tr,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.medium,
                            ),
                            spaceH(height: 8.h),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // color: AppThemeData.backGroundColor,
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.backGroundColor,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NetworkImageWidget(
                                    imageUrl: controller.customerUSerModel.value.profilePic!,
                                    height: 40.h,
                                    // Responsive height
                                    width: 40.h,
                                    // Responsive width
                                    borderRadius: 200.r,
                                    fit: BoxFit.cover,
                                  ),
                                  spaceW(width: 8.w),
                                  SizedBox(
                                    width: 200.w,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(
                                          title: controller.customerUSerModel.value.firstName!,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        TextCustom(
                                          textAlign: TextAlign.start,
                                          title: "${controller.customerUSerModel.value.countryCode!} ${controller.customerUSerModel.value.phoneNumber!}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          maxLine: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      final fullPhoneNumber = '${controller.customerUSerModel.value.countryCode!}${controller.customerUSerModel.value.phoneNumber!}';
                                      final url = 'tel:$fullPhoneNumber';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {}
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppThemeData.secondary300,
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset("assets/icons/ic_call.svg"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            controller.isRejected.value
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      spaceH(height: 24.h),
                                      const TextCustom(
                                        title: "Reject Order Reason",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                      ),
                                      spaceH(height: 8.h),
                                      ContainerCustomSub(
                                        child: TextCustom(
                                          title: controller.userRejectedReasons.value,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          maxLine: 3,
                                          color: AppThemeData.danger300,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      spaceH(height: 20.h),
                                      TextCustom(
                                        title: "Item Details".tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                      ),
                                      spaceH(height: 8.h),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.backGroundColor,
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: controller.orderModel.value.items!.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            CartModel cartModel = controller.orderModel.value.items![index];
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_veg.svg",
                                                            color: AppThemeData.success300,
                                                          ),
                                                          spaceW(width: 5),
                                                          Flexible(
                                                            child: TextCustom(
                                                              title: "${cartModel.quantity}x ${cartModel.productName}",
                                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                              fontFamily: FontFamily.bold,
                                                              textAlign: TextAlign.start,
                                                              fontSize: 16,
                                                              maxLine: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: TextCustom(
                                                        title: Constant.amountShow(amount: cartModel.itemPrice.toString()),
                                                        color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                        fontFamily: FontFamily.medium,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      spaceH(height: 24.h),
                                      TextCustom(
                                        title: "Bill Details".tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                      ),
                                      spaceH(height: 8.h),
                                      ContainerCustomSub(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (controller.orderModel.value.deliveryCharge != null &&
                                                controller.orderModel.value.deliveryCharge!.isNotEmpty &&
                                                double.parse(controller.orderModel.value.deliveryCharge!) > 0)
                                              Row(
                                                children: [
                                                  TextCustom(
                                                    title: "Delivery Charge".tr,
                                                    fontSize: 16,
                                                    textAlign: TextAlign.start,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                                  ),
                                                  const Spacer(),
                                                  TextCustom(
                                                    title: Constant.amountShow(
                                                      amount: controller.orderModel.value.deliveryCharge,
                                                    ),
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.bold,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                                                  ),
                                                ],
                                              ),
                                            if (controller.orderModel.value.deliveryTip != null &&
                                                controller.orderModel.value.deliveryTip!.isNotEmpty &&
                                                double.parse(controller.orderModel.value.deliveryTip!) > 0)
                                              Row(
                                                children: [
                                                  TextCustom(
                                                    title: "Delivery Tip".tr,
                                                    fontSize: 16,
                                                    textAlign: TextAlign.start,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                                  ),
                                                  const Spacer(),
                                                  TextCustom(
                                                    title: Constant.amountShow(
                                                      amount: controller.orderModel.value.deliveryTip,
                                                    ),
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.bold,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                                                  ),
                                                ],
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              child: Dash(
                                                length: 320.w,
                                                direction: Axis.horizontal,
                                                dashColor: themeChange.isDarkTheme() ? AppThemeData.grey700 : AppThemeData.grey300,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                TextCustom(
                                                  title: "Total".tr,
                                                  fontSize: 16,
                                                  textAlign: TextAlign.start,
                                                  fontFamily: FontFamily.regular,
                                                  color: AppThemeData.primary300,
                                                ),
                                                const Spacer(),
                                                TextCustom(
                                                  title: Constant.amountShow(amount: controller.orderModel.value.totalAmount),
                                                  fontSize: 16,
                                                  fontFamily: FontFamily.bold,
                                                  color: AppThemeData.primary300,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      spaceH(height: 24.h),
                                      TextCustom(
                                        title: "Customer Review".tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: FontFamily.medium,
                                      ),
                                      spaceH(height: 8.h),
                                      ContainerCustomSub(
                                          alignment: Alignment.topLeft,
                                          child: controller.reviewModel.value.comment != null && controller.reviewModel.value.comment!.isNotEmpty
                                              ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RatingBar.builder(
                                                        glow: false,
                                                        initialRating: double.parse(controller.reviewModel.value.rating.toString()),
                                                        minRating: 0,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: false,
                                                        itemCount: 5,
                                                        tapOnlyMode: false,
                                                        itemSize: 18,
                                                        ignoreGestures: true,
                                                        itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                        itemBuilder: (context, _) => Icon(Icons.star, color: AppThemeData.flamenco400),
                                                        onRatingUpdate: (rating) {
                                                          // controller.rating(rating);
                                                        }),
                                                    spaceH(height: 4.h),
                                                    TextCustom(
                                                      title: controller.reviewModel.value.comment.toString(),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      maxLine: 3,
                                                      textAlign: TextAlign.start,
                                                    )
                                                  ],
                                                )
                                              : const TextCustom(
                                                  title: "Customer Not add review",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  maxLine: 3,
                                                  textAlign: TextAlign.start,
                                                )),
                                    ],
                                  )
                          ],
                        ),
                ),
              ),
            ),
          );
        });
  }
}
