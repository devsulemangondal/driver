// ignore_for_file: use_super_parameters

import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/account_disabled_screen.dart';
import 'package:driver/app/modules/home_screen/views/home_screen_view.dart';
import 'package:driver/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:driver/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:driver/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../themes/screen_size.dart';

class VerifyOtpView extends GetView<LoginScreenController> {
  VerifyOtpView({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
            ),
          ),
        ),
      ),
      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: paddingEdgeInsets(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTopWidget(context),
                buildEmailPasswordWidget(context),
                34.height,
                Obx(
                  () => controller.enableResend.value
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.sendCode();
                            },
                            child: Text(
                              "Resend OTP".tr,
                              style: TextStyle(
                                  fontSize: 16, color: AppThemeData.primary300, fontFamily: FontFamily.regular, decoration: TextDecoration.underline, decorationColor: AppThemeData.primary300),
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            text: "Didn’t received it? Retry in ".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "00:${controller.secondsRemaining.value.toString().padLeft(2, '0')} sec".tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppThemeData.accent300,
                                  fontFamily: FontFamily.regular,
                                ),
                              ),
                            ],
                          ),
                        ).center(),
                ),
                spaceH(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => RoundShapeButton(
                          title: "Verify OTP".tr,
                          buttonColor: controller.isVerifyButtonEnabled.value
                              ? AppThemeData.primary300
                              : themeChange.isDarkTheme()
                                  ? AppThemeData.grey800
                                  : AppThemeData.grey200,
                          buttonTextColor: controller.isVerifyButtonEnabled.value
                              ? themeChange.isDarkTheme()
                                  ? AppThemeData.grey1000
                                  : AppThemeData.grey50
                              : AppThemeData.grey500,
                          onTap: () async {
                            if (controller.otpCode.value.length == 6) {
                              ShowToastDialog.showLoader("Verify OTP".tr);
                              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: controller.verificationId.value, smsCode: controller.otpCode.value);
                              String fcmToken = await NotificationService.getToken();
                              await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                if (value.additionalUserInfo!.isNewUser) {
                                  DriverUserModel driverModel = DriverUserModel();
                                  driverModel.driverId = value.user?.uid;
                                  driverModel.countryCode = controller.countryCode.value;
                                  driverModel.phoneNumber = controller.mobileNumberController.value.text;
                                  driverModel.loginType = Constant.phoneLoginType;
                                  driverModel.fcmToken = fcmToken;
                                  driverModel.status = '';
                                  driverModel.isOnline = false;
                                  ShowToastDialog.closeLoader();
                                  Get.offAll(() => SignupScreenView(), arguments: {
                                    "driverModel": driverModel,
                                  });
                                } else {
                                  await FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
                                    ShowToastDialog.closeLoader();
                                    if (userExit == true) {
                                      DriverUserModel? driverModel = await FireStoreUtils.getDriverProfile(value.user!.uid);
                                      if (driverModel != null) {
                                        driverModel.fcmToken = fcmToken;
                                        await FireStoreUtils.updateDriverUser(driverModel);
                                        if (driverModel.active == true) {
                                          Preferences.setBoolean(Preferences.isFinishOnBoardingKey, true);
                                          Get.offAll(() => HomeScreenView());
                                        } else {
                                          Get.offAll(() => AccountDisabledScreen());
                                          // await FirebaseAuth.instance.signOut();
                                          // ShowToastDialog.showToast("Contact Administrator".tr);
                                        }
                                      }
                                    } else {
                                      DriverUserModel driverModel = DriverUserModel();
                                      driverModel.driverId = value.user!.uid;
                                      driverModel.countryCode = controller.countryCode.value;
                                      driverModel.phoneNumber = controller.mobileNumberController.value.text;
                                      driverModel.loginType = Constant.phoneLoginType;
                                      driverModel.fcmToken = fcmToken;

                                      Get.off(() => SignupScreenView(), arguments: {
                                        "driverModel": driverModel,
                                      });
                                    }
                                  });
                                }
                              }).catchError((error) {
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.showToast("Invalid code".tr);
                              });
                            } else {
                              ShowToastDialog.showToast("Enter valid otp".tr);
                            }
                          },
                          size: Size(358.w, ScreenSize.height(6, context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildTopWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Your Mobile Number".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 24,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
              )),
          RichText(
            text: TextSpan(
              text:
                  "${"Please enter the Verification code, we sent to".tr} \n${Constant.maskMobileNumber(countryCode: controller.countryCode.value, mobileNumber: controller.mobileNumberController.value.text)} ",
              style: TextStyle(
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: "Change Number".tr,
                  style: TextStyle(fontSize: 16, color: AppThemeData.primary300, fontFamily: FontFamily.regular, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                ),
              ],
            ),
          ),
          24.height
        ],
      ),
    );
  }

  OtpTextField buildEmailPasswordWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return OtpTextField(
      numberOfFields: 6,
      filled: true,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      cursorColor: AppThemeData.primary300,
      borderRadius: BorderRadius.circular(10),
      borderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
      enabledBorderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
      disabledBorderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
      fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
      focusedBorderColor: AppThemeData.primary300,
      showFieldAsBox: true,
      onSubmit: (value) {
        controller.otpCode.value = value;
        controller.isVerifyButtonEnabled.value = true;
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }
}
