import 'package:driver/app/modules/orders_screen/controllers/orders_screen_controller.dart';
import 'package:get/get.dart';

class OrdersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersScreenController>(
      () => OrdersScreenController(),
    );
  }
}
