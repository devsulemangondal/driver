import 'package:driver/app/modules/my_wallet/controllers/my_wallet_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/common_ui.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AddMoneyView extends StatelessWidget {
  const AddMoneyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: MyWalletController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme()
                ? AppThemeData.darkBackGroundColor
                : AppThemeData.grey50,
            resizeToAvoidBottomInset: false,
            appBar: UiInterface.customAppBar(
              context,
              themeChange,
              () {
                Get.back();
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextCustom(
                      title: "Add Money".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme()
                          ? AppThemeData.grey100
                          : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 2),
                    TextCustom(
                      title:
                          "Top up your wallet by adding funds from your bank account or card."
                              .tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme()
                          ? AppThemeData.grey400
                          : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 32.h),
                    TextFieldWidget(
                      title: "Enter Amount".tr,
                      hintText: "Enter Amount".tr,
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'This field required'.tr,
                      controller: controller.amountController,
                      onPress: () {},
                      onChanged: (value) {},
                      textInputType: TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      prefix: Text(
                        " ${Constant.currencyModel!.symbol.toString()}  |",
                        style: TextStyle(
                            fontSize: 16,
                            color: themeChange.isDarkTheme()
                                ? AppThemeData.grey200
                                : AppThemeData.grey800),
                      ),
                    ),
                    spaceH(height: 4.h),
                    TextCustom(
                      title:
                          "${"Min. Add money amount will be a".tr} ${Constant.amountShow(amount: Constant.minimumAmountToDeposit)}",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.italic,
                      color: AppThemeData.secondary300,
                    ),
                    spaceH(height: 24.h),
                    TextCustom(
                      title: "Recommended".tr,
                      fontSize: 16,
                      maxLine: 1,
                      fontFamily: FontFamily.medium,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 8.h),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        controller.addMoneyTagList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              controller.amountController.text =
                                  controller.addMoneyTagList[index];
                              controller.selectedAddAmountTags.value =
                                  controller.addMoneyTagList[index];
                            },
                            child: Obx(
                              () => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 8, right: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: controller
                                                .selectedAddAmountTags.value ==
                                            controller.addMoneyTagList[index]
                                        ? AppThemeData.secondary300
                                        : themeChange.isDarkTheme()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey200,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: TextCustom(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    title:
                                        '+ ${Constant.amountShow(amount: controller.addMoneyTagList[index])}',
                                    color: controller
                                                .selectedAddAmountTags.value ==
                                            controller.addMoneyTagList[index]
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
                    spaceH(height: 32.h),
                    TextCustom(
                      title: "Payment Method".tr,
                      fontSize: 16,
                      maxLine: 1,
                      fontFamily: FontFamily.medium,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 12.h),
                    Obx(() => RadioGroup<String>(
                          groupValue: controller.selectedPaymentMethod.value,
                          onChanged: (value) {
                            controller.selectedPaymentMethod.value = value!;
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: controller.paymentModel.value.paypal !=
                                        null &&
                                    controller.paymentModel.value.paypal!
                                            .isActive ==
                                        true,
                                child: Column(
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -10.0, 0.0),
                                      child: RadioListTile(
                                        value: Constant
                                            .paymentModel!.paypal!.name
                                            .toString(),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppThemeData.primary300,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/ig_paypal.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              Constant.paymentModel!.paypal!
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                color: themeChange.isDarkTheme()
                                                    ? AppThemeData.primaryWhite
                                                    : AppThemeData.primaryBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: controller.paymentModel.value.strip !=
                                        null &&
                                    controller.paymentModel.value.strip!
                                            .isActive ==
                                        true,
                                child: Column(
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -10.0, 0.0),
                                      child: RadioListTile(
                                        value: Constant
                                            .paymentModel!.strip!.name
                                            .toString(),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppThemeData.primary300,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/ig_stripe.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              Constant.paymentModel!.strip!
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                color: themeChange.isDarkTheme()
                                                    ? AppThemeData.primaryWhite
                                                    : AppThemeData.primaryBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible:
                                    controller.paymentModel.value.razorpay !=
                                            null &&
                                        controller.paymentModel.value.razorpay!
                                                .isActive ==
                                            true,
                                child: Column(
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -10.0, 0.0),
                                      child: RadioListTile(
                                        value: Constant
                                            .paymentModel!.razorpay!.name
                                            .toString(),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppThemeData.primary300,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/ig_razorpay.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              Constant.paymentModel!.razorpay!
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                color: themeChange.isDarkTheme()
                                                    ? AppThemeData.primaryWhite
                                                    : AppThemeData.primaryBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible:
                                    controller.paymentModel.value.flutterWave !=
                                            null &&
                                        controller.paymentModel.value
                                                .flutterWave!.isActive ==
                                            true,
                                child: Column(
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -10.0, 0.0),
                                      child: RadioListTile(
                                        value: Constant
                                            .paymentModel!.flutterWave!.name
                                            .toString(),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppThemeData.primary300,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/ig_flutterwave.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              Constant.paymentModel!
                                                      .flutterWave!.name ??
                                                  "",
                                              style: TextStyle(
                                                color: themeChange.isDarkTheme()
                                                    ? AppThemeData.primaryWhite
                                                    : AppThemeData.primaryBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible:
                                    controller.paymentModel.value.payStack !=
                                            null &&
                                        controller.paymentModel.value.payStack!
                                                .isActive ==
                                            true,
                                child: Column(
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -10.0, 0.0),
                                      child: RadioListTile(
                                        value: Constant
                                            .paymentModel!.payStack!.name
                                            .toString(),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppThemeData.primary300,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/ig_paystack.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              Constant.paymentModel!.payStack!
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                color: themeChange.isDarkTheme()
                                                    ? AppThemeData.primaryWhite
                                                    : AppThemeData.primaryBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Visibility(
                              //   visible: controller.paymentModel.value.mercadoPago != null && controller.paymentModel.value.mercadoPago!.isActive == true,
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                              //         child: RadioListTile(
                              //           value: Constant.paymentModel!.mercadoPago!.name.toString(),
                              //           controlAffinity: ListTileControlAffinity.trailing,
                              //           contentPadding: EdgeInsets.zero,
                              //           activeColor: AppThemeData.primary300,
                              //           title: Row(
                              //             children: [
                              //               Image.asset(
                              //                 "assets/images/ig_marcadopago.png",
                              //                 height: 50,
                              //                 width: 50,
                              //               ),
                              //               const SizedBox(width: 12),
                              //               Text(
                              //                 Constant.paymentModel!.mercadoPago!.name ?? "",
                              //                 style: TextStyle(
                              //                   color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                              //                   fontSize: 16,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Visibility(
                              //   visible: controller.paymentModel.value.payFast != null && controller.paymentModel.value.payFast!.isActive == true,
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                              //         child: RadioListTile(
                              //           value: Constant.paymentModel!.payFast!.name.toString(),
                              //           controlAffinity: ListTileControlAffinity.trailing,
                              //           contentPadding: EdgeInsets.zero,
                              //           activeColor: AppThemeData.primary300,
                              //           title: Row(
                              //             children: [
                              //               Image.asset(
                              //                 "assets/images/ig_payfast.png",
                              //                 height: 50,
                              //                 width: 50,
                              //               ),
                              //               const SizedBox(width: 12),
                              //               Text(
                              //                 Constant.paymentModel!.payFast!.name ?? "",
                              //                 style: TextStyle(
                              //                   color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                              //                   fontSize: 16,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Visibility(
                              //   visible: controller.paymentModel.value.midtrans != null && controller.paymentModel.value.midtrans!.isActive == true,
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                              //         child: RadioListTile(
                              //           value: Constant.paymentModel!.midtrans!.name.toString(),
                              //           controlAffinity: ListTileControlAffinity.trailing,
                              //           contentPadding: EdgeInsets.zero,
                              //           activeColor: AppThemeData.primary300,
                              //           title: Row(
                              //             children: [
                              //               Image.asset(
                              //                 "assets/images/ig_midtrans.png",
                              //                 height: 50,
                              //                 width: 50,
                              //               ),
                              //               const SizedBox(width: 12),
                              //               Text(
                              //                 Constant.paymentModel!.midtrans!.name ?? "",
                              //                 style: TextStyle(
                              //                   color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                              //                   fontSize: 16,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              Visibility(
                                visible: controller.paymentModel.value.xendit !=
                                        null &&
                                    controller.paymentModel.value.xendit!
                                            .isActive ==
                                        true,
                                child: Column(
                                  children: [
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -10.0, 0.0),
                                      child: RadioListTile(
                                        value: Constant
                                            .paymentModel!.xendit!.name
                                            .toString(),
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: AppThemeData.primary300,
                                        title: Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/ig_xendit.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              Constant.paymentModel!.xendit!
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                color: themeChange.isDarkTheme()
                                                    ? AppThemeData.primaryWhite
                                                    : AppThemeData.primaryBlack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: RoundShapeButton(
                title: "Add Money".tr,
                buttonColor: AppThemeData.primary300,
                buttonTextColor: AppThemeData.primaryWhite,
                textSize: 18,
                onTap: () async {
                  final enteredAmount =
                      double.tryParse(controller.amountController.value.text) ??
                          0;
                  final minimumAmount =
                      double.tryParse(Constant.minimumAmountToDeposit) ?? 0;

                  if (enteredAmount < minimumAmount) {
                    return ShowToastDialog.showToast(
                        "${"Minimum amount required is not met.".tr} $minimumAmount");
                  }

                  if (kDebugMode) {}

                  if (controller.selectedPaymentMethod.value.isNotEmpty) {
                    if (controller.amountController.value.text.isNotEmpty) {
                      if (double.parse(
                              controller.amountController.value.text) >=
                          Constant.minimumAmountToDeposit
                              .toString()
                              .toDouble()) {
                        ShowToastDialog.showLoader("Please Wait..".tr);
                        if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.paypal!.name) {
                          await controller.payPalPayment(
                              amount: controller.amountController.value.text);
                          Get.back();
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.strip!.name) {
                          await controller.stripeMakePayment(
                              amount: controller.amountController.text);
                          Get.back();
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.razorpay!.name) {
                          await controller.razorpayMakePayment(
                              amount: controller.amountController.text);
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.flutterWave!.name) {
                          await controller.flutterWaveInitiatePayment(
                              context: context,
                              amount: controller.amountController.text);
                          Get.back();
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.payStack!.name) {
                          await controller.payStackPayment(
                              controller.amountController.text);
                          Get.back();
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.mercadoPago!.name) {
                          controller.mercadoPagoMakePayment(
                              context: context,
                              amount: controller.amountController.text);
                          Get.back();
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.payFast!.name) {
                          controller.payFastPayment(
                              context: context,
                              amount: controller.amountController.text);
                          Get.back();
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.midtrans!.name) {
                          controller.midtransPayment(
                              context: context,
                              amount: controller.amountController.text);
                          Get.back();
                        } else if (controller.selectedPaymentMethod.value ==
                            Constant.paymentModel!.xendit!.name) {
                          controller.xenditPayment(
                              context: context,
                              amount: controller.amountController.text);
                          Get.back();
                        }
                        ShowToastDialog.closeLoader();
                      } else {
                        ShowToastDialog.showToast(
                            "${"Please enter at least the minimum amount.".tr} ${Constant.amountShow(amount: Constant.minimumAmountToDeposit)}");
                      }
                    } else {
                      ShowToastDialog.showToast(
                          "Enter an amount to continue.".tr);
                    }
                  } else {
                    ShowToastDialog.showToast("Select a payment method.".tr);
                  }
                },
                size: const Size(358, 58),
              ),
            ),
          );
        });
  }
}
