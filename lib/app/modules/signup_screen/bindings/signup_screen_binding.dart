import 'package:driver/app/modules/signup_screen/controllers/signup_screen_controller.dart';
import 'package:get/get.dart';


class SignupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupScreenController>(
      () => SignupScreenController(),
    );
  }
}
