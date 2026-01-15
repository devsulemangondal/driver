import 'dart:developer' as developer;

import 'package:get/get.dart';

class HtmlViewScreenController extends GetxController {
  RxString title = "".obs;
  RxString policy = "".obs;

  void getArgument() {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        title.value = argumentData['title'] ?? '';
        policy.value = argumentData['Policy'] ?? '';
      }
    } catch (e,stack) {
      developer.log("Error in getArguments", error: e, stackTrace: stack);

    }
  }


  @override
  void onInit() {
    getArgument();
    super.onInit();
  }
}
