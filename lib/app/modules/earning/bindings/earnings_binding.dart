import 'package:driver/app/modules/earning/controllers/earnings_controller.dart';
import 'package:get/get.dart';

class EarningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EarningController>(
      () => EarningController(),
    );
  }
}
