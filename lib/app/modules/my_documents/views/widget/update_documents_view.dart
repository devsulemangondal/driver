// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:driver/app/models/verify_document_model.dart';
import 'package:driver/app/modules/my_documents/controllers/my_documents_controller.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../../themes/screen_size.dart';

class UpdateDocumentsView extends GetView<MyDocumentController> {
  const UpdateDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: MyDocumentController(),
      builder: (controller) {
        bool areImagesUploaded = controller.verifyDocumentList.every((doc) => doc.documentImage!.isNotEmpty);
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
                  Get.back();
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
                          TextCustom(
                            title: "Upload Documents".tr,
                            fontSize: 28,
                            maxLine: 2,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                            fontFamily: FontFamily.bold,
                            textAlign: TextAlign.start,
                          ),
                          2.height,
                          TextCustom(
                            title: "Please upload a clear and legible photo of your Aadhaar card.".tr,
                            fontSize: 16,
                            maxLine: 2,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            fontFamily: FontFamily.regular,
                            textAlign: TextAlign.start,
                          ),
                          spaceH(height: 32),
                          Obx(
                            () => ListView.builder(
                              itemCount: controller.verifyDocumentList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                VerifyDocumentModel documentModel = controller.verifyDocumentList[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    spaceH(height: 14.h),
                                    TextCustom(
                                      title: "${controller.documentsList[index].name}".tr,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                      fontFamily: FontFamily.medium,
                                    ),
                                    spaceH(height: 8),
                                    InkWell(
                                      onTap: () {
                                        controller.documentPickFile(source: ImageSource.gallery, verifyDocumentModel: documentModel, index: index, imageIndex: 0);
                                      },
                                      child: DottedBorder(
                                        options: RectDottedBorderOptions(
                                          dashPattern: const [6, 6, 6, 6],
                                          strokeWidth: 2,
                                          padding: EdgeInsets.all(16),
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                        ),
                                        child: documentModel.documentImage != null && documentModel.documentImage!.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: Constant.hasValidUrl(documentModel.documentImage![0].toString())
                                                    ? Image.network(
                                                        documentModel.documentImage![0].toString(),
                                                        height: 174.h,
                                                        width: 358.w,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(documentModel.documentImage![0].toString()),
                                                        height: 174.h,
                                                        width: 358.w,
                                                        fit: BoxFit.cover,
                                                      ),
                                              )
                                            : Container(
                                                height: 174.h,
                                                width: 358.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                                                ),
                                                child: Padding(
                                                  padding: paddingEdgeInsets(),
                                                  child: Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 18,
                                                          width: 18,
                                                          child: SvgPicture.asset(
                                                            "assets/icons/ic_upload.svg",
                                                            color: AppThemeData.primary300,
                                                          ),
                                                        ),
                                                        spaceH(height: 16),
                                                        TextCustom(
                                                          title: "Upload Document".tr,
                                                          maxLine: 2,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                          fontFamily: FontFamily.regular,
                                                        ),
                                                        TextCustom(
                                                          title: "image must be a .jpg, .jpeg".tr,
                                                          maxLine: 1,
                                                          fontSize: 12,
                                                          color: AppThemeData.secondary300,
                                                          fontFamily: FontFamily.light,
                                                        ),
                                                        spaceH(),
                                                        RoundShapeButton(
                                                          titleWidget: TextCustom(
                                                            title: "Browse Image".tr,
                                                            fontSize: 14,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                          ),
                                                          title: "",
                                                          buttonColor: AppThemeData.primary300,
                                                          buttonTextColor: AppThemeData.primaryWhite,
                                                          onTap: () {
                                                            controller.documentPickFile(source: ImageSource.gallery, verifyDocumentModel: documentModel, index: index, imageIndex: 0);
                                                          },
                                                          size: Size(140.w, 42.h),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                    if (documentModel.isTwoSide == true)
                                      InkWell(
                                        onTap: () {
                                          controller.documentPickFile(source: ImageSource.gallery, verifyDocumentModel: documentModel, index: index, imageIndex: 1);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 12.h),
                                          child: DottedBorder(
                                              options: RectDottedBorderOptions(
                                                dashPattern: const [6, 6, 6, 6],
                                                strokeWidth: 2,
                                                padding: EdgeInsets.all(16),
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                              ),
                                              child: documentModel.documentImage != null && documentModel.documentImage!.length > 1
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Constant.hasValidUrl(documentModel.documentImage![1].toString())
                                                          ? Image.network(
                                                              documentModel.documentImage![1].toString(),
                                                              height: 174.h,
                                                              width: 358.w,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(documentModel.documentImage![1].toString()),
                                                              height: 174.h,
                                                              width: 358.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    )
                                                  : Container(
                                                      height: 174.h,
                                                      width: 358.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                        color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                                                      ),
                                                      child: Padding(
                                                        padding: paddingEdgeInsets(),
                                                        child: Center(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                height: 18,
                                                                width: 18,
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_upload.svg",
                                                                  color: AppThemeData.primary300,
                                                                ),
                                                              ),
                                                              spaceH(height: 16),
                                                              TextCustom(
                                                                title: "Upload Document".tr,
                                                                maxLine: 2,
                                                                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                                fontFamily: FontFamily.regular,
                                                              ),
                                                              TextCustom(
                                                                title: "image must be a .jpg, .jpeg".tr,
                                                                maxLine: 1,
                                                                fontSize: 12,
                                                                color: AppThemeData.secondary300,
                                                                fontFamily: FontFamily.light,
                                                              ),
                                                              spaceH(),
                                                              RoundShapeButton(
                                                                titleWidget: TextCustom(
                                                                  title: "Browse Image".tr,
                                                                  fontSize: 14,
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                                ),
                                                                title: "",
                                                                buttonColor: AppThemeData.primary300,
                                                                buttonTextColor: AppThemeData.primaryWhite,
                                                                onTap: () {
                                                                  controller.documentPickFile(source: ImageSource.gallery, verifyDocumentModel: documentModel, index: index, imageIndex: 1);
                                                                },
                                                                size: Size(140.w, 42.h),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: SizedBox(
              height: 100.h,
              child: Column(
                children: [
                  if (areImagesUploaded == true)
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_true.svg',
                          height: 17.h,
                          width: 17.w,
                        ),
                        spaceW(width: 4.w),
                        TextCustom(
                          title: "Sent to verification".tr,
                          color: AppThemeData.secondary300,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  const Spacer(),
                  RoundShapeButton(
                    title: "Save".tr,
                    buttonColor: areImagesUploaded
                        ? AppThemeData.primary300
                        : themeChange.isDarkTheme()
                            ? AppThemeData.grey800
                            : AppThemeData.grey200,
                    buttonTextColor: areImagesUploaded ? AppThemeData.grey50 : AppThemeData.grey500,
                    onTap: () async {
                      controller.saveDocuments();
                    },
                    size: Size(358.w, ScreenSize.height(6, context)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
