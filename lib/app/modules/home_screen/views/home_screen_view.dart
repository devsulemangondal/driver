// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, void_checks, use_build_context_synchronously

import 'package:driver/app/models/cart_model.dart';
import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:driver/app/modules/home_screen/views/widget/complete_delivery.dart';
import 'package:driver/app/modules/home_screen/views/widget/drawer_view.dart';
import 'package:driver/app/modules/home_screen/views/widget/new_order_show.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/order_status.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/services/email_template_service.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<HomeScreenController>(
        autoRemove: false,
        init: HomeScreenController(),
        builder: (controller) {
          return Scaffold(
              resizeToAvoidBottomInset: true,
              drawer: const DrawerView(),
              body: Stack(
                children: [
                  SizedBox(
                    height: Responsive.height(100, context),
                    child: Obx(
                      () => GoogleMap(
                        zoomControlsEnabled: false,
                        myLocationEnabled: false,
                        initialCameraPosition: CameraPosition(target: LatLng(Constant.currentLocation!.latitude!, Constant.currentLocation!.longitude!), zoom: 12),
                        padding: const EdgeInsets.only(
                          top: 22.0,
                        ),
                        polylines: Set<Polyline>.of(controller.polyLines.values),
                        markers: Set<Marker>.of(controller.markers.values),
                        onMapCreated: (GoogleMapController mapController) {
                          controller.mapController = mapController;
                        },
                      ),
                    ),
                  ),
                  controller.isLoading.value
                      ? Constant.loader()
                      : Column(
                          children: [
                            spaceH(height: MediaQuery.of(context).padding.top),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Obx(() => controller.orderModel.value.orderStatus != null
                                  ? controller.orderModel.value.orderStatus == OrderStatus.driverAssigned || controller.orderModel.value.orderStatus == OrderStatus.orderPending
                                      ? ContainerCustom(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Builder(builder: (context) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Scaffold.of(context).openDrawer();
                                                          },
                                                          child: NetworkImageWidget(
                                                            imageUrl: "${Constant.driverUserModel!.profileImage}",
                                                            height: 42.h,
                                                            width: 42.h,
                                                            borderRadius: 200.r,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      }),
                                                      Positioned(
                                                          bottom: 0,
                                                          right: 5,
                                                          child: Container(
                                                            height: 10.h,
                                                            width: 10.w,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: controller.driverStatus.value ? AppThemeData.success300 : AppThemeData.grey500,
                                                              border: Border.all(
                                                                color: AppThemeData.grey100,
                                                                width: 1.0,
                                                              ),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  spaceW(width: 12.w),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: Constant.driverUserModel!.firstName.toString(),
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                      TextCustom(
                                                        title: '${Constant.driverUserModel!.countryCode.toString()} ${Constant.driverUserModel!.phoneNumber.toString()}',
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: AppThemeData.grey600,
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  TextCustom(
                                                    title: "Status".tr,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: FontFamily.medium,
                                                  ),
                                                  spaceW(width: 8.w),
                                                  Switch(
                                                    value: controller.driverStatus.value,
                                                    onChanged: (value) async {
                                                      if (Constant.driverUserModel!.isVerified == true) {
                                                        double minimumAmountToDeposit = double.tryParse(Constant.minimumAmountToDeposit) ?? 0;
                                                        double walletAmount = double.tryParse(Constant.driverUserModel!.walletAmount!) ?? 0;

                                                        if (controller.driverStatus.value == true) {
                                                          controller.driverStatus.value = value;
                                                          await controller.updateDriverIsOnline();
                                                        }
                                                        if (walletAmount >= minimumAmountToDeposit) {
                                                          controller.driverStatus.value = value;
                                                          controller.updateDriverIsOnline();
                                                        } else {
                                                          ShowToastDialog.showToast(
                                                              "${"Not enough balance in your wallet. Minimum amount required is not met.".tr} \$${minimumAmountToDeposit.toStringAsFixed(2)}.");
                                                        }
                                                      } else {
                                                        ShowToastDialog.showToast("Your Account is not verify".tr);
                                                      }
                                                    },
                                                    activeTrackColor: AppThemeData.primary300,
                                                    activeColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                                                    inactiveTrackColor: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey400,
                                                    inactiveThumbColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
                                                    trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                      if (!states.contains(WidgetState.selected)) {
                                                        return themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.primaryWhite;
                                                      }
                                                      return AppThemeData.primary300;
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextCustom(
                                              title: Constant.showId(controller.orderModel.value.id.toString()),
                                              fontSize: 18,
                                              fontFamily: FontFamily.medium,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller.openGoogleMaps();
                                              },
                                              child: Container(
                                                height: 32.h,
                                                width: 91.w,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: AppThemeData.primary300),
                                                child: TextCustom(
                                                  title: "Go to Map".tr,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey100,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                  : ContainerCustom(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Builder(builder: (context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Scaffold.of(context).openDrawer();
                                                  },
                                                  child: NetworkImageWidget(
                                                    imageUrl: "${Constant.driverUserModel!.profileImage}",
                                                    height: 42.h,
                                                    width: 42.h,
                                                    borderRadius: 200.r,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              }),
                                              Positioned(
                                                  bottom: 0,
                                                  right: 5,
                                                  child: Container(
                                                    height: 10.h,
                                                    width: 10.w,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: controller.driverStatus.value ? AppThemeData.success300 : AppThemeData.grey500,
                                                      border: Border.all(
                                                        color: AppThemeData.grey100,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                          spaceW(width: 12.w),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextCustom(
                                                title: Constant.driverUserModel!.firstName.toString(),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              TextCustom(
                                                title: '${Constant.driverUserModel!.countryCode.toString()} ${Constant.driverUserModel!.phoneNumber.toString()}',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppThemeData.grey600,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          TextCustom(
                                            title: "Status".tr,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: FontFamily.medium,
                                          ),
                                          spaceW(width: 8.w),
                                          Transform.scale(
                                            scale: 0.8,
                                            child: Switch(
                                              value: controller.driverStatus.value,
                                              onChanged: (value) async {
                                                if (Constant.driverUserModel!.isVerified == true) {
                                                  if (controller.driverStatus.value == true) {
                                                    controller.driverStatus.value = value;
                                                    await controller.updateDriverIsOnline();
                                                  }
                                                  double minimumAmountToDeposit = double.tryParse(Constant.minimumAmountToDeposit) ?? 0;
                                                  double walletAmount = double.tryParse(Constant.driverUserModel!.walletAmount!) ?? 0;

                                                  if (walletAmount >= minimumAmountToDeposit) {
                                                    controller.driverStatus.value = value;
                                                    controller.updateDriverIsOnline();
                                                  } else {
                                                    ShowToastDialog.showToast(
                                                        "${"Not enough balance in your wallet. Minimum amount required is not met.".tr} \$${minimumAmountToDeposit.toStringAsFixed(2)}.");
                                                  }
                                                } else {
                                                  ShowToastDialog.showToast("Your Account is not verify".tr);
                                                }
                                              },
                                              activeTrackColor: AppThemeData.primary300,
                                              activeColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                                              inactiveTrackColor: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey400,
                                              inactiveThumbColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
                                              trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
                                                if (!states.contains(WidgetState.selected)) {
                                                  return themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.primaryWhite;
                                                }
                                                return AppThemeData.primary300;
                                              }),
                                            ),
                                          ),
                                          if (Constant.driverUserModel!.walletAmount == '0' || Constant.driverUserModel!.walletAmount == '0.0')
                                            GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              const Icon(Icons.account_balance_wallet_outlined, size: 60, color: Colors.redAccent),
                                                              const SizedBox(height: 16),
                                                              TextCustom(
                                                                title: "Insufficient Wallet Balance".tr,
                                                                fontSize: 16,
                                                                fontFamily: FontFamily.bold,
                                                              ),
                                                              spaceH(height: 12),
                                                              TextCustom(
                                                                title: 'wallet_balance_message'.trParams({'amount': Constant.amountShow(amount: '0.0')}),
                                                                fontFamily: FontFamily.medium,
                                                                fontSize: 14,
                                                                maxLine: 4,
                                                                color: AppThemeData.grey500,
                                                              ),
                                                              RichText(
                                                                textAlign: TextAlign.center,
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: "💡 ",
                                                                      style: TextStyle(
                                                                        fontFamily: FontFamily.medium,
                                                                        fontSize: 14,
                                                                        color: AppThemeData.thunderBird600,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: "Note: ".tr,
                                                                      style: TextStyle(
                                                                        fontFamily: FontFamily.medium,
                                                                        fontSize: 14,
                                                                        color: AppThemeData.thunderBird600,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          "For Cash on Delivery (COD) orders, your wallet balance must be equal to or greater than the total order amount, otherwise you cannot accept the order."
                                                                              .tr,
                                                                      style: TextStyle(
                                                                        fontFamily: FontFamily.medium,
                                                                        fontSize: 14,
                                                                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: SvgPicture.asset("assets/icons/ic_Info.svg", color: AppThemeData.red)),
                                        ],
                                      ),
                                    )),
                            ),
                            const Spacer(),
                            controller.driverStatus.value
                                ? controller.isOrderDataLoading.value == true
                                    ? Constant.loader()
                                    : controller.driverUserModel.value.orderId != null && controller.driverUserModel.value.orderId != ''
                                        ? controller.orderModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                controller.orderModel.value.orderStatus == OrderStatus.orderPending
                                            ? NewOrderWidget()
                                            : controller.orderModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                    controller.orderModel.value.orderStatus == OrderStatus.orderOnReady
                                                ? ContainerCustom(
                                                    margin: const EdgeInsets.all(16),
                                                    padding: const EdgeInsets.all(16),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
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
                                                        spaceH(height: 20.h),
                                                        ContainerCustomSub(
                                                          padding: const EdgeInsets.all(16),
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
                                                                      title: controller.orderModel.value.vendorAddress!.address.toString(),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                      maxLine: 4,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  final fullPhoneNumber = '${controller.ownerModel.value.countryCode}${controller.ownerModel.value.phoneNumber}';
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
                                                        RoundShapeButton(
                                                            size: Size(326.w, ScreenSize.height(6, context)),
                                                            title: "Arrive to Pickup location".tr,
                                                            buttonColor: AppThemeData.primary300,
                                                            buttonTextColor: AppThemeData.primaryWhite,
                                                            onTap: () {
                                                              orderIsReadyBottomSheet(context, controller, themeChange);
                                                            }),
                                                      ],
                                                    ),
                                                  )
                                                : ContainerCustom(
                                                    margin: const EdgeInsets.all(16),
                                                    padding: const EdgeInsets.all(16),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            TextCustom(
                                                              title: "Your Location To Drop Point: ".tr,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                            TextCustom(
                                                              title:
                                                                  "${Constant.calculateDistanceInKm(Constant.driverUserModel!.location!.latitude!, Constant.driverUserModel!.location!.longitude!, controller.orderModel.value.customerAddress!.location!.latitude!, controller.orderModel.value.customerAddress!.location!.longitude!)} km",
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w500,
                                                              color: AppThemeData.info300,
                                                            )
                                                          ],
                                                        ),
                                                        spaceH(height: 20.h),
                                                        ContainerCustomSub(
                                                          padding: const EdgeInsets.all(16),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              NetworkImageWidget(
                                                                imageUrl: controller.customerModel.value.profilePic.toString(),
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
                                                                      title: controller.customerModel.value.fullNameString(),
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w700,
                                                                    ),
                                                                    TextCustom(
                                                                      textAlign: TextAlign.start,
                                                                      title: controller.orderModel.value.customerAddress!.address.toString(),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w500,
                                                                      maxLine: 4,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  final fullPhoneNumber =
                                                                      '${controller.customerModel.value.countryCode}${controller.customerModel.value.phoneNumber}';
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
                                                        RoundShapeButton(
                                                            size: Size(326.w, ScreenSize.height(6, context)),
                                                            title: "Arrive to Drop location".tr,
                                                            buttonColor: AppThemeData.primary300,
                                                            buttonTextColor: AppThemeData.primaryWhite,
                                                            onTap: () {
                                                              orderDetailsBottomSheet(context, controller, themeChange);
                                                            }),
                                                      ],
                                                    ),
                                                  )
                                        : ContainerCustom(
                                            padding: const EdgeInsets.all(16),
                                            margin: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/ic_search.svg',
                                                  height: 22,
                                                  width: 22,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.primary300 : AppThemeData.primary300,
                                                ),
                                                spaceW(width: 12),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextCustom(
                                                      title: "Searching for Orders".tr,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    FittedBox(
                                                      child: TextCustom(
                                                        title: "We are finding new orders for you...".tr,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w400,
                                                        color: AppThemeData.grey600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                : ContainerCustom(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/ic_offline.svg',
                                          height: 22,
                                          width: 22,
                                          color: themeChange.isDarkTheme() ? AppThemeData.primary300 : AppThemeData.grey600,
                                        ),
                                        spaceW(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "You’re Offline".tr,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            FittedBox(
                                              child: TextCustom(
                                                title: "Go online to begin accepting new orders.".tr,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: AppThemeData.grey600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                ],
              ));
        });
  }
}

void orderIsReadyBottomSheet(BuildContext context, HomeScreenController controller, DarkThemeProvider themeChange) {
  if (!controller.isBottomSheetOpen.value) {
    controller.isBottomSheetOpen.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
        builder: (context) {
          return SizedBox(
            height: ScreenSize.height(70, context),
            width: ScreenSize.height(100, context),
            child: Obx(
              () => Padding(
                padding: const EdgeInsets.all(16),
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
                              TextCustom(
                                title: "Food is not ready yet.".tr,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              TextCustom(
                                title: "Please wait at the restaurant or nearby. You will be notified when the order is ready for pickup.".tr,
                                fontSize: 14,
                                textAlign: TextAlign.start,
                                fontWeight: FontWeight.w400,
                                maxLine: 3,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: "Order is ready for pickup".tr,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              TextCustom(
                                title: "${"ID".tr} ${controller.orderModel.value.id!.substring(0, 4)}",
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
                                    final fullPhoneNumber = '${controller.ownerModel.value.countryCode}${controller.ownerModel.value.phoneNumber}';
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
                            title: "Item Details".tr,
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
                                return Row(
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
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      size: Size(358.w, ScreenSize.height(6, context)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ).whenComplete(() {
        controller.isBottomSheetOpen.value = false;
      });
    });
  }
}

void orderDetailsBottomSheet(BuildContext context, HomeScreenController controller, DarkThemeProvider themeChange) {
  if (!controller.isBottomSheetOpenDetail.value) {
    controller.isBottomSheetOpenDetail.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: ScreenSize.height(80, context),
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
                              if (controller.orderModel.value.id!.isNotEmpty)
                                TextCustom(
                                  title: Constant.showId(controller.orderModel.value.id.toString()),
                                  fontSize: 14,
                                  isUnderLine: true,
                                  fontWeight: FontWeight.w400,
                                  color: AppThemeData.grey500,
                                ),
                            ],
                          ),
                          spaceH(height: 20.h),
                          if (controller.isRestaurantDataLoading.value == true)
                            Constant.loader()
                          else
                            ContainerCustomSub(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NetworkImageWidget(
                                    imageUrl: "${controller.customerModel.value.profilePic}",
                                    height: 40.h,
                                    width: 40.h,
                                    borderRadius: 200.r,
                                    fit: BoxFit.cover,
                                  ),
                                  spaceW(width: 8.w),
                                  Expanded(
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
                                  spaceW(width: 8.w),
                                  GestureDetector(
                                    onTap: () async {
                                      final fullPhoneNumber = '${controller.customerModel.value.countryCode}${controller.customerModel.value.phoneNumber}';
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
                          spaceH(height: 16.h),
                          TextCustom(
                            title: "Delivery Location".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
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
                                    TextCustom(
                                      title: "Dropout Point".tr,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
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
                          spaceH(height: 16.h),
                          TextCustom(
                            title: "Item Details".tr,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          spaceH(height: 8.h),
                          ContainerCustomSub(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.orderModel.value.items!.length,
                              itemBuilder: (context, index) {
                                CartModel cartModel = controller.orderModel.value.items![index];
                                return Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/ic_veg.svg",
                                      color: AppThemeData.success300,
                                    ),
                                    spaceW(width: 8),
                                    TextCustom(
                                      title: '${cartModel.quantity}x ${cartModel.productName}',
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                      fontFamily: FontFamily.bold,
                                      maxLine: 2,
                                      fontSize: 16,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          if (controller.orderModel.value.deliveryInstruction!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spaceH(height: 16.h),
                                TextCustom(
                                  title: "Delivery Instruction".tr,
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
                          spaceH(height: 16.h),
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
                                      title: "Payment is completed".tr,
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
                                      title: "Payment is Not completed".tr,
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
                              ShowToastDialog.showLoader("Please Wait..".tr);
                              await controller.addPaymentInWallet();
                              Navigator.pop(context);
                              controller.driverUserModel.value.orderId = null;
                              controller.driverUserModel.value.status = 'free';
                              controller.orderModel.value.orderStatus = OrderStatus.orderComplete;
                              controller.orderModel.value.paymentStatus = true;
                              FireStoreUtils.updateDriverUser(controller.driverUserModel.value);
                              FireStoreUtils.updateOrder(controller.orderModel.value);
                              ShowToastDialog.closeLoader();
                              Get.offAll(() => CompleteDeliveryView());
                              CustomerUserModel? userModel = await FireStoreUtils.getCustomerUserData(controller.orderModel.value.customerId.toString());
                              await EmailTemplateService.sendEmail(type: "order_delivered", toEmail: userModel!.email.toString(), variables: {
                                'name': userModel.fullNameString(),
                                'order_id': controller.orderModel.value.id.toString(),
                                'restaurant_name': controller.restaurantModel.value.vendorName.toString(),
                                'total_amount': Constant.amountShow(amount: controller.orderModel.value.totalAmount.toString()),
                                'delivery_address': controller.orderModel.value.customerAddress!.address.toString(),
                                'app_name': Constant.appName.value
                              });
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
      ).whenComplete(() {
        controller.isBottomSheetOpenDetail.value = false;
      });
    });
  }
}
