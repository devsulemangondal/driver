// ignore_for_file: must_be_immutable, deprecated_member_use, depend_on_referenced_packages, use_super_parameters


import 'package:driver/app/modules/signup_screen/controllers/signup_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../../themes/screen_size.dart';

class UploadVehicleDetailsWidget extends GetView<SignupScreenController> {
  UploadVehicleDetailsWidget({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
      init: SignupScreenController(),
      builder: (controller) {
        controller.vehicleNameController.value.addListener(controller.checkIfFieldsAreFilled);
        controller.vehicleNumberController.value.addListener(controller.checkIfFieldsAreFilled);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Upload Vehicle Details".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    2.height,
                    TextCustom(
                      title: "Provide essential details such as Vehicle type, Model, Vehicle Number amd driving license.".tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 32),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: VehicleType.bike.obs,
                              groupValue: controller.vehicleType.value,
                              onChanged: (value) {
                                controller.vehicleType.value = VehicleType.bike;
                              },
                              activeColor: AppThemeData.primary300,
                            ),
                            TextCustom(
                              title: "Bike".tr,
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: VehicleType.scooter.obs,
                              groupValue: controller.vehicleType.value,
                              onChanged: (value) {
                                controller.vehicleType.value = VehicleType.scooter;
                              },
                              activeColor: AppThemeData.primary300,
                            ),
                            TextCustom(
                              title: "Scooter".tr,
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            )
                          ],
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Bike Model Name".tr,
                      hintText: "Enter Bike Model Name".tr,
                      controller: controller.vehicleNameController.value,
                      onPress: () {},
                    ),
                    spaceH(height: 15.h),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Vehicle Number".tr,
                      hintText: "Enter Vehicle Number".tr,
                      controller: controller.vehicleNumberController.value,
                      onPress: () {},
                    ),
                    spaceH(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 12),
            child: Obx( ()=>
               RoundShapeButton(
                title: "Next".tr,
                buttonColor: controller.restaurantDetailButton.value
                    ? AppThemeData.primary300
                    : themeChange.isDarkTheme()
                        ? AppThemeData.grey800
                        : AppThemeData.grey200,
                buttonTextColor: controller.restaurantDetailButton.value ? AppThemeData.grey50 : AppThemeData.grey500,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    if (controller.restaurantDetailButton.value) {
                      if (controller.editPage.value == "Upload the Driving License") {
                        // controller.saveData();
                        controller.editPage.value = "";
                      } else {
                        controller.nextStep();
                      }
                    }
                  }
                },
                size: Size(358.w, ScreenSize.height(6, context)),
              ),
            ),
          ),
        );
      },
    );
  }
}
