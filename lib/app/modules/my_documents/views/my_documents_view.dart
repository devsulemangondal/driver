// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:driver/app/models/document_model.dart';
import 'package:driver/app/modules/my_documents/controllers/my_documents_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/network_image_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/container_custom.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class MyDocumentsView extends GetView<MyDocumentController> {
  const MyDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: MyDocumentController(),
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
            child: Obx(
              () => Padding(
                  padding: paddingEdgeInsets(),
                  child: controller.isLoading.value
                      ? Constant.loader()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spaceH(height: 24.h),
                            TextCustom(
                              title: "My Documents".tr,
                              fontSize: 28,
                              maxLine: 2,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                              fontFamily: FontFamily.bold,
                              textAlign: TextAlign.start,
                            ),
                            2.height,
                            TextCustom(
                              title: "View and manage your linked bank accounts for withdrawals and transactions.".tr,
                              fontSize: 16,
                              maxLine: 2,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                              fontFamily: FontFamily.regular,
                              textAlign: TextAlign.start,
                            ),
                            spaceH(height: 32.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextCustom(
                                  title: "Documents".tr,
                                  fontSize: 16,
                                  fontFamily: FontFamily.regular,
                                  color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                ),
                              ],
                            ),
                            spaceH(height: 8.h),
                            ContainerCustomSub(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.verifyDocumentList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: paddingEdgeInsets(vertical: 4, horizontal: 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 44.h,
                                          width: 44.w,
                                          padding: paddingEdgeInsets(horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: AppThemeData.grey300)),
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_idproof.svg",
                                            width: 24.w,
                                            height: 24.h,
                                          ),
                                        ),
                                        spaceW(),
                                        FutureBuilder<DocumentModel?>(
                                          future: FireStoreUtils.getDocument(controller.verifyDocumentList[index].documentId.toString()),
                                          builder: (context, AsyncSnapshot<DocumentModel?> snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            }
                                            DocumentModel documentModel = snapshot.data!;
                                            return TextCustom(
                                              title: documentModel.name.toString(),
                                              fontSize: 16,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            );
                                          },
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  backgroundColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                          height: 180.h,
                                                          width: double.infinity,
                                                          child: NetworkImageWidget(
                                                            borderRadius: 12,
                                                            progressIndicator: Center(
                                                              child: Constant.loader(),
                                                            ),
                                                            imageUrl: controller.verifyDocumentList[index].documentImage![0].toString().trim(),
                                                            isProfile: false,
                                                          )),
                                                      if (controller.verifyDocumentList[index].isTwoSide == true)
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: SizedBox(
                                                              height: 180.h,
                                                              width: double.infinity,
                                                              child: NetworkImageWidget(
                                                                borderRadius: 12,
                                                                progressIndicator: Center(
                                                                  child: Constant.loader(),
                                                                ),
                                                                imageUrl: controller.verifyDocumentList[index].documentImage![1].toString().trim(),
                                                                isProfile: false,
                                                              )),
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 38.h,
                                            width: 38.w,
                                            padding: paddingEdgeInsets(horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.secondary600 : AppThemeData.secondary50, shape: BoxShape.circle),
                                            child: SvgPicture.asset(
                                              "assets/icons/ic_eye.svg",
                                              color: AppThemeData.secondary300,
                                            ),
                                          ),
                                        ),
                                        spaceW(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
            ),
          ),
        );
      },
    );
  }
}
