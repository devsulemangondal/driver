// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:driver/app/modules/about_screen/views/about_screen_view.dart';
import 'package:driver/app/modules/earning/views/earning_view.dart';
import 'package:driver/app/modules/edit_profile_screen/views/edit_profile_screen_view.dart';
import 'package:driver/app/modules/home_screen/controllers/home_screen_controller.dart';
import 'package:driver/app/modules/landing_screen/views/landing_screen_view.dart';
import 'package:driver/app/modules/language_screen/views/language_screen_view.dart';
import 'package:driver/app/modules/my_bank/views/my_bank_view.dart';
import 'package:driver/app/modules/my_documents/views/my_documents_view.dart';
import 'package:driver/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:driver/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:driver/app/modules/orders_screen/views/orders_screen_view.dart';
import 'package:driver/app/modules/referral_screen/views/referral_screen_view.dart';
import 'package:driver/app/modules/review_screen/views/review_screen_view.dart';
import 'package:driver/app/modules/statement_screen/views/statement_view.dart';
import 'package:driver/app/routes/app_pages.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/constant_widget/custom_dialog_box.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/dark_theme_provider.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: HomeScreenController(),
        builder: (controller) {
          return Drawer(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: AppThemeData.primary300,
                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 20, left: 16, right: 16),
                          child: InkWell(
                            onTap: () async {
                              Get.back();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(
                                  title: "My Profile".tr,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: FontFamily.bold,
                                  color: AppThemeData.grey50,
                                ),
                                spaceH(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: NetworkImageWidget(
                                        imageUrl: "${Constant.driverUserModel!.profileImage}",
                                        height: 62.h,
                                        width: 62.h,
                                        borderRadius: 200.r,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextCustom(
                                            title: Constant.driverUserModel!.firstName.toString(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: AppThemeData.grey50,
                                            fontFamily: FontFamily.bold,
                                          ),
                                          TextCustom(
                                            title: '${Constant.driverUserModel!.countryCode.toString()} ${Constant.driverUserModel!.phoneNumber.toString()}',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppThemeData.primaryWhite,
                                            fontFamily: FontFamily.light,
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Get.to(() => EditProfileScreenView());
                                      },
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_edit.svg",
                                        height: 32.h,
                                        width: 32.w,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextCustom(
                            title: "Services".tr,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => OrdersScreenView());
                                  },
                                  child: ContainerCustomSub(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/ic_calender.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                        ),
                                        spaceW(width: 8.w),
                                        TextCustom(
                                          title: "Orders".tr,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              spaceW(width: 14),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => MyWalletView());
                                  },
                                  child: ContainerCustomSub(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/ic_wallet.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                        ),
                                        spaceW(width: 8.w),
                                        Expanded(
                                          child: TextCustom(
                                            title: "My Wallet".tr,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        spaceH(height: 16),
                        if (Constant.driverUserModel!.isVerified == true)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => EarningView());
                                    },
                                    child: ContainerCustomSub(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/ic_doller.svg",
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                          ),
                                          spaceW(width: 8.w),
                                          TextCustom(
                                            title: "Earnings".tr,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                spaceW(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => ReviewScreenView());
                                    },
                                    child: ContainerCustomSub(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/ic_star.svg",
                                            height: 22,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                          ),
                                          spaceW(width: 8.w),
                                          TextCustom(
                                            title: "Reviews".tr,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        spaceH(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => MyBankView());
                                  },
                                  child: ContainerCustomSub(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/ic_bank.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                        ),
                                        spaceW(width: 8.w),
                                        TextCustom(
                                          title: "My Bank".tr,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              spaceW(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => NotificationScreenView());
                                  },
                                  child: ContainerCustomSub(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/ic_notification.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                        ),
                                        spaceW(width: 8),
                                        Expanded(
                                          child: TextCustom(
                                            title: "Notifications".tr,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ReferralScreenView());
                                  },
                                  child: ContainerCustomSub(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/ic_refer.svg",
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                        ),
                                        spaceW(width: 8.w),
                                        TextCustom(
                                          title: "Refer & Earn".tr,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              spaceW(width: 10),
                              Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              if (Constant.isDriverDocumentVerification == true)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => MyDocumentsView());
                                    },
                                    child: ContainerCustomSub(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/ic_document.svg",
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                                          ),
                                          spaceW(width: 8),
                                          Expanded(
                                            child: TextCustom(
                                              title: "Documents".tr,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              spaceW(width: 10),
                              Expanded(child: SizedBox())
                            ],
                          ),
                        ),
                        spaceH(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextCustom(
                            title: "About".tr,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                        if (Constant.driverUserModel!.isVerified == true)
                          ListTile(
                            leading: Container(
                              height: 46.h,
                              width: 46.w,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100),
                              child: SvgPicture.asset(
                                "assets/icons/ic_downlod.svg".tr,
                                height: 17.h,
                                width: 17.w,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                              ),
                            ),
                            trailing: const Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                            title: TextCustom(
                              textAlign: TextAlign.start,
                              title: "Order Statement".tr,
                              color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            onTap: () {
                              // Get.to(AboutScreenView());
                              Get.to(() => StatementView());
                            },
                          ),
                        ListTile(
                          leading: Container(
                            height: 46.h,
                            width: 46.w,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100),
                            child: SvgPicture.asset(
                              "assets/icons/ic_privacy_policy.svg".tr,
                              height: 17.h,
                              width: 17.w,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                            ),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                          title: TextCustom(
                            textAlign: TextAlign.start,
                            title: "Privacy & Policy".tr,
                            color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            // Get.to(AboutScreenView());
                            Get.to(() => AboutScreenView(title: "Privacy & Policy".tr, htmlData: Constant.privacyPolicy));
                          },
                        ),
                        ListTile(
                          leading: Container(
                            height: 46.h,
                            width: 46.w,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100),
                            child: SvgPicture.asset(
                              "assets/icons/ic_support.svg".tr,
                              height: 17.h,
                              width: 17.w,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                            ),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                          title: TextCustom(
                            textAlign: TextAlign.start,
                            title: "Terms & Condition".tr,
                            color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            Get.to(() => AboutScreenView(title: "Terms & Condition".tr, htmlData: Constant.termsAndConditions));
                          },
                        ),
                        ListTile(
                          leading: Container(
                            height: 46.h,
                            width: 46.w,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100),
                            child: SvgPicture.asset(
                              "assets/icons/ic_about_app.svg".tr,
                              height: 17.h,
                              width: 17.w,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                            ),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                          title: TextCustom(
                            textAlign: TextAlign.start,
                            title: "AboutApp".tr,
                            color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            Get.to(() => AboutScreenView(title: "AboutApp".tr, htmlData: Constant.aboutApp));
                          },
                        ),
                        spaceH(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextCustom(
                            title: "App Settings".tr,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: FontFamily.medium,
                          ),
                        ),
                        ListTile(
                          leading: Container(
                            height: 46.h,
                            width: 46.w,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100),
                            child: SvgPicture.asset(
                              "assets/icons/ic_world .svg".tr,
                              height: 20.h,
                              width: 20.w,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                            ),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_right_rounded, size: 30),
                          title: TextCustom(
                            textAlign: TextAlign.start,
                            title: "Language".tr,
                            color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            Get.to(() => LanguageScreenView());
                          },
                        ),
                        ListTile(
                            leading: Container(
                              height: 46.h,
                              width: 46.w,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100),
                              child: SvgPicture.asset(
                                "assets/icons/ic_dark.svg".tr,
                                height: 17.h,
                                width: 17.w,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey800,
                              ),
                            ),
                            trailing: Switch(
                              value: themeChange.isDarkTheme() ? false : true,
                              activeColor: AppThemeData.white,
                              activeTrackColor: AppThemeData.success300,
                              onChanged: (value) {
                                themeChange.darkTheme = value ? 1 : 0;
                              },
                            ),
                            title: TextCustom(
                              textAlign: TextAlign.start,
                              title: "Dark Mode".tr,
                              color: themeChange.isDarkTheme() ? AppThemeData.white : AppThemeData.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        ListTile(
                            onTap: () {
                              Get.back();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialogBox(
                                        themeChange: themeChange,
                                        title: "Delete Account".tr,
                                        descriptions: "Your account will be deleted permanently. Your Data will not be Restored Again.".tr,
                                        positiveString: "Delete".tr,
                                        negativeString: "Cancel".tr,
                                        positiveClick: () async {
                                          controller.deleteUserAccount().then((value) async {
                                            Navigator.pop(context);
                                            await FirebaseAuth.instance.signOut();
                                            Get.offAllNamed(Routes.LANDING_SCREEN);
                                            ShowToastDialog.showToast("Account Deleted Successfully..".tr);
                                          });
                                        },
                                        positiveButtonTextColor: AppThemeData.primaryWhite,
                                        negativeButtonBorderColor: AppThemeData.grey400,
                                        negativeButtonColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
                                        negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                        negativeClick: () {
                                          Navigator.pop(context);
                                        },
                                        img: Image.asset(
                                          'assets/animation/logout.gif',
                                          height: 64.h,
                                          width: 64.w,
                                        ));
                                  });
                            },
                            leading: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppThemeData.danger300,
                            ),
                            title: TextCustom(
                              title: "Delete Account".tr,
                              textAlign: TextAlign.start,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppThemeData.danger300,
                              fontFamily: FontFamily.medium,
                            )),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                      onTap: () {
                        Get.back();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                  themeChange: themeChange,
                                  title: "Logout".tr,
                                  descriptions: "Logging out will require you to sign in again to access your account.".tr,
                                  positiveString: "Log out".tr,
                                  negativeString: "Cancel".tr,
                                  positiveClick: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pop(context);
                                    Constant.driverUserModel!.fcmToken = "";
                                    await FireStoreUtils.updateDriverUser(Constant.driverUserModel!);

                                    Get.offAll(() => LandingScreenView());
                                  },
                                  positiveButtonTextColor: AppThemeData.primaryWhite,
                                  negativeButtonBorderColor: AppThemeData.grey400,
                                  negativeButtonColor: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.grey50,
                                  negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                  negativeClick: () {
                                    Navigator.pop(context);
                                  },
                                  img: Image.asset(
                                    'assets/animation/logout.gif',
                                    height: 64.h,
                                    width: 64.w,
                                  ));
                            });
                      },
                      leading: const Icon(
                        Icons.logout,
                        color: AppThemeData.danger300,
                      ),
                      title: TextCustom(
                        title: "Logout".tr,
                        textAlign: TextAlign.start,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppThemeData.danger300,
                        fontFamily: FontFamily.medium,
                      )),
                ),
              ],
            ),
          );
        });
  }
}
