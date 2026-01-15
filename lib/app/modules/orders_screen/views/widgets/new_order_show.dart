// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:driver/app/models/cart_model.dart';
import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/modules/home_screen/views/widget/complete_delivery.dart';
import 'package:driver/app/modules/orders_screen/controllers/orders_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/order_status.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/constant_widget/pick_drop_point_view.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/services/email_template_service.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../constant/send_notification.dart';

class NewOrderWidget extends StatelessWidget {
  const NewOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OrdersScreenController>(
      init: OrdersScreenController(),
      builder: (controller) {
        return ContainerCustomSub(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(
                    title: "New Order".tr,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  TextCustom(
                    title: Constant.showId(controller.orderModel.value.id.toString()),
                    isUnderLine: true,
                    color: AppThemeData.grey600,
                  )
                ],
              ),
              spaceH(height: 9.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextCustom(
                    title: "Total Earning".tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppThemeData.secondary300,
                  ),
                  TextCustom(
                    title: Constant.amountShow(
                        amount: controller.orderModel.value.paymentType == "Cash on Delivery"
                            ? controller.orderModel.value.totalAmount.toString()
                            : controller.orderModel.value.deliveryCharge.toString()),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              Visibility(
                visible: controller.orderModel.value.paymentType == 'Cash on Delivery',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextCustom(
                      title: "Payment Type".tr,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppThemeData.secondary300,
                    ),
                    TextCustom(
                      title: controller.orderModel.value.paymentType.toString(),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ).paddingOnly(top: 8.h),
              ),
              spaceH(height: 20.h),
              Row(
                children: [
                  TextCustom(
                    title: "Your Location To Pickup Point: ".tr,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  TextCustom(
                    title:
                        "${Constant.calculateDistanceInKm(Constant.driverUserModel!.location!.latitude!, Constant.driverUserModel!.location!.longitude!, controller.orderModel.value.vendorAddress!.location!.latitude!, controller.orderModel.value.vendorAddress!.location!.longitude!)} km",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppThemeData.info300,
                  )
                ],
              ),
              spaceH(height: 8.h),
              PickDropPointView(
                  bgColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
                  pickUpAddress: controller.orderModel.value.vendorAddress!.address!,
                  dropOutAddress: controller.orderModel.value.customerAddress!.address!.toString()),
              spaceH(height: 20.h),
              if (controller.orderModel.value.orderStatus == 'driver_assigned' || controller.orderModel.value.orderStatus == 'order_pending')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundShapeButton(
                        size: Size(157.w, ScreenSize.height(6, context)),
                        title: "Reject".tr,
                        buttonColor: themeChange.isDarkTheme() ? AppThemeData.danger300 : AppThemeData.danger300,
                        buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey50,
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
                              builder: (context) {
                                return controller.rejectOrderBottomSheet(context, controller, themeChange, controller.orderModel.value);
                              });
                        }),
                    RoundShapeButton(
                        size: Size(157.w, ScreenSize.height(6, context)),
                        title: "${"Accept in".tr} ${controller.formatSeconds(controller.remainingSeconds.value)}".tr,
                        buttonColor: AppThemeData.success300,
                        buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey1000,
                        onTap: () async {
                          if (controller.orderModel.value.paymentStatus != true) {
                            double orderAmount = double.tryParse(controller.orderModel.value.totalAmount!) ?? 0;
                            double walletAmount = double.tryParse(Constant.driverUserModel!.walletAmount!) ?? 0;
                            if (walletAmount < orderAmount) {
                              return ShowToastDialog.showToast("${"Not enough balance in your wallet. Minimum amount is".tr} \$${orderAmount.toStringAsFixed(2)}.");
                            }
                          } else {
                            controller.orderModel.value.orderStatus = OrderStatus.driverAccepted;
                            await FireStoreUtils.updateOrder(controller.orderModel.value);
                            if (controller.driverUserModel.value.orderId != null && controller.driverUserModel.value.orderId!.isNotEmpty) {
                              await Constant.updateEtaFromDriverLocation(
                                driverId: FireStoreUtils.getCurrentUid(),
                                driverLat: controller.driverUserModel.value.location!.latitude ?? 0.0,
                                driverLng: controller.driverUserModel.value.location!.longitude ?? 0.0,
                              );
                            }
                            Map<String, dynamic> playLoad = <String, dynamic>{"orderId": controller.orderModel.value.id};
                            SendNotification.sendOneNotification(
                                isPayment: controller.orderModel.value.paymentStatus ?? false,
                                isSaveNotification: true,
                                token: controller.customerModel.value.fcmToken.toString(),
                                title: 'Driver Accept the Order 🏍️📦️'.tr,
                                body: 'Order #${controller.orderModel.value.id.toString().substring(0, 4)} Accepted by Driver.',
                                type: 'order',
                                orderId: controller.orderModel.value.id,
                                senderId: FireStoreUtils.getCurrentUid(),
                                customerId: controller.customerModel.value.id.toString(),
                                payload: playLoad,
                                isNewOrder: false);

                            SendNotification.sendOneNotification(
                                isPayment: controller.orderModel.value.paymentStatus ?? false,
                                isSaveNotification: true,
                                token: controller.ownerModel.value.fcmToken.toString(),
                                title: 'Driver Accept the Order 🏍️📦️'.tr,
                                body: 'Order #${controller.orderModel.value.id.toString().substring(0, 4)} Accepted by Driver.',
                                type: 'order',
                                orderId: controller.orderModel.value.id,
                                senderId: FireStoreUtils.getCurrentUid(),
                                ownerId: controller.ownerModel.value.id,
                                payload: playLoad,
                                isNewOrder: false);
                          }
                        }),
                  ],
                ),
              if (controller.orderModel.value.orderStatus == 'driver_accepted' || controller.orderModel.value.orderStatus == 'order_on_ready')
                RoundShapeButton(
                  title: "Arrive to Pickup location".tr,
                  buttonColor: AppThemeData.primary300,
                  buttonTextColor: AppThemeData.primaryWhite,
                  onTap: () {
                    orderIsReadyBottomSheet(context, controller, themeChange);
                  },
                  size: Size(358.w, ScreenSize.height(6, context)),
                ),
              if (controller.orderModel.value.orderStatus == OrderStatus.driverPickup)
                RoundShapeButton(
                  title: "Arrive to Drop location".tr,
                  buttonColor: AppThemeData.primary300,
                  buttonTextColor: AppThemeData.primaryWhite,
                  onTap: () {
                    if (controller.orderModel.value.foodIsReadyToPickup == true) {
                      orderDetailsBottomSheet(context, controller, themeChange);
                    }
                  },
                  size: Size(358.w, ScreenSize.height(6, context)),
                ),
            ],
          ),
        );
      },
    );
  }
}

