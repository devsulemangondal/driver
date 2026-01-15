import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/modules/order_details_screen/views/orders_details_screen.dart';
import 'package:driver/app/modules/orders_screen/controllers/orders_screen_controller.dart';
import 'package:driver/app/modules/orders_screen/views/widgets/new_order_show.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/constant_widget/pick_drop_point_view.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/common_ui.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class OrdersScreenView extends StatelessWidget {
  const OrdersScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OrdersScreenController(),
        builder: (controller) {
          return Container(
            width: Responsive.width(100, context),
            height: Responsive.height(100, context),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: const [0.1, 0.3],
                    colors: themeChange.isDarkTheme() ? [const Color(0xff01190B), const Color(0xff1C1C22)] : [const Color(0xffE6FEF1), const Color(0xffFFFFFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: UiInterface.customAppBar(
                context,
                themeChange,
                () {
                  Get.back();
                },
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: "Orders".tr,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.bold,
                        ),
                        spaceH(height: 4.h),
                        TextCustom(
                          title: "Track your order history and stay updated on your current deliveries.".tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          maxLine: 2,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  spaceH(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        controller.tagsList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              controller.selectedTags.value = controller.tagsList[index];
                            },
                            child: Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(bottom: 8, right: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: controller.selectedTags.value == controller.tagsList[index]
                                          ? AppThemeData.secondary300
                                          : themeChange.isDarkTheme()
                                              ? AppThemeData.grey800
                                              : AppThemeData.grey200,
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: paddingEdgeInsets(horizontal: 16, vertical: 8),
                                  child: TextCustom(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    title: controller.tagsList[index].tr,
                                    color: controller.selectedTags.value == controller.tagsList[index]
                                        ? AppThemeData.grey50
                                        : themeChange.isDarkTheme()
                                            ? AppThemeData.grey400
                                            : AppThemeData.grey600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  spaceH(height: 16.h),
                  Obx(
                    () => controller.selectedTags.value == "New Order"
                        ? Constant.isDriverOnline.value
                            ? controller.isLoading.value == true
                                ? Constant.loader()
                                : (controller.driverUserModel.value.orderId == null ||
                                        controller.driverUserModel.value.orderId!.isEmpty ||
                                        controller.orderModel.value.id == null ||
                                        controller.orderModel.value.id!.isEmpty)
                                    ? Center(child: TextCustom(title: "No New Order Found".tr))
                                    : NewOrderWidget()
                            : Center(child: TextCustom(title: "You’re Offline".tr))
                        : controller.selectedTags.value == "Completed"
                            ? Expanded(
                                child: controller.orderCompletedList.isEmpty
                                    ? Center(child: TextCustom(title: "No Data Available"))
                                    : Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: ListView.builder(
                                            itemCount: controller.orderCompletedList.length,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemBuilder: (context, index) {
                                              OrderModel orderModel = controller.orderCompletedList[index];
                                              CustomerUserModel customerUserModel = CustomerUserModel();
                                              return ContainerCustomSub(
                                                margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => OrdersDetailsScreen(), arguments: {'OrderModel': orderModel, 'CustomerUserModel': customerUserModel, "isRejected": false});
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          TextCustom(
                                                            title: Constant.timestampToDateTime(orderModel.createdAt!),
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                          TextCustom(
                                                            title: Constant.showId(orderModel.id.toString()),
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
                                                            fontWeight: FontWeight.w500,
                                                            color: AppThemeData.secondary300,
                                                          ),
                                                          TextCustom(
                                                            title: Constant.amountShow(amount: orderModel.totalAmount),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                          )
                                                        ],
                                                      ),
                                                      spaceH(height: 20.h),
                                                      FutureBuilder<CustomerUserModel?>(
                                                        future: FireStoreUtils.getCustomerUserData(orderModel.customerId!),
                                                        builder: (context, AsyncSnapshot<CustomerUserModel?> snapshot) {
                                                          if (!snapshot.hasData) {
                                                            return Container();
                                                          }
                                                          customerUserModel = snapshot.data!;
                                                          return Row(
                                                            children: [
                                                              NetworkImageWidget(
                                                                imageUrl: customerUserModel.profilePic.toString(),
                                                                height: 34.h,
                                                                // Responsive height
                                                                width: 34.h,
                                                                // Responsive width
                                                                borderRadius: 200.r,
                                                                fit: BoxFit.cover,
                                                              ),
                                                              spaceW(width: 8.w),
                                                              TextCustom(
                                                                title: customerUserModel.firstName.toString(),
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                              Spacer(),
                                                              Container(
                                                                height: 28.h,
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(4),
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.success600 : AppThemeData.success50,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child: TextCustom(
                                                                  title: "Completed".tr,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: FontFamily.bold,
                                                                  color: AppThemeData.success300,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      spaceH(height: 8.h),
                                                      PickDropPointView(
                                                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                        bgColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
                                                        pickUpAddress: orderModel.vendorAddress!.address!,
                                                        dropOutAddress: orderModel.customerAddress!.address!,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                              )
                            : Expanded(
                                child: controller.rejectOrderListList.isEmpty
                                    ? Center(child: TextCustom(title: "No Data Available".tr))
                                    : ListView.builder(
                                        itemCount: controller.rejectOrderListList.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          OrderModel rejectedOrderModel = controller.rejectOrderListList[index];
                                          CustomerUserModel customerUserModel = CustomerUserModel();
                                          return ContainerCustomSub(
                                            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() => OrdersDetailsScreen(), arguments: {'OrderModel': rejectedOrderModel, 'CustomerUserModel': customerUserModel, 'isRejected': true});
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextCustom(
                                                        title: Constant.timestampToDateTime(rejectedOrderModel.createdAt!),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      TextCustom(
                                                        title: Constant.showId(rejectedOrderModel.id.toString()),
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
                                                        fontWeight: FontWeight.w500,
                                                        color: AppThemeData.secondary300,
                                                      ),
                                                      TextCustom(
                                                        title: Constant.amountShow(amount: rejectedOrderModel.totalAmount),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                      )
                                                    ],
                                                  ),
                                                  spaceH(height: 20.h),
                                                  FutureBuilder<CustomerUserModel?>(
                                                    future: FireStoreUtils.getCustomerUserData(rejectedOrderModel.customerId!),
                                                    builder: (context, AsyncSnapshot<CustomerUserModel?> snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Container();
                                                      }
                                                      customerUserModel = snapshot.data!;
                                                      return Row(
                                                        children: [
                                                          NetworkImageWidget(
                                                            imageUrl: customerUserModel.profilePic.toString(),
                                                            height: 34.h,
                                                            width: 34.h,
                                                            borderRadius: 200.r,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          spaceW(width: 8.w),
                                                          TextCustom(
                                                            title: customerUserModel.firstName.toString(),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            height: 28.h,
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(4),
                                                              color: themeChange.isDarkTheme() ? AppThemeData.danger600 : AppThemeData.danger50,
                                                            ),
                                                            alignment: Alignment.center,
                                                            child: TextCustom(
                                                              title: "Rejected".tr,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: FontFamily.bold,
                                                              color: AppThemeData.danger300,
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  spaceH(height: 8.h),
                                                  PickDropPointView(
                                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                                    bgColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
                                                    pickUpAddress: rejectedOrderModel.vendorAddress!.address!,
                                                    dropOutAddress: rejectedOrderModel.customerAddress!.address!,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                              ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
