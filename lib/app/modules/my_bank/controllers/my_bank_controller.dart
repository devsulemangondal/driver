// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/bank_details_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBankController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  TextEditingController bankHolderNameController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankBranchCityController = TextEditingController();
  TextEditingController bankBranchCountryController = TextEditingController();
  RxString editingId = "".obs;
  RxBool isLoading = false.obs;

  Rx<BankDetailsModel> bankDetailsModel = BankDetailsModel().obs;
  List<BankDetailsModel> bankDetailsList = <BankDetailsModel>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;
      bankDetailsList.clear();

      final value = await FireStoreUtils.getBankDetailList(FireStoreUtils.getCurrentUid());
      if (value != null) {
        bankDetailsList.addAll(value);
      }
    } catch (e,stack) {
      developer.log("Error in getData", error: e, stackTrace: stack);

    } finally {
      isLoading.value = false;
    }
  }


  void setDefault() {
    try {
      bankHolderNameController.text = "";
      bankAccountNumberController.text = "";
      swiftCodeController.text = "";
      ifscCodeController.text = "";
      bankNameController.text = "";
      bankBranchCityController.text = "";
      bankBranchCountryController.text = "";
      editingId.value = "";
    } catch (e,stack) {
      developer.log("Error in setDefault", error: e, stackTrace: stack);
    }
  }

  Future<void> setBankDetails() async {
    try {
      bankDetailsModel.value.id = Constant.getUuid();
      bankDetailsModel.value.driverId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.addBankDetail(bankDetailsModel.value);

      setDefault();
    } catch (e,stack) {
      developer.log("Error in setBankDetails", error: e, stackTrace: stack);
    }
  }

  Future<void> updateBankDetail() async {
    try {
      bankDetailsModel.value.id = editingId.value;
      bankDetailsModel.value.driverId = FireStoreUtils.getCurrentUid();
      bankDetailsModel.value.holderName = bankHolderNameController.value.text;
      bankDetailsModel.value.accountNumber = bankAccountNumberController.value.text;
      bankDetailsModel.value.swiftCode = swiftCodeController.value.text;
      bankDetailsModel.value.ifscCode = ifscCodeController.value.text;
      bankDetailsModel.value.bankName = bankNameController.value.text;
      bankDetailsModel.value.branchCity = bankBranchCityController.value.text;
      bankDetailsModel.value.branchCountry = bankBranchCountryController.value.text;

      await FireStoreUtils.updateBankDetail(bankDetailsModel.value);

      setDefault();
    } catch (e,stack) {
      developer.log("Error in updateBankDetail", error: e, stackTrace: stack);
    }
  }

  Future<void> deleteBankDetails(BankDetailsModel bankDetailsModel) async {
    isLoading = true.obs;
    ShowToastDialog.showLoader("Please Wait..".tr);

    try {
      await FirebaseFirestore.instance
          .collection(CollectionName.bankDetails)
          .doc(bankDetailsModel.id)
          .delete();

      ShowToastDialog.showToast("Bank Detail deleted...!".tr);
    } catch (e,stack) {
      developer.log("Error in deleteBankDetails", error: e, stackTrace: stack);
    } finally {
      getData();
      ShowToastDialog.closeLoader();
      isLoading = false.obs;
    }
  }
}
