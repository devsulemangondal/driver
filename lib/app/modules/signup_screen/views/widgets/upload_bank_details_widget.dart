import 'package:driver/app/modules/signup_screen/controllers/signup_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../themes/screen_size.dart';

class UploadBankDetailsWidget extends GetView<SignupScreenController> {
  const UploadBankDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return GetBuilder(
      init: SignupScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Stack(
              children: [
                Padding(
                  padding: paddingEdgeInsets(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTopWidget(context),
                      buildEmailPasswordWidget(context),
                      spaceH(height: 34.h),
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: RoundShapeButton(
                                title: "Next".tr,
                                buttonColor: controller.isSecondButtonEnabled.value
                                    ? AppThemeData.primary300
                                    : themeChange.isDarkTheme()
                                        ? AppThemeData.grey800
                                        : AppThemeData.grey200,
                                buttonTextColor: controller.isSecondButtonEnabled.value
                                    ? themeChange.isDarkTheme()
                                        ? AppThemeData.grey1000
                                        : AppThemeData.grey50
                                    : AppThemeData.grey500,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    // Get.to(EnterEmailScreenView());
                                    controller.nextStep();
                                  } else {
                                    ShowToastDialog.showToast("Please provide correct and complete information".tr);
                                  }
                                },
                                size: Size(358.w, ScreenSize.height(6, context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      spaceH(height: 20),
                    ],
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
  }

  SizedBox buildTopWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Upload Bank Details".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 24,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              )),
          Text("Please provide your bank account information to enable secure payments for your deliveries.".tr,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
              textAlign: TextAlign.start),
          spaceH(height: 32.h)
        ],
      ),
    );
  }

  Column buildEmailPasswordWidget(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          onPress: () {},
          controller: controller.bankHolderNameController.value,
          hintText: "Enter Bank Holder Name".tr,
          title: "Bank Holder Name".tr,
          enable: true,
          textInputType: TextInputType.text,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
        ),
        TextFieldWidget(
          onPress: () {},
          controller: controller.bankAccountNumberController.value,
          hintText: "Enter bank account number".tr,
          title: "Bank Account Number".tr,
          enable: true,
          textInputType: TextInputType.text,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
        ),
        TextFieldWidget(
          onPress: () {},
          controller: controller.swiftCodeController.value,
          hintText: "Enter Swift Code".tr,
          title: "Swift Code".tr,
          enable: true,
          textInputType: TextInputType.text,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
        ),
        TextFieldWidget(
          onPress: () {},
          controller: controller.bankIfscCodeController.value,
          hintText: "Enter IFSC Code".tr,
          title: "IFSC Code".tr,
          enable: true,
          textInputType: TextInputType.text,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
        ),
        TextFieldWidget(
          onPress: () {},
          controller: controller.bankNameController.value,
          hintText: "Enter Bank Name".tr,
          title: "Bank Name".tr,
          enable: true,
          textInputType: TextInputType.text,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
        ),
        TextFieldWidget(
          onPress: () {},
          controller: controller.bankBranchCityController.value,
          hintText: "Enter Bank Branch City".tr,
          title: "Bank Branch City".tr,
          enable: true,
          textInputType: TextInputType.text,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
        ),
        TextFieldWidget(
          onPress: () {},
          controller: controller.bankBranchCountryController.value,
          hintText: "Enter Bank Branch Country".tr,
          title: "Bank Branch Country".tr,
          enable: true,
          textInputType: TextInputType.text,
          validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
        ),
      ],
    );
  }
}
