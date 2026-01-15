import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';

class ShowToastDialog {
  static void showLoader(String message) {
    try {
      EasyLoading.show(status: message);
    } catch (e, stack) {
      developer.log("Error showLoader", error: e, stackTrace: stack);
    }
  }

  static void closeLoader() {
    try {
      EasyLoading.dismiss();
    } catch (e, stack) {
      developer.log("Error closeLoader", error: e, stackTrace: stack);
    }
  }

  static void showToast(
    String? value, {
    ToastGravity? gravity,
    Toast? length = Toast.LENGTH_SHORT,
    Color? bgColor,
    Color? textColor,
    bool log = false,
  }) {
    try {
      if (value == null || value.isEmpty) {
        if (kDebugMode) {}
        return;
      }

      Fluttertoast.showToast(
        msg: value,
        gravity: gravity,
        toastLength: length,
        backgroundColor: bgColor,
        textColor: textColor,
      );

      if (log && kDebugMode) {}
    } catch (e, stack) {
      developer.log("Error in toast", error: e, stackTrace: stack);
      if (kDebugMode) {}
    }
  }
}
