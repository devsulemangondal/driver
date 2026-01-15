import 'package:driver/app/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/order_status.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/constant_widget/pick_drop_point_view.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../themes/screen_size.dart';

class NewOrderWidget extends StatelessWidget {
  const NewOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: HomeScreenController(),
      builder: (controller) {
        return ContainerCustom(
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
              // if (controller.orderModel.value.paymentType != null && Constant.paymentModel?.cash?.name != null && controller.orderModel.value.paymentType == 'Cash on Delivery')
              PickDropPointView(
                  pickUpAddress: controller.orderModel.value.vendorAddress!.address!, dropOutAddress: controller.orderModel.value.customerAddress!.address!.toString()),
              spaceH(height: 20.h),
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
                  Obx(
                    () => RoundShapeButton(
                        size: Size(157.w, ScreenSize.height(6, context)),
                        buttonColor: AppThemeData.success300,
                        title: "${"Accept in".tr} ${controller.formatSeconds(controller.remainingSeconds.value)}",
                        buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey1000,
                        onTap: () async {
                          if (controller.orderModel.value.paymentStatus != true) {
                            double orderAmount = double.tryParse(controller.orderModel.value.totalAmount!) ?? 0;
                            double walletAmount = double.tryParse(Constant.driverUserModel!.walletAmount!) ?? 0;
                            if (walletAmount < orderAmount) {
                              return ShowToastDialog.showToast(
                                  "${"Not enough balance in your wallet. Minimum amount required is not met.".tr} \$${orderAmount.toStringAsFixed(2)}.");
                            }
                          }

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
                        }),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
