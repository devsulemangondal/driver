import 'package:driver/app/modules/edit_profile_screen/controllers/edit_profile_screen_controller.dart';
import 'package:get/get.dart';

class EditProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileScreenController>(
      () => EditProfileScreenController(),
    );
  }
}
