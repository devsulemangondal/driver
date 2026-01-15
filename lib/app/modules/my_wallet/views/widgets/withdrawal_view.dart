// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/admin_model.dart';
import 'package:driver/app/models/bank_details_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/withdraw_model.dart';
import 'package:driver/app/modules/my_wallet/controllers/my_wallet_controller.dart';
import 'package:driver/app/modules/my_wallet/views/widgets/complete_withdraw_money.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/services/email_template_service.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WithdrawalView extends StatelessWidget {
  const WithdrawalView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: GetX<MyWalletController>(
        init: MyWalletController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: paddingEdgeInsets(horizontal: 0, vertical: 30),
                  child: GestureDetector(
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
                      title: "Withdraw Amount".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 2),
                    TextCustom(
                      title: "Enter the amount you wish to withdraw from your wallet.".tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 32.h),
                    TextFieldWidget(
                      title: "Enter Withdraw Amount".tr,
                      hintText: "Enter Withdraw Amount".tr,
                      validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
                      controller: controller.withdrawalAmountController,
                      onPress: () {},
                      onChanged: (value) {},
                      prefix: Text(
                        " ${Constant.currencyModel!.symbol.toString()}  |",
                        style: TextStyle(fontSize: 16, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800),
                      ),
                      textInputType: TextInputType.numberWithOptions(decimal: true,signed: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                    ),
                    spaceH(height: 4.h),
                    TextCustom(
                      title: "${"Min. Withdrawal amount will be a".tr} ${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal)}",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.italic,
                      color: AppThemeData.secondary300,
                    ),
                    spaceH(height: 8.h),
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
                        controller.withdrawMoneyTagList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              controller.withdrawalAmountController.text = controller.withdrawMoneyTagList[index];
                              controller.selectedWithDrawTags.value = controller.withdrawMoneyTagList[index];
                            },
                            child: Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(bottom: 8, right: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: controller.selectedWithDrawTags.value == controller.withdrawMoneyTagList[index]
                                        ? AppThemeData.secondary300
                                        : themeChange.isDarkTheme()
                                            ? AppThemeData.grey800
                                            : AppThemeData.grey200,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: TextCustom(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    title: '+ ${Constant.amountShow(amount: controller.withdrawMoneyTagList[index])}',
                                    color: controller.selectedWithDrawTags.value == controller.withdrawMoneyTagList[index]
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
                    SizedBox(height: 16.h),
                    TextCustom(
                      title: "Note".tr,
                      fontSize: 16,
                      maxLine: 1,
                      fontFamily: FontFamily.medium,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 4.h),
                    Form(
                        key: controller.formKey.value,
                        child: TextFieldWidget(
                          controller: controller.withdrawalNoteController,
                          onPress: () {},
                          enabled: true,
                          hintText: "Enter Note".tr,
                          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
                          title: "Note :".tr,
                          textInputType: TextInputType.text,
                        )),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Select Bank".tr,
                            style: TextStyle(
                              color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.grey900,
                              fontSize: 16,
                              fontFamily: FontFamily.medium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Divider(),
                        );
                      },
                      itemCount: controller.bankDetailsList.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => Container(
                              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                              child: RadioGroup<BankDetailsModel>(
                                groupValue: controller.selectedBankMethod.value,
                                onChanged: (value) {
                                  controller.selectedBankMethod.value = value!;
                                },
                                child: RadioListTile(
                                  value: controller.bankDetailsList[index],
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: AppThemeData.primary300,
                                  title: SizedBox(
                                    height: 70,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          controller.bankDetailsList[index].bankName.toString(),
                                          style: TextStyle(
                                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          controller.bankDetailsList[index].accountNumber.toString(),
                                          style: TextStyle(
                                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          controller.bankDetailsList[index].holderName.toString(),
                                          style: TextStyle(
                                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        );
                      },
                    ),
                    Center(
                      child: RoundShapeButton(
                        title: "Withdraw".tr,
                        buttonColor: AppThemeData.primary300,
                        buttonTextColor: AppThemeData.primaryWhite,
                        onTap: () async {
                          final enteredAmount = double.tryParse(controller.withdrawalAmountController.value.text) ?? 0;
                          final minimumAmount = double.tryParse(Constant.minimumAmountToWithdrawal) ?? 0;

                          if (enteredAmount < minimumAmount) {
                            return ShowToastDialog.showToast("${"Minimum withdrawal amount not met.".tr} $minimumAmount".tr);
                          }
                          if (controller.formKey.value.currentState!.validate()) {
                            if (double.parse(controller.driverModel.value.walletAmount.toString()) <= double.parse(Constant.minimumAmountToWithdrawal.toString())) {
                              ShowToastDialog.showToast("Insufficient wallet balance.".tr);
                            } else {
                              ShowToastDialog.showLoader("Please Wait..".tr);
                              if (controller.withdrawalAmountController.value.text.isEmpty) {
                                ShowToastDialog.showToast("Enter an amount to continue.".tr);
                              } else if (double.parse(controller.driverModel.value.walletAmount.toString()) < double.parse(controller.withdrawalAmountController.value.text)) {
                                ShowToastDialog.showToast("Insufficient wallet balance.".tr);
                              } else if (double.parse(Constant.minimumAmountToWithdrawal) > double.parse(controller.withdrawalAmountController.value.text)) {
                                ShowToastDialog.showToast("${"Withdrawal amount must meet the minimum limit".tr}${Constant.amountShow(amount: Constant.minimumAmountToWithdrawal.toString())}");
                              } else {
                                ShowToastDialog.showLoader("Please Wait..".tr);
                                WithdrawModel withdrawModel = WithdrawModel();
                                withdrawModel.id = Constant.getUuid();
                                withdrawModel.ownerId = FireStoreUtils.getCurrentUid();
                                withdrawModel.paymentStatus = "Pending";
                                withdrawModel.type = 'driver';
                                withdrawModel.amount = controller.withdrawalAmountController.value.text;
                                withdrawModel.note = controller.withdrawalNoteController.value.text;
                                withdrawModel.createdDate = Timestamp.now();
                                withdrawModel.bankDetails = controller.selectedBankMethod.value;
                                await FireStoreUtils.updateDriverWallet(amount: "-${controller.withdrawalAmountController.value.text}");

                                DriverUserModel? driverModel = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid().toString());

                                await FireStoreUtils.setWithdrawRequest(withdrawModel).then((value) async {
                                  controller.getProfileData();
                                  controller.withdrawalAmountController.value.text != "";
                                  ShowToastDialog.closeLoader();
                                  ShowToastDialog.showToast("Request submitted to admin.".tr);
                                  Get.offAll(() => CompleteWithdrawView());
                                  await EmailTemplateService.sendEmail(
                                    type: 'withdraw_request',
                                    toEmail: driverModel!.email.toString(),
                                    variables: {
                                      'name': "${driverModel.firstName} ${driverModel.lastName}",
                                      'amount': Constant.amountShow(amount: controller.withdrawalAmountController.value.text),
                                      'app_name': Constant.appName.value
                                    },
                                  );

                                  AdminModel? admin = await FireStoreUtils.getAdminProfile();
                                  await EmailTemplateService.sendEmail(
                                    type: 'withdraw_request_admin',
                                    toEmail: admin!.email.toString(),
                                    variables: {
                                      'user_type': 'Driver',
                                      'name': "${driverModel.firstName} ${driverModel.lastName}",
                                      'user_name': "${driverModel.firstName} ${driverModel.lastName}",
                                      'amount': Constant.amountShow(amount: controller.withdrawalAmountController.value.text),
                                      'request_date': DateFormat('dd MMM yyyy, hh:mm a').format(withdrawModel.createdDate!.toDate()),
                                      'app_name': Constant.appName.value
                                    },
                                  );
                                });
                              }
                              controller.getWalletTransactions();
                            }
                          } else {
                            ShowToastDialog.showToast("Please enter a note.".tr);
                          }
                        },
                        size: const Size(358, 52),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
