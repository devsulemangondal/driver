// ignore_for_file: unnecessary_overrides

import 'package:driver/app/models/onboarding_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroScreenController extends GetxController {
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;
  RxList<OnboardingScreenModel> onboardingList = <OnboardingScreenModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getOnboarding();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getOnboarding() async {
    try {
      await FireStoreUtils.getOnboardingDataList().then((value) {
        onboardingList.value = value;
      });
    } catch (error) {
      debugPrint("Error fetching onboarding data: $error");
    }
  }
}
