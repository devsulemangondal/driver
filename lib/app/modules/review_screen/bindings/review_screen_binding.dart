import 'package:driver/app/modules/review_screen/controllers/review_screen_controller.dart';
import 'package:get/get.dart';

class ReviewScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ReviewScreenController>(()=>ReviewScreenController());
  }
}