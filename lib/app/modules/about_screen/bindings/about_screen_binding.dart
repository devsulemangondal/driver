import 'package:get/get.dart';

import '../controllers/about_screen_controller.dart';

class AboutScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutScreenController>(
      () => AboutScreenController(),
    );
  }
}
