// ignore_for_file: use_super_parameters

import 'package:driver/app/modules/signup_screen/controllers/signup_screen_controller.dart';
import 'package:driver/app/modules/signup_screen/views/widgets/basic_details_widget.dart' show BasicDetailsWidget;
import 'package:driver/app/modules/signup_screen/views/widgets/upload_bank_details_widget.dart';
import 'package:driver/app/modules/signup_screen/views/widgets/upload_document_widget.dart' show UploadDocumentView;
import 'package:driver/app/modules/signup_screen/views/widgets/upload_vehicle_details_widget.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class SignupScreenView extends GetView<SignupScreenController> {
  const SignupScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SignupScreenController>(
      init: SignupScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: paddingEdgeInsets(horizontal: 0, vertical: 34),
              child: GestureDetector(
                onTap: () {
                  if (controller.currentStep.value == 0) {
                    Get.back();
                  } else {
                    controller.previousStep();
                  }
                },
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
            actions: [
              Obx(
                () => Row(
                  children: [
                    TextCustom(
                      title: "0${controller.currentStep.value + 1}",
                      fontFamily: FontFamily.bold,
                      fontSize: 16,
                      color: AppThemeData.primary300,
                    ),
                    const TextCustom(
                      title: "/04",
                      color: AppThemeData.grey500,
                    ),
                  ],
                ),
              ),
              spaceW(width: 16)
            ],
          ),
          body: Obx(() => stepper(context)),
        );
      },
    );
  }

  Widget stepper(BuildContext context) {
    return controller.isLoading.value
        ? Center(child: Constant.loader())
        : Obx(() => IndexedStack(
              index: controller.currentStep.value,
              children: Constant.isDriverDocumentVerification == true
                  ? [
                      BasicDetailsWidget(),
                      UploadVehicleDetailsWidget(),
                      UploadBankDetailsWidget(),
                      UploadDocumentView(),
                    ]
                  : [
                      BasicDetailsWidget(),
                      UploadVehicleDetailsWidget(),
                      UploadBankDetailsWidget(),
                    ],
            ));
  }
}
