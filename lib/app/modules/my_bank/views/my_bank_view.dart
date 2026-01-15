// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:driver/app/models/bank_details_model.dart';
import 'package:driver/app/modules/add_bank/views/add_bank_view.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/common_ui.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controllers/my_bank_controller.dart';

class MyBankView extends GetView<MyBankController> {
  const MyBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<MyBankController>(
      init: MyBankController(),
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
            body: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "My Banks".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 2),
                  TextCustom(
                    title: "View and manage your linked bank accounts for withdrawals and transactions.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 32),
                  ContainerCustomSub(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const AddBankView());
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height: 46.h,
                                width: 46.w,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: AppThemeData.primary300,
                                    size: 30,
                                  ),
                                ),
                              ),
                              spaceW(),
                              TextCustom(
                                title: "Add New Bank".tr,
                                color: AppThemeData.primary300,
                                fontSize: 16,
                                fontFamily: FontFamily.medium,
                              ),
                            ],
                          ),
                        ),
                        spaceH(height: 5),
                        Obx(
                          () => ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.bankDetailsList.length,
                            itemBuilder: (context, index) {
                              BankDetailsModel bankDetailsModel = controller.bankDetailsList[index];
                              return Padding(
                                padding: paddingEdgeInsets(horizontal: 0, vertical: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50),
                                      height: 46.h,
                                      width: 46.w,
                                      child: Center(
                                        child: SizedBox(
                                          height: 18.h,
                                          width: 18.w,
                                          child: SvgPicture.asset("assets/icons/ic_bank.svg"),
                                        ),
                                      ),
                                    ),
                                    spaceW(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: ScreenSize.width(65, context),
                                          child: TextCustom(
                                            title: bankDetailsModel.bankName.toString(),
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                            fontSize: 16,
                                            textAlign: TextAlign.start,
                                            textOverflow: TextOverflow.ellipsis,
                                            fontFamily: FontFamily.medium,
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenSize.width(65, context),
                                          child: TextCustom(
                                            title: "${bankDetailsModel.holderName.toString()} | ${bankDetailsModel.accountNumber.toString()}",
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey600,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton(
                                        itemBuilder: (BuildContext bc) {
                                          return [
                                            PopupMenuItem<String>(
                                              height: 30,
                                              value: "Edit",
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Edit".tr,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              height: 30,
                                              value: "Delete",
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Delete".tr,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ];
                                        },
                                        onSelected: (value) {
                                          if (value == "Edit") {
                                            controller.editingId.value = bankDetailsModel.id.toString();
                                            controller.bankHolderNameController.text = bankDetailsModel.holderName.toString();
                                            controller.bankAccountNumberController.text = bankDetailsModel.accountNumber.toString();
                                            controller.swiftCodeController.text = bankDetailsModel.swiftCode.toString();
                                            controller.ifscCodeController.text = bankDetailsModel.ifscCode.toString();
                                            controller.bankNameController.text = bankDetailsModel.bankName.toString();
                                            controller.bankBranchCityController.text = bankDetailsModel.branchCity.toString();
                                            controller.bankBranchCountryController.text = bankDetailsModel.branchCountry.toString();
                                            Get.to(() => const AddBankView());
                                          } else {
                                            controller.deleteBankDetails(controller.bankDetailsList[index]);
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_three_dot.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
