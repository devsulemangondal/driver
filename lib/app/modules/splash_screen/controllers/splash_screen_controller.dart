import 'dart:async';
import 'dart:developer' as developer;
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/account_disabled_screen.dart';
import 'package:driver/app/modules/home_screen/views/home_screen_view.dart';
import 'package:driver/app/modules/intro_screen/views/intro_screen_view.dart';
import 'package:driver/app/modules/landing_screen/views/landing_screen_view.dart';
import 'package:driver/utils/preferences.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/currency_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';


class SplashScreenController extends GetxController {

  @override
  Future<void> onInit() async {

    super.onInit();
    await getCurrentCurrency();
    Timer(const Duration(seconds: 3), () => redirectScreen());

  }

  Future<void> redirectScreen() async {
    try {
      if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
        Get.offAll(() => IntroScreenView());
      } else {
        bool isLogin = await FireStoreUtils.isLogin();
        if (isLogin == true) {
          DriverUserModel? driverUserModel = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid());

          if (driverUserModel != null && driverUserModel.active == true) {
            Get.offAll(() => HomeScreenView());
          } else {
            Get.offAll(() => AccountDisabledScreen());
          }
        } else {
          Get.offAll(() => LandingScreenView());
        }
      }
    } catch (e,stack) {
      developer.log("Error in redirectScreen", error: e, stackTrace: stack);
    }
  }

  // Future<void> getCurrentCurrency() async {
  //   try {
  //     CurrencyModel? value = await FireStoreUtils().getCurrency();
  //     if (value != null) {
  //       Constant.currencyModel = value;
  //     } else {
  //       Constant.currencyModel = CurrencyModel(
  //         id: "",
  //         code: "USD",
  //         decimalDigits: 2,
  //         enable: true,
  //         name: "US Dollar",
  //         symbol: "\$",
  //         symbolAtRight: false,
  //       );
  //     }
  //   } catch (e, stack) {
  //     developer.log("Error in getCurrentCurrency", error: e, stackTrace: stack);
  //     Constant.currencyModel = CurrencyModel(
  //       id: "",
  //       code: "USD",
  //       decimalDigits: 2,
  //       enable: true,
  //       name: "US Dollar",
  //       symbol: "\$",
  //       symbolAtRight: false,
  //     );
  //   }
  // }
  Future<void> getCurrentCurrency() async {
    try {
      Constant.currencyModel = await FireStoreUtils().getCurrency() ??
          CurrencyModel(
            id: "",
            code: "USD",
            decimalDigits: 2,
            enable: true,
            name: "US Dollar",
            symbol: "\$",
            symbolAtRight: false,
          );
    } catch (e, stack) {
      developer.log("Currency fetch failed", error: e, stackTrace: stack);
      Constant.currencyModel = CurrencyModel(
        id: "",
        code: "USD",
        decimalDigits: 2,
        enable: true,
        name: "US Dollar",
        symbol: "\$",
        symbolAtRight: false,
      );
    }
  }
}

