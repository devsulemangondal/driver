// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:driver/app/models/document_model.dart';
import 'package:driver/app/models/verify_document_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyDocumentController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxBool isLoading = false.obs;
  Rx<bool> restaurantDetailButton = false.obs;

  Rx<String> coverImage = "".obs;
  final ImagePicker imagePicker = ImagePicker();

  RxList<DocumentModel> documentsList = <DocumentModel>[].obs;
  Rx<VerifyDriverModel> verifyDriverModel = VerifyDriverModel().obs;

  RxList<VerifyDocumentModel> verifyDocumentList = <VerifyDocumentModel>[].obs;
  final ImagePicker documentImagePicker = ImagePicker();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;

    try {
      final value = await FireStoreUtils.getDocumentsList();

      if (value != null) {
        documentsList.value = value;

        for (var element in documentsList) {
          VerifyDocumentModel documentModel = VerifyDocumentModel(
            documentId: element.id,
            documentImage: [],
            isVerify: false,
            isTwoSide: element.isTwoSide,
          );
          verifyDocumentList.add(documentModel);
        }
      }

      final documents = await FireStoreUtils.getDocuments();
      if (documents != null && documents.verifyDocument != null) {
        verifyDriverModel.value = documents;
        verifyDocumentList.value = documents.verifyDocument!;
      }
    } catch (e,stack) {
      developer.log("Error in getData", error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> documentPickFile({
    required ImageSource source,
    required VerifyDocumentModel verifyDocumentModel,
    required int index,
    required int imageIndex,
  }) async {
    try {
      XFile? image = await documentImagePicker.pickImage(source: source, imageQuality: 60);
      if (image == null) return;

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );

      if (compressedBytes == null) {
        ShowToastDialog.showToast("Image compression failed.".tr);
        return;
      }

      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes);


      if (verifyDocumentModel.documentImage != null && verifyDocumentModel.documentImage!.length > imageIndex) {
        verifyDocumentModel.documentImage![imageIndex] = compressedFile.path;
      } else {
        verifyDocumentModel.documentImage ??= [];
        verifyDocumentModel.documentImage!.add(compressedFile.path);
      }

      verifyDocumentList[index] = verifyDocumentModel;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to pick".tr}:\n$e");
    } catch (e,stack) {
      developer.log("Error in documentPickFile", error: e, stackTrace: stack);
    }
  }

  Future<void> saveDocuments() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      if (verifyDocumentList.isNotEmpty) {
        for (var document in verifyDocumentList) {
          for (int i = 0; i < document.documentImage!.length; i++) {
            String imagePath = document.documentImage![i].toString();

            if (imagePath.isNotEmpty && !Constant.hasValidUrl(imagePath)) {
              try {
                String imageUrl = await Constant.uploadUserImageToFireStorage(
                  File(imagePath),
                  "driver_documents/${document.documentId}/${FireStoreUtils.getCurrentUid()}",
                  imagePath.split('/').last,
                );
                document.documentImage![i] = imageUrl;
              } catch (e) {
                ShowToastDialog.showToast("${"Failed to upload image:".tr} $e");
              }
            }
          }
        }
        verifyDocumentList.refresh();
      }

      VerifyDriverModel verifyDriver = VerifyDriverModel(
        createAt: verifyDriverModel.value.createAt,
        driverEmail: verifyDriverModel.value.driverEmail,
        driverId: verifyDriverModel.value.driverId,
        driverName: verifyDriverModel.value.driverName,
        verifyDocument: verifyDocumentList,
      );

      await FireStoreUtils.updateVerifyDriver(verifyDriver);
      ShowToastDialog.closeLoader();
    } catch (e, stack) {
      developer.log("Error in saveDocuments", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("${"Something went wrong:".tr} $e");
    }
  }
}
