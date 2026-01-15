// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:driver/services/localization_service.dart';
import 'package:driver/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/fire_store_utils.dart';

import '../app/models/driver_user_model.dart';
import '../app/models/language_model.dart';
import '../utils/notification_service.dart';

class GlobalController extends GetxController {
  @override
  Future<void> onInit() async {
    //  getData();
    super.onInit();
    await getLanguage();
    await getSettingData();
    await notificationInit();
  }

  Future<void> getData() async {
    await getLanguage();
    await getSettingData();
    notificationInit();
  }

  Future<void> getSettingData() async {
    try {
      await FireStoreUtils().getSettings();
      await FireStoreUtils().getAdminCommissionDriver();
      await FireStoreUtils().getAdminCommissionVendor();
      AppThemeData.primary300 = HexColor.fromHex(Constant.appColor.toString());
    } catch (e, stack) {
      developer.log("Error in getLanguage", error: e, stackTrace: stack);
    }
  }

  NotificationService notificationService = NotificationService();

  Future<void> notificationInit() async {
    try {
      await notificationService.initInfo();
      String token = await NotificationService.getToken();

      if (FirebaseAuth.instance.currentUser != null) {
        try {
          DriverUserModel? driverUserModel = await FireStoreUtils.getDriverUserProfile(
            FireStoreUtils.getCurrentUid(),
          );

          if (driverUserModel != null) {
            driverUserModel.fcmToken = token;
            await FireStoreUtils.updateDriverUser(driverUserModel);
          }
        } catch (e, stack) {
          developer.log("Error updating FCM token", error: e, stackTrace: stack);
        }
      }
    } catch (e, stack) {
      developer.log("Error in notificationInit", error: e, stackTrace: stack);
    }
  }

  Future<void> getLanguage() async {
    try {
      if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
        LanguageModel languageModel = Constant.getLanguage();
        LocalizationService().changeLocale(languageModel.code.toString());
      } else {
        LanguageModel languageModel = LanguageModel(
          id: "LzSABjMohyW3MA0CaxVH",
          name: "English",
          code: "en",
        );
        Preferences.setString(
          Preferences.languageCodeKey,
          jsonEncode(languageModel.toJson()),
        );
        LocalizationService().changeLocale(languageModel.code.toString());
      }
    } catch (e, stack) {
      developer.log("Error in getLanguage", error: e, stackTrace: stack);
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