void orderIsReadyBottomSheet(BuildContext context, OrdersScreenController controller, DarkThemeProvider themeChange) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
      builder: (context) {
        return SizedBox(
          height: ScreenSize.height(60, context),
          width: ScreenSize.height(100, context),
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.all(16),
              child: controller.isLoading.value
                  ? Constant.loader()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20.h),
                            width: 72.w,
                            height: 8.h,
                            decoration: BoxDecoration(color: AppThemeData.grey400, borderRadius: BorderRadius.circular(100)),
                          ),
                        ),
                        spaceH(height: 13.h),
                        controller.orderModel.value.foodIsReadyToPickup == false
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      'assets/animation/food_not_ready.gif',
                                      height: 110.h,
                                      width: 110.w,
                                    ),
                                  ),
                                  spaceH(height: 12.h),
                                  const TextCustom(
                                    title: 'Food is not ready yet.',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const TextCustom(
                                    title: 'Please wait at the restaurant or nearby. You will be notified when the order is ready for pickup.',
                                    fontSize: 14,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w400,
                                    maxLine: 3,
                                  ),
                                ],
                              )
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                    title: 'Order is ready for pickup',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  TextCustom(
                                    title: 'ID #123456',
                                    fontSize: 14,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w400,
                                    maxLine: 3,
                                  ),
                                ],
                              ),
                        spaceH(height: 12.h),
                        controller.isRestaurantDataLoading.value == true
                            ? Constant.loader()
                            : Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.backGroundColor,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NetworkImageWidget(
                                      imageUrl: controller.restaurantModel.value.logoImage.toString(),
                                      height: 40.h,
                                      width: 40.h,
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
                                            title: controller.restaurantModel.value.vendorName.toString(),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          TextCustom(
                                            textAlign: TextAlign.start,
                                            title: controller.restaurantModel.value.address!.address!.toString(),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            maxLine: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                    spaceW(width: 8.w),
                                    GestureDetector(
                                      onTap: () async {
                                        final fullPhoneNumber = '${controller.ownerModel.value.countryCode!}${controller.ownerModel.value.phoneNumber!}';
                                        final url = 'tel:$fullPhoneNumber';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {}
                                      },
                                      child: Container(
                                        height: 34.h,
                                        width: 34.w,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppThemeData.secondary300),
                                        child: SvgPicture.asset(
                                          'assets/icons/ic_call.svg',
                                          height: 16.h,
                                          width: 16.w,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        spaceH(height: 20.h),
                        Visibility(
                          visible: controller.orderModel.value.foodIsReadyToPickup == false ? false : true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: 'Item Details'.tr,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppThemeData.grey600,
                              ),
                              spaceH(height: 8.h),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.backGroundColor,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.orderModel.value.items!.length,
                                  itemBuilder: (context, index) {
                                    CartModel cartModel = controller.orderModel.value.items![index];
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/ic_veg.svg",
                                              color: AppThemeData.success300,
                                            ),
                                            spaceW(width: 5),
                                            TextCustom(
                                              title: '${cartModel.quantity}x ${cartModel.productName}',
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                              fontFamily: FontFamily.bold,
                                              fontSize: 16,
                                            ),
                                            // const Spacer(),
                                            // TextCustom(
                                            //   title: Constant.amountShow(amount: '251'),
                                            //   color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            //   fontFamily: FontFamily.medium,
                                            //   fontSize: 16,
                                            // ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        RoundShapeButton(
                          title: "Pickup Complete".tr,
                          buttonColor: controller.orderModel.value.foodIsReadyToPickup == true
                              ? AppThemeData.primary300
                              : themeChange.isDarkTheme()
                                  ? AppThemeData.grey800
                                  : AppThemeData.grey200,
                          buttonTextColor: controller.orderModel.value.foodIsReadyToPickup == true
                              ? themeChange.isDarkTheme()
                                  ? AppThemeData.grey1000
                                  : AppThemeData.grey50
                              : AppThemeData.grey500,
                          onTap: () async {
                            if (controller.orderModel.value.foodIsReadyToPickup == true) {
                              CustomerUserModel? userModel = await FireStoreUtils.getCustomerUserData(controller.orderModel.value.customerId.toString());
                              Map<String, dynamic> playLoad = <String, dynamic>{"orderId": controller.orderModel.value.id};

                              SendNotification.sendOneNotification(
                                  isPayment: controller.orderModel.value.paymentStatus ?? false,
                                  isSaveNotification: true,
                                  token: controller.customerModel.value.fcmToken.toString(),
                                  title: 'Order pickup completed 🍽️'.tr,
                                  body: 'Order pickup completed 🍽️ order#${controller.orderModel.value.id.toString().substring(0, 4)}',
                                  type: 'order',
                                  orderId: controller.orderModel.value.id,
                                  senderId: FireStoreUtils.getCurrentUid(),
                                  customerId: userModel!.id.toString(),
                                  payload: playLoad,
                                  isNewOrder: false);

                              OwnerModel? ownerModel = await FireStoreUtils.getOwnerProfile(controller.ownerModel.value.id.toString());
                              SendNotification.sendOneNotification(
                                  isPayment: controller.orderModel.value.paymentStatus ?? false,
                                  isSaveNotification: true,
                                  token: controller.ownerModel.value.fcmToken.toString(),
                                  title: 'Order pickup completed 🍽️'.tr,
                                  body: 'Order pickup completed 🍽️ order#${controller.orderModel.value.id.toString().substring(0, 4)}',
                                  type: 'order',
                                  orderId: controller.orderModel.value.id,
                                  senderId: FireStoreUtils.getCurrentUid(),
                                  ownerId: ownerModel!.id.toString(),
                                  payload: playLoad,
                                  isNewOrder: false);

                              Navigator.pop(context);
                              controller.orderModel.value.orderStatus = OrderStatus.driverPickup;
                              FireStoreUtils.updateOrder(controller.orderModel.value);

                              if (controller.driverUserModel.value.location != null) {
                                await Constant.updateEtaFromDriverLocation(
                                  driverId: FireStoreUtils.getCurrentUid(),
                                  driverLat: controller.driverUserModel.value.location!.latitude ?? 0.0,
                                  driverLng: controller.driverUserModel.value.location!.longitude ?? 0.0,
                                );
                              } else {
                                print('PickupComplete: driver location is null, cannot update ETA yet');
                              }
                            }
                          },
                          size: Size(358.w, ScreenSize.height(6, context)),
                        )
                      ],
                    ),
            ),
          ),
        );
      });
}

