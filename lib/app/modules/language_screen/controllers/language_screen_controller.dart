
import 'dart:developer' as developer;
import 'dart:ui';

import 'package:driver/app/models/language_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/preferences.dart';
import 'package:get/get.dart';

class LanguageScreenController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  RxList<Color> lightModeColors = [AppThemeData.secondary50, AppThemeData.primary50, AppThemeData.info50, AppThemeData.pending50].obs;

  RxList<Color> darkModeColors = [AppThemeData.secondary600, AppThemeData.green600, AppThemeData.info600, AppThemeData.pending600].obs;

  RxList<Color> activeColor = [AppThemeData.secondary300, AppThemeData.success300, AppThemeData.info300, AppThemeData.pending300].obs;

  RxList<Color> textColorLightMode = [AppThemeData.secondary400, AppThemeData.success400, AppThemeData.info400, AppThemeData.pending400].obs;

  RxList<Color> textColorDarkMode = [AppThemeData.secondary200, AppThemeData.success200, AppThemeData.info200, AppThemeData.pending200].obs;

  @override
  void onInit() {
    getLanguage();
    super.onInit();
  }

  Future<void> getLanguage() async {
    isLoading.value = true;
    try {
      final value = await FireStoreUtils.getLanguage();
      if (value != null) {
        languageList.value = value;

        if (Preferences.getString(Preferences.languageCodeKey).toString().isNotEmpty) {
          LanguageModel pref = Constant.getLanguage();

          for (var element in languageList) {
            if (element.id == pref.id) {
              selectedLanguage.value = element;
              break;
            }
          }
        }
      }
    } catch (e,stack) {
      developer.log("Error in getLanguage", error: e, stackTrace: stack);

    } finally {
      isLoading.value = false;
      update();
    }
  }
}