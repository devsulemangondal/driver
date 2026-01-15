// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, deprecated_member_use, depend_on_referenced_packages

import 'dart:io';

import 'package:driver/app/modules/edit_profile_screen/controllers/edit_profile_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import 'package:driver/themes/responsive.dart' as responsive_ui;

class EditProfileScreenView extends StatelessWidget {
  const EditProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<EditProfileScreenController>(
        init: EditProfileScreenController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: paddingEdgeInsets(horizontal: 0, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 3),
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
              child: Form(
                key: controller.formKey,
                child: Padding(
                  padding: paddingEdgeInsets(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: "Edit Profile".tr,
                        fontSize: 28,
                        maxLine: 2,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                        fontFamily: FontFamily.bold,
                        textAlign: TextAlign.start,
                      ),
                      spaceH(height: 2),
                      TextCustom(
                        title: "Update your personal details and preferences here.".tr,
                        fontSize: 16,
                        maxLine: 2,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                        fontFamily: FontFamily.regular,
                        textAlign: TextAlign.start,
                      ),
                      spaceH(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 116.w,
                                width: 116.w,
                                decoration: BoxDecoration(shape: BoxShape.circle),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(200),
                                  child: Obx(() {
                                    if (controller.isLoading.value) {
                                      return Constant.loader();
                                    } else if (controller.profileImage.value.isNotEmpty && !Constant.hasValidUrl(controller.profileImage.value)) {
                                      return Image.file(
                                        File(controller.profileImage.value),
                                        height: 116.w,
                                        width: 116.w,
                                        fit: BoxFit.cover,
                                      );
                                    } else if (Constant.hasValidUrl(controller.profileImage.value)) {
                                      return NetworkImageWidget(
                                        imageUrl: controller.profileImage.value,
                                        height: 116.w,
                                        width: 116.w,
                                        borderRadius: 0,
                                        fit: BoxFit.cover,
                                        isProfile: true,
                                      );
                                    } else {
                                      return Image.asset(
                                        Constant.userPlaceHolder,
                                        height: 116.w,
                                        width: 116.w,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  }),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  buildBottomSheet(context, controller, themeChange);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 4, bottom: 4),
                                  height: 32.h,
                                  width: 32.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppThemeData.primary300,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_edit_pen.svg",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextFieldWidget(
                        title: "First Name".tr,
                        hintText: "Enter First Name".tr,
                        validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
                        controller: controller.firstNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidget(
                        title: "Last Name".tr,
                        hintText: "Enter Last Name".tr,
                        validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
                        controller: controller.lastNameController.value,
                        onPress: () {},
                      ),
                      TextFieldWidget(
                        title: "Email".tr,
                        hintText: "Enter Email".tr,
                        validator: (value) => Constant.validateEmail(value),
                        controller: controller.emailController.value,
                        onPress: () {},
                        readOnly: Constant.driverUserModel!.loginType == Constant.emailLoginType ||
                                Constant.driverUserModel!.loginType == Constant.googleLoginType ||
                                Constant.driverUserModel!.loginType == Constant.appleLoginType
                            ? true
                            : false,
                      ),
                      MobileNumberTextField(
                        controller: controller.mobileNumberController.value,
                        countryCode: "+91",
                        onPress: () {},
                        title: "Mobile Number".tr,
                        readOnly: Constant.driverUserModel!.loginType == Constant.phoneLoginType ? true : false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: paddingEdgeInsets(vertical: 8),
              child: RoundShapeButton(
                title: "Save Details".tr,
                buttonColor: themeChange.isDarkTheme() ? AppThemeData.primary300 : AppThemeData.primary300,
                buttonTextColor: AppThemeData.grey50,
                onTap: () {
                  if (controller.formKey.currentState!.validate()) {
                    controller.updateProfile();
                  }
                },
                size: Size(358.w, ScreenSize.height(6, context)),
              ),
            ),
          );
        });
  }
}

Future buildBottomSheet(BuildContext context, EditProfileScreenController controller, DarkThemeProvider themeChange) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: ScreenSize.height(22, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: paddingEdgeInsets(),
                  child: TextCustom(
                    title: "Please Select".tr,
                    fontSize: 18,
                    fontFamily: FontFamily.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: paddingEdgeInsets(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => controller.pickFile(source: ImageSource.camera),
                              icon: Icon(
                                Icons.camera_alt,
                                size: 32,
                                color: AppThemeData.primary300,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: TextCustom(
                              title: "Camera".tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceW(width: 36),
                    Padding(
                      padding: paddingEdgeInsets(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => controller.pickFile(source: ImageSource.gallery),
                              icon: Icon(
                                Icons.photo,
                                size: 32,
                                color: AppThemeData.primary300,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: TextCustom(
                              title: "Gallery".tr,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
