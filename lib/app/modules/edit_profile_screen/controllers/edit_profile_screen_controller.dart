import 'dart:developer' as developer;
import 'dart:io';

// ignore: unused_import
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/home_screen/views/home_screen_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreenController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<String?> countryCode = "+91".obs;
  Rx<bool> isLoading = false.obs;
  RxString profileImage = "".obs;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      firstNameController.value.text = Constant.driverUserModel?.firstName?.toString() ?? '';
      lastNameController.value.text = Constant.driverUserModel?.lastName?.toString() ?? '';
      emailController.value.text = Constant.driverUserModel?.email?.toString() ?? '';
      mobileNumberController.value.text = Constant.driverUserModel?.phoneNumber?.toString() ?? '';
      profileImage.value = Constant.driverUserModel?.profileImage?.toString() ?? '';
    } catch (e, stack) {
      developer.log("Error in getData", error: e, stackTrace: stack);
    }
  }

  Future<void> updateProfile() async {
    ShowToastDialog.showLoader("Please Wait..".tr);

    try {
      // Upload image if it's a local file
      if (profileImage.value.isNotEmpty && !Constant.hasValidUrl(profileImage.value)) {
        profileImage.value = await Constant.uploadUserImageToFireStorage(
          File(profileImage.value),
          "profileImage/${FireStoreUtils.getCurrentUid()}",
          File(profileImage.value).path.split('/').last,
        );
      }

      // Update driver model
      Constant.driverUserModel!
        ..profileImage = profileImage.value
        ..firstName = firstNameController.value.text
        ..lastName = lastNameController.value.text
        ..email = emailController.value.text
        ..phoneNumber = mobileNumberController.value.text
        ..searchNameKeywords = Constant.generateKeywords(Constant.driverUserModel!.fullNameString())
        ..searchEmailKeywords = Constant.generateKeywords(emailController.value.text);

      // Update Firestore and reset form
      await FireStoreUtils.updateDriverUser(Constant.driverUserModel!);

      // Optional: Refresh the model in memory (if needed for UI consistency)
      await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid());

      // Clear form fields
      firstNameController.value.clear();
      lastNameController.value.clear();
      emailController.value.clear();
      mobileNumberController.value.clear();

      ShowToastDialog.showToast("Save Successfully".tr);
      Get.offAll(() => HomeScreenView());
    } catch (e, stack) {
      developer.log("Error in updateProfile", error: e, stackTrace: stack);
      ShowToastDialog.showToast("Something went wrong. Please try again.".tr);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> pickFile({required ImageSource source}) async {
    isLoading.value = true;

    try {
      XFile? image = await imagePicker.pickImage(source: source, imageQuality: 100);
      if (image != null) {
        Get.back(); // Close bottom sheet or dialog

        Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
          image.path,
          quality: 25,
        );

        if (compressedBytes != null) {
          File compressedFile = File(image.path);
          await compressedFile.writeAsBytes(compressedBytes);
          profileImage.value = compressedFile.path; // Save local file path
        }
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${"Failed to pick".tr}:\n$e");
    } catch (e, stack) {
      developer.log("Error in pickFile", error: e, stackTrace: stack);
      ShowToastDialog.showToast("Something went wrong while picking the image.".tr);
    } finally {
      isLoading.value = false;
    }
  }
}