void orderDetailsBottomSheet(BuildContext context, OrdersScreenController controller, DarkThemeProvider themeChange) {
  showModalBottomSheet(
    context: context,
    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: ScreenSize.height(90, context),
            width: ScreenSize.height(100, context),
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 20.h),
                          width: 72.w,
                          height: 8.h,
                          decoration: BoxDecoration(color: AppThemeData.grey400, borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                      spaceH(height: 13.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextCustom(
                            title: "Order Details".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          TextCustom(
                            title: Constant.showId(controller.orderModel.value.id.toString()),
                            fontSize: 14,
                            isUnderLine: true,
                            fontWeight: FontWeight.w400,
                            color: AppThemeData.grey600,
                          ),
                        ],
                      ),
                      spaceH(height: 20.h),
                      controller.isRestaurantDataLoading.value == true
                          ? Constant.loader()
                          : ContainerCustomSub(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NetworkImageWidget(
                                    imageUrl: "${controller.customerModel.value.profilePic}",
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
                                          title: controller.customerModel.value.firstName.toString(),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        TextCustom(
                                          textAlign: TextAlign.start,
                                          title: "${controller.customerModel.value.countryCode} ${controller.customerModel.value.phoneNumber}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          maxLine: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      final fullPhoneNumber = '${controller.customerModel.value.countryCode!}${controller.customerModel.value.phoneNumber!}';
                                      final url = 'tel:$fullPhoneNumber';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {}
                                    },
                                    child: Container(
                                      height: 34.h,
                                      width: 34.w,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppThemeData.secondary300),
                                      child: SvgPicture.asset(
                                        'assets/icons/ic_call.svg',
                                        height: 16.h,
                                        width: 16.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      spaceH(height: 20.h),
                      TextCustom(
                        title: "Delivery Location".tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppThemeData.grey600,
                      ),
                      spaceH(height: 8.h),
                      ContainerCustomSub(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_drop_out.svg',
                              height: 20.h,
                              width: 20.w,
                            ),
                            spaceW(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextCustom(
                                  title: 'Dropout Point',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppThemeData.grey800,
                                ),
                                SizedBox(
                                  width: 290.w,
                                  child: TextCustom(
                                    title: controller.orderModel.value.customerAddress!.address.toString(),
                                    fontSize: 16,
                                    textAlign: TextAlign.start,
                                    maxLine: 3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      spaceH(height: 20.h),
                      TextCustom(
                        title: "Item Details".tr,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppThemeData.grey600,
                      ),
                      spaceH(height: 8.h),
                      ContainerCustomSub(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.orderModel.value.items!.length,
                          itemBuilder: (context, index) {
                            CartModel cartModel = controller.orderModel.value.items![index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_veg.svg",
                                      color: AppThemeData.success300,
                                    ),
                                    spaceW(width: 5),
                                    TextCustom(
                                      title: '${cartModel.quantity}x ${cartModel.productName}',
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                      fontFamily: FontFamily.bold,
                                      maxLine: 2,
                                      fontSize: 16,
                                    ),
                                    // const Spacer(),
                                    // TextCustom(
                                    //   title: Constant.amountShow(amount: '251'),
                                    //   color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                    //   fontFamily: FontFamily.medium,
                                    //   fontSize: 16,
                                    // ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      spaceH(height: 20.h),
                      if (controller.orderModel.value.deliveryInstruction!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextCustom(
                              title: 'Delivery Instruction',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppThemeData.grey600,
                            ),
                            spaceH(height: 8.h),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.backGroundColor,
                              ),
                              child: TextCustom(
                                title: controller.orderModel.value.deliveryInstruction.toString(),
                                fontSize: 16,
                                textAlign: TextAlign.start,
                                maxLine: 2,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      spaceH(height: 20.h),
                      const TextCustom(
                        title: 'Bill Details',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.medium,
                      ),
                      spaceH(height: 8.h),
                      ContainerCustomSub(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              ).paddingOnly(top: 8),
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
                      spaceH(height: 12.h),
                      controller.orderModel.value.paymentStatus == true
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/ic_right.svg',
                                  height: 18.h,
                                  width: 18.w,
                                ),
                                spaceW(width: 4),
                                TextCustom(
                                  title: 'Payment is completed'.tr,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/ic_right.svg',
                                  height: 18.h,
                                  width: 18.w,
                                  color: AppThemeData.danger300,
                                ),
                                spaceW(width: 4),
                                TextCustom(
                                  title: 'Payment is Not completed'.tr,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                )
                              ],
                            ),
                      spaceH(height: 30.h),
                      RoundShapeButton(
                        title: "Delivery Complete".tr,
                        buttonColor: AppThemeData.primary300,
                        buttonTextColor: AppThemeData.primaryWhite,
                        onTap: () async {
                          Navigator.pop(context);
                          ShowToastDialog.showLoader("Please Wait..".tr);
                          await controller.addPaymentInWallet();
                          controller.driverUserModel.value.orderId = null;
                          controller.driverUserModel.value.status = 'free';
                          controller.orderModel.value.orderStatus = OrderStatus.orderComplete;
                          FireStoreUtils.updateDriverUser(controller.driverUserModel.value);
                          FireStoreUtils.updateOrder(controller.orderModel.value);
                          ShowToastDialog.closeLoader();
                          CustomerUserModel? userModel = await FireStoreUtils.getCustomerUserData(controller.orderModel.value.customerId.toString());
                          await EmailTemplateService.sendEmail(type: "order_delivered", toEmail: userModel!.email.toString(), variables: {
                            'name': userModel.fullNameString(),
                            'order_id': controller.orderModel.value.id.toString(),
                            'restaurant_name': controller.restaurantModel.value.vendorName.toString(),
                            'total_amount': Constant.amountShow(amount: controller.orderModel.value.totalAmount.toString()),
                            'delivery_address': controller.orderModel.value.customerAddress!.address.toString(),
                            'app_name': Constant.appName.value
                          });
                          Get.offAll(() => CompleteDeliveryView());
                        },
                        size: Size(358.w, ScreenSize.height(6, context)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
