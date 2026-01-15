import 'package:driver/app/modules/language_screen/controllers/language_screen_controller.dart';
import 'package:get/get.dart';

class LanguageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageScreenController>(
      () => LanguageScreenController(),
    );
  }
}
