import 'package:driver/app/modules/order_details_screen/controllers/orders_details_controller.dart';
import 'package:get/get.dart';

class OrdersDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsScreenController>(
      () => OrderDetailsScreenController(),
    );
  }
}
