// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/bank_details_model.dart';
import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/document_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/models/referral_model.dart';
import 'package:driver/app/models/verify_document_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/extension/string_extensions.dart';
import 'package:driver/services/email_template_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import '../../../../utils/notification_service.dart';
import '../views/widgets/account_created_successfully_view.dart';

class SignupScreenController extends GetxController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<String> editPage = "".obs;
  var currentStep = 0.obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> vehicleNameController = TextEditingController().obs;
  Rx<TextEditingController> vehicleNumberController = TextEditingController().obs;
  Rx<TextEditingController> bankHolderNameController = TextEditingController().obs;
  Rx<TextEditingController> bankAccountNumberController = TextEditingController().obs;
  Rx<TextEditingController> bankIfscCodeController = TextEditingController().obs;
  Rx<TextEditingController> bankNameController = TextEditingController().obs;
  Rx<TextEditingController> bankBranchCountryController = TextEditingController().obs;
  Rx<TextEditingController> bankBranchCityController = TextEditingController().obs;
  Rx<TextEditingController> swiftCodeController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> referralCodeController = TextEditingController().obs;

  RxList<String> pageList = <String>[
    "Enter Basic Details",
    "Upload Vehicle Details",
    "Upload Bank Details",
    "Upload Documents",
  ].obs;
  RxBool isFirstButtonEnabled = false.obs;
  RxBool isSecondButtonEnabled = false.obs;
  RxString loginType = "".obs;

  Rx<String?> countryCode = "+91".obs;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfPasswordVisible = true.obs;

  Rx<VehicleType> vehicleType = VehicleType.bike.obs;

  Rx<bool> restaurantDetailButton = false.obs;

  final ImagePicker imagePicker = ImagePicker();

  RxList<DocumentModel> documentsList = <DocumentModel>[].obs;

  RxList<VerifyDocumentModel> verifyDocumentList = <VerifyDocumentModel>[].obs;

  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;

  @override
  void onInit() {
    getArguments();
    super.onInit();
    firstNameController.value.addListener(() => checkFieldsFilled());
    lastNameController.value.addListener(() => checkFieldsFilled());
    mobileNumberController.value.addListener(() => checkFieldsFilled());
    emailController.value.addListener(() => checkFieldsFilled());
    passwordController.value.addListener(() => checkFieldsFilled());
    confirmPasswordController.value.addListener(() => checkFieldsFilled());

    bankHolderNameController.value.addListener(() => checkFieldsFilled());
    bankAccountNumberController.value.addListener(() => checkFieldsFilled());
    bankIfscCodeController.value.addListener(() => checkFieldsFilled());
    bankNameController.value.addListener(() => checkFieldsFilled());
    bankBranchCountryController.value.addListener(() => checkFieldsFilled());
    bankBranchCityController.value.addListener(() => checkFieldsFilled());
    swiftCodeController.value.addListener(() => checkFieldsFilled());
  }

  Future<void> getArguments() async {
    try {
      isLoading.value = true;
      dynamic argument = Get.arguments;

      if (argument != null) {
        if (argument['type'] != null) {
          loginType.value = argument['type'];
        } else if (argument['driverModel'] != null) {
          driverModel.value = await argument['driverModel'];
          loginType.value = driverModel.value.loginType!;
        }

        if (loginType.value == Constant.phoneLoginType) {
          mobileNumberController.value.text = driverModel.value.phoneNumber.toString();
          countryCode.value = driverModel.value.countryCode.toString();
        } else if (loginType.value == Constant.googleLoginType || loginType.value == Constant.appleLoginType) {
          emailController.value.text = driverModel.value.email.toString();
        }
      }

      final value = await FireStoreUtils.getDocumentsList();
      if (value != null) {
        documentsList.value = value;
        for (var element in documentsList) {
          VerifyDocumentModel documentModel = VerifyDocumentModel(
            documentId: element.id,
            documentImage: [],
            isVerify: Constant.isDriverDocumentVerification == false ? true : false,
            isTwoSide: element.isTwoSide,
          );
          verifyDocumentList.add(documentModel);
        }
      }
    } catch (e, stack) {
      developer.log("Error in getArguments", error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  void checkIfFieldsAreFilled() {
    try {
      if (vehicleNameController.value.text.isNotEmpty && vehicleNumberController.value.text.isNotEmpty) {
        restaurantDetailButton.value = true;
      } else {
        restaurantDetailButton.value = false;
      }
    } catch (e, stack) {
      developer.log("Error in checkIfFieldsAreFilled", error: e, stackTrace: stack);
      restaurantDetailButton.value = false;
    }
  }

  void checkFieldsFilled() {
    try {
      isFirstButtonEnabled.value = loginType.value == Constant.emailLoginType
          ? firstNameController.value.text.isNotEmpty &&
              lastNameController.value.text.isNotEmpty &&
              mobileNumberController.value.text.isNotEmpty &&
              emailController.value.text.isNotEmpty &&
              passwordController.value.text.isNotEmpty &&
              confirmPasswordController.value.text.isNotEmpty
          : firstNameController.value.text.isNotEmpty && lastNameController.value.text.isNotEmpty && mobileNumberController.value.text.isNotEmpty && emailController.value.text.isNotEmpty;

      isSecondButtonEnabled.value = bankHolderNameController.value.text.isNotEmpty &&
          bankAccountNumberController.value.text.isNotEmpty &&
          bankIfscCodeController.value.text.isNotEmpty &&
          bankNameController.value.text.isNotEmpty &&
          bankBranchCountryController.value.text.isNotEmpty &&
          bankBranchCityController.value.text.isNotEmpty &&
          swiftCodeController.value.text.isNotEmpty;
    } catch (e, stack) {
      developer.log("Error in checkFieldsFilled", error: e, stackTrace: stack);
      isFirstButtonEnabled.value = false;
      isSecondButtonEnabled.value = false;
    }
  }

  Future<void> nextStep() async {
    try {
      if (currentStep.value == 2 && Constant.isDriverDocumentVerification == false) {
        if (loginType.value == Constant.emailLoginType) {
          await signUp();
        } else {
          await saveData();
        }
      } else if (currentStep.value < pageList.length - 1) {
        currentStep.value++;
      }
    } catch (e, stack) {
      developer.log("Error in nextStep", error: e, stackTrace: stack);
    }
  }

  void previousStep() {
    try {
      if (currentStep.value > 0) {
        currentStep.value--;
      }
    } catch (e, stack) {
      developer.log("Error in previousStep", error: e, stackTrace: stack);
    }
  }

  Future<String?> pickFile() async {
    try {
      XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
      );

      if (image == null) return null;

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );

      if (compressedBytes == null) {
        ShowToastDialog.showToast("Failed to compress image.");
        return null;
      }

      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes);

      checkIfFieldsAreFilled();
      return compressedFile.path;
    } on PlatformException catch (e, stack) {
      developer.log("Error in pickFile", error: e, stackTrace: stack);
      ShowToastDialog.showToast("Failed to complete the action:\n$e");
    } catch (e, stack) {
      developer.log("Error in pickFile", error: e, stackTrace: stack);
      ShowToastDialog.showToast("An unexpected error occurred:\n$e");
    }
    return null;
  }

  final ImagePicker documentImagePicker = ImagePicker();

  Future<void> documentPickFile({required ImageSource source, required VerifyDocumentModel verifyDocumentModel, required int index, required int imageIndex}) async {
    try {
      XFile? image = await documentImagePicker.pickImage(source: source, imageQuality: 60);
      if (image == null) return;

      Uint8List? compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 50,
      );
      File compressedFile = File(image.path);
      await compressedFile.writeAsBytes(compressedBytes!);

      if (verifyDocumentModel.documentImage != null && verifyDocumentModel.documentImage!.length > imageIndex) {
        verifyDocumentModel.documentImage![imageIndex] = compressedFile.path;
      } else {
        verifyDocumentModel.documentImage!.add(compressedFile.path);
      }

      verifyDocumentList[index] = verifyDocumentModel;
    } on PlatformException catch (e, stack) {
      developer.log("Error in documentPickFile", error: e, stackTrace: stack);
      ShowToastDialog.showToast("${"Failed to pick".tr} : \n $e");
    }
  }

  Future<void> saveData() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);
      String firstTwoChar = firstNameController.value.text.substring(0, 2).toUpperCase();

      driverModel.value.firstName = firstNameController.value.text;
      driverModel.value.lastName = lastNameController.value.text;
      driverModel.value.email = emailController.value.text;
      driverModel.value.countryCode = countryCode.value;
      driverModel.value.phoneNumber = mobileNumberController.value.text;
      driverModel.value.slug = Constant.fullNameString(firstNameController.value.text, lastNameController.value.text).toSlug(delimiter: '-');
      driverModel.value.createdAt = Timestamp.now();
      driverModel.value.active = true;
      driverModel.value.status = 'free';
      driverModel.value.orderId = '';
      driverModel.value.userType = Constant.driver;
      driverModel.value.walletAmount = "0.0";
      driverModel.value.isVerified = Constant.isDriverDocumentVerification == false ? true : false;
      driverModel.value.searchEmailKeywords = Constant.generateKeywords(emailController.value.text);
      driverModel.value.searchNameKeywords = Constant.generateKeywords(driverModel.value.fullNameString());

      driverModel.value.driverVehicleDetails = DriverVehicleDetails(
        isVerified: Constant.isDriverDocumentVerification == false ? true : false,
        modelName: vehicleNameController.value.text,
        vehicleNumber: vehicleNumberController.value.text,
        vehicleTypeName: vehicleType.value.name,
      );

      if (verifyDocumentList.isNotEmpty) {
        for (var document in verifyDocumentList) {
          for (int i = 0; i < document.documentImage!.length; i++) {
            String imagePath = document.documentImage![i].toString();

            if (imagePath.isNotEmpty && !Constant.hasValidUrl(imagePath)) {
              String imageUrl = await Constant.uploadUserImageToFireStorage(
                File(imagePath),
                "driver_documents/${document.documentId}/${FireStoreUtils.getCurrentUid()}",
                imagePath.split('/').last,
              );
              document.documentImage![i] = imageUrl;
            }
          }
        }
        verifyDocumentList.refresh();
      }

      VerifyDriverModel verifyDriver = VerifyDriverModel(
        createAt: driverModel.value.createdAt,
        driverEmail: driverModel.value.email,
        driverId: driverModel.value.driverId,
        driverName: '${driverModel.value.firstName} ${driverModel.value.lastName}',
        verifyDocument: verifyDocumentList,
      );

      if (referralCodeController.value.text.isNotEmpty) {
        await FireStoreUtils.checkReferralCodeValidOrNot(referralCodeController.value.text).then(
          (value) async {
            if (value == true) {
              FireStoreUtils.getReferralUserByCode(referralCodeController.value.text).then(
                (value) async {
                  if (value != null) {
                    await addReferralAmount(value.userId.toString(), value.role.toString());
                    ReferralModel ownReferralModel = ReferralModel(
                        userId: FireStoreUtils.getCurrentUid(), referralBy: value.userId, role: Constant.driver, referralRole: value.role, referralCode: Constant.getReferralCode(firstTwoChar));
                    await FireStoreUtils.referralAdd(ownReferralModel);

                    String? referrerEmail;
                    String? referrerName;
                    if (value.role == Constant.user) {
                      CustomerUserModel? user = await FireStoreUtils.getCustomerUserData(value.userId.toString());
                      referrerEmail = user?.email;
                      referrerName = "${user?.firstName} ${user?.lastName}";
                    } else if (value.role == Constant.owner) {
                      OwnerModel? owner = await FireStoreUtils.getOwnerProfile(value.userId.toString());
                      referrerEmail = owner?.email;
                      referrerName = "${owner?.firstName} ${owner?.lastName}";
                    } else {
                      DriverUserModel? driver = await FireStoreUtils.getDriverUserProfile(value.userId.toString());
                      referrerEmail = driver?.email;
                      referrerName = "${driver?.firstName} ${driver?.lastName}";
                    }

                    if (referrerEmail != null) {
                      await EmailTemplateService.sendEmail(
                        type: "refer_and_earn",
                        toEmail: referrerEmail,
                        variables: {
                          "name": referrerName,
                          "referral_name": "${driverModel.value.firstName} ${driverModel.value.lastName}",
                          "amount": Constant.amountShow(amount: Constant.referralAmount),
                        },
                      );
                    }
                  } else {
                    ReferralModel referralModel =
                        ReferralModel(userId: FireStoreUtils.getCurrentUid(), referralBy: "", role: Constant.driver, referralRole: "", referralCode: Constant.getReferralCode(firstTwoChar));
                    await FireStoreUtils.referralAdd(referralModel);
                  }
                },
              );
            }
          },
        );
      } else {
        ReferralModel referralModel =
            ReferralModel(userId: FireStoreUtils.getCurrentUid(), referralBy: "", role: Constant.driver, referralRole: "", referralCode: Constant.getReferralCode(firstTwoChar));
        await FireStoreUtils.referralAdd(referralModel);
      }

      bankDetailsModel.value.id = Constant.getUuid();
      bankDetailsModel.value.driverId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = bankIfscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.addBankDetail(bankDetailsModel.value);
      await FireStoreUtils.addVerifyDriver(verifyDriver);

      await FireStoreUtils.addDriver(driverModel.value).then((value) async {
        if (value == true) {
          Constant.isLogin = await FireStoreUtils.isLogin();
          Constant.driverUserModel = await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid());
          await EmailTemplateService.sendEmail(
            type: "signup",
            toEmail: driverModel.value.email.toString(),
            variables: {"name": "${driverModel.value.firstName} ${driverModel.value.lastName}", "app_name": Constant.appName.value},
          );
          Get.offAll(() => AccountCreatedSuccessfullyView());
        }
      });
    } catch (e, stack) {
      developer.log("Error in saveData", error: e, stackTrace: stack);
      ShowToastDialog.showToast("${"Something went wrong:".tr}\n$e");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<UserCredential?> signUpEmailWithPass(String email, String password) async {
    try {
      ShowToastDialog.showLoader("Please Wait...".tr);
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e, stack) {
      developer.log(
        "Error signUpEmailWithPass",
        error: e,
        stackTrace: stack,
      );
      ShowToastDialog.closeLoader();
      if (e.code == 'email-already-in-use') {
        ShowToastDialog.showToast("This email is already in use.".tr);
      } else if (e.code == "invalid-email") {
        ShowToastDialog.showToast("Please enter a valid email address.".tr);
      } else if (e.code == "weak-password") {
        ShowToastDialog.showToast("The password is too weak. Try using a stronger password.".tr);
      }
    } catch (e, stack) {
      developer.log("Error in signUpEmailWithPass", error: e, stackTrace: stack);
      ShowToastDialog.showToast("Unexpected error during registration.".tr);
    }
    return null;
  }

  Future<void> signUp() async {
    String email = emailController.value.text;
    String password = passwordController.value.text;

    UserCredential? value = await signUpEmailWithPass(email, password);
    if (value == null) {
      ShowToastDialog.closeLoader();
      return;
    }

    try {
      String fcmToken = await NotificationService.getToken();
      String firstTwoChar = firstNameController.value.text.substring(0, 2).toUpperCase();

      driverModel.value.driverId = value.user!.uid;
      driverModel.value.firstName = firstNameController.value.text;
      driverModel.value.lastName = lastNameController.value.text;
      driverModel.value.slug = Constant.fullNameString(firstNameController.value.text, lastNameController.value.text).toSlug(delimiter: "-");
      driverModel.value.loginType = Constant.emailLoginType;
      driverModel.value.email = emailController.value.text;
      driverModel.value.password = passwordController.value.text;
      driverModel.value.countryCode = countryCode.value;
      driverModel.value.phoneNumber = mobileNumberController.value.text;
      driverModel.value.userType = Constant.driver;
      driverModel.value.profileImage = '';
      driverModel.value.fcmToken = fcmToken;
      driverModel.value.createdAt = Timestamp.now();
      driverModel.value.walletAmount = "0.0";
      driverModel.value.slug = '${firstNameController.value.text} ${lastNameController.value.text}';
      driverModel.value.active = true;
      driverModel.value.status = 'free';
      driverModel.value.orderId = '';
      driverModel.value.isVerified = Constant.isDriverDocumentVerification == false ? true : false;
      driverModel.value.searchEmailKeywords = Constant.generateKeywords(emailController.value.text);
      driverModel.value.searchNameKeywords = Constant.generateKeywords(driverModel.value.fullNameString());

      if (referralCodeController.value.text.isNotEmpty) {
        await FireStoreUtils.checkReferralCodeValidOrNot(referralCodeController.value.text).then(
          (value) async {
            if (value == true) {
              FireStoreUtils.getReferralUserByCode(referralCodeController.value.text).then(
                (value) async {
                  if (value != null) {
                    await addReferralAmount(value.userId.toString(), value.role.toString());
                    ReferralModel ownReferralModel = ReferralModel(
                        userId: FireStoreUtils.getCurrentUid(), referralBy: value.userId, role: Constant.driver, referralRole: value.role, referralCode: Constant.getReferralCode(firstTwoChar));
                    await FireStoreUtils.referralAdd(ownReferralModel);

                    String? referrerEmail;
                    String? referrerName;
                    if (value.role == Constant.user) {
                      CustomerUserModel? user = await FireStoreUtils.getCustomerUserData(value.userId.toString());
                      referrerEmail = user?.email;
                      referrerName = "${user?.firstName} ${user?.lastName}";
                    } else if (value.role == Constant.owner) {
                      OwnerModel? owner = await FireStoreUtils.getOwnerProfile(value.userId.toString());
                      referrerEmail = owner?.email;
                      referrerName = "${owner?.firstName} ${owner?.lastName}";
                    } else {
                      DriverUserModel? driver = await FireStoreUtils.getDriverUserProfile(value.userId.toString());
                      referrerEmail = driver?.email;
                      referrerName = "${driver?.firstName} ${driver?.lastName}";
                    }

                    if (referrerEmail != null) {
                      await EmailTemplateService.sendEmail(
                        type: "refer_and_earn",
                        toEmail: referrerEmail,
                        variables: {
                          "name": referrerName,
                          "referral_name": "${driverModel.value.firstName} ${driverModel.value.lastName}",
                          "amount": Constant.amountShow(amount: Constant.referralAmount),
                        },
                      );
                    }
                  } else {
                    ReferralModel referralModel =
                        ReferralModel(userId: FireStoreUtils.getCurrentUid(), referralBy: "", role: Constant.driver, referralRole: "", referralCode: Constant.getReferralCode(firstTwoChar));
                    await FireStoreUtils.referralAdd(referralModel);
                  }
                },
              );
            }
          },
        );
      } else {
        ReferralModel referralModel =
            ReferralModel(userId: FireStoreUtils.getCurrentUid(), referralBy: "", role: Constant.driver, referralRole: "", referralCode: Constant.getReferralCode(firstTwoChar));
        await FireStoreUtils.referralAdd(referralModel);
      }

      driverModel.value.driverVehicleDetails = DriverVehicleDetails(
        isVerified: Constant.isDriverDocumentVerification == false ? true : false,
        modelName: vehicleNameController.value.text,
        vehicleNumber: vehicleNumberController.value.text,
        vehicleTypeName: vehicleType.value.name,
      );

      if (verifyDocumentList.isNotEmpty) {
        for (var document in verifyDocumentList) {
          for (int i = 0; i < document.documentImage!.length; i++) {
            String imagePath = document.documentImage![i];
            if (imagePath.isNotEmpty && !Constant.hasValidUrl(imagePath)) {
              String imageUrl = await Constant.uploadUserImageToFireStorage(
                File(imagePath),
                "driver_documents/${document.documentId}/${FireStoreUtils.getCurrentUid()}",
                imagePath.split('/').last,
              );
              document.documentImage![i] = imageUrl;
            }
          }
        }
        verifyDocumentList.refresh();
      }

      VerifyDriverModel verifyDriver = VerifyDriverModel(
        createAt: driverModel.value.createdAt,
        driverEmail: driverModel.value.email,
        driverId: driverModel.value.driverId,
        driverName: '${driverModel.value.firstName} ${driverModel.value.lastName}',
        verifyDocument: verifyDocumentList,
      );

      bankDetailsModel.value.id = Constant.getUuid();
      bankDetailsModel.value.driverId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = bankIfscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.addBankDetail(bankDetailsModel.value);
      await FireStoreUtils.addVerifyDriver(verifyDriver);

      await FireStoreUtils.addDriver(driverModel.value).then((value) async {
        ShowToastDialog.closeLoader();
        if (value == true) {
          Constant.isLogin = await FireStoreUtils.isLogin();
          Constant.driverUserModel = await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid());
          Get.offAll(() => AccountCreatedSuccessfullyView());
          await EmailTemplateService.sendEmail(
            type: "signup",
            toEmail: driverModel.value.email.toString(),
            variables: {"name": "${driverModel.value.firstName} ${driverModel.value.lastName}", "app_name": Constant.appName.value},
          );
        } else {
          ShowToastDialog.showToast("Registration failed. Please try again.".tr);
        }
      });
    } catch (e, stack) {
      developer.log("Error in signUp", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Something went wrong. Please try again later.".tr);
    }
  }

  Future<void> addReferralAmount(String userId, String role) async {
    WalletTransactionModel walletTransaction = WalletTransactionModel(
        id: Constant.getUuid(),
        isCredit: true,
        amount: Constant.referralAmount.toString(),
        note: "Referral Amount Credited",
        paymentType: "wallet",
        userId: userId,
        type: role,
        createdDate: Timestamp.now());

    bool? isSuccess = await FireStoreUtils.setWalletTransaction(walletTransaction);
    if (isSuccess == true) {
      await FireStoreUtils.updateWalletForReferral(userId: userId, amount: double.parse(Constant.referralAmount!).toString(), role: role);
    }
  }
}

enum VehicleType { bike, scooter }
