import 'package:driver/app/modules/referral_screen/controllers/referral_screen_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/common_ui.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreenView extends GetView<ReferralScreenController> {
  const ReferralScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: ReferralScreenController(),
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
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 14),
                    child: Column(
                      children: [
                        controller.referralModel.value.referralCode == null
                            ? Expanded(
                                child: Column(
                                children: [
                                  TextCustom(
                                    title: "Create Your Referral Code".tr,
                                    fontSize: 28,
                                    maxLine: 2,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                                    fontFamily: FontFamily.bold,
                                    textAlign: TextAlign.start,
                                  ),
                                  spaceH(height: 2),
                                  TextCustom(
                                    title: "You haven't created a referral code yet. Generate your code now and start inviting friends to earn rewards!".tr,
                                    fontSize: 16,
                                    maxLine: 3,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                    fontFamily: FontFamily.regular,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  RoundShapeButton(
                                      title: "Create Refer Code".tr,
                                      buttonColor: AppThemeData.primary300,
                                      buttonTextColor: AppThemeData.primaryWhite,
                                      onTap: () async {
                                        controller.createReferEarnCode();
                                      },
                                      size: Size(210, 48)),
                                ],
                              ))
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Refer others & earn credits".tr,
                                        fontSize: 28,
                                        maxLine: 2,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                                        fontFamily: FontFamily.bold,
                                        textAlign: TextAlign.start,
                                      ),
                                      spaceH(height: 2),
                                      TextCustom(
                                        title: "Invite friends to use our app and earn exclusive rewards for every successful referral. Share the benefits today!".tr,
                                        fontSize: 16,
                                        maxLine: 3,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                        fontFamily: FontFamily.regular,
                                        textAlign: TextAlign.start,
                                      ),
                                      spaceH(height: 32),
                                      Center(
                                          child: Image.asset(
                                        "assets/icons/gif_refer.gif",
                                        height: 150,
                                        width: 200,
                                      )),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: RoundShapeButton(
                                            title: "${controller.referralModel.value.referralCode}",
                                            buttonColor: AppThemeData.primary300,
                                            buttonTextColor: AppThemeData.primaryWhite,
                                            onTap: () {},
                                            size: Size(0, 45),
                                          )),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: RoundShapeButton(
                                                title: "Tap To Copy".tr,
                                                buttonColor: AppThemeData.warning03,
                                                buttonTextColor: AppThemeData.primaryBlack,
                                                onTap: () async {
                                                  await Clipboard.setData(ClipboardData(text: "${controller.referralModel.value.referralCode}")).then(
                                                    (value) => ShowToastDialog.showToast("Copied".tr),
                                                  );
                                                },
                                                size: Size(0, 45)),
                                          ),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Text(
                                        "How it Works".tr,
                                        style: TextStyle(fontFamily: FontFamily.regular, color: AppThemeData.grey500, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      commanWidget(
                                          themeChange: themeChange,
                                          title: "Refer Friends",
                                          description: "Share your unique referral code with friends and family to invite them to book rides in the app.",
                                          imageAsset: "assets/icons/ic_mail_send.png"),
                                      commanWidget(
                                          themeChange: themeChange,
                                          title: "Earn Credits",
                                          description: "Get app credits for every friend who signs up with your code. Use these credits for your future rides.",
                                          imageAsset: "assets/icons/ic_gift.png"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        controller.referralModel.value.referralCode != null
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(24, 10, 24, MediaQuery.of(context).padding.bottom),
                                child: RoundShapeButton(
                                    title: "Refer Now".tr,
                                    buttonColor: AppThemeData.primary300,
                                    buttonTextColor: AppThemeData.primaryWhite,
                                    onTap: () async {
                                      await SharePlus.instance.share(ShareParams(
                                          text:
                                              'Go4Food \n\n🚴‍♂️ Earn smarter with Go4Food! \n\nUse my referral code ${controller.referralModel.value.referralCode} when you sign up as a driver and start earning with every delivery. Join now!'
                                                  .tr));
                                    },
                                    size: Size(210, 48)),
                              )
                            : SizedBox()
                      ],
                    ),
                  ));
      },
    );
  }

  Padding commanWidget({required String imageAsset, required String title, required String description, themeChange}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppThemeData.primary100,
            child: Image.asset(
              imageAsset,
            ),
          ),
          // SvgPicture.asset(imageAsset),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.tr,
                  style: TextStyle(
                    fontFamily: FontFamily.bold,
                    fontSize: 16,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                  ),
                ),
                Text(
                  description.tr,
                  style: TextStyle(
                    fontFamily: FontFamily.regular,
                    fontSize: 12,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
