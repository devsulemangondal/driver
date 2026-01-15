import 'package:driver/app/modules/my_documents/controllers/my_documents_controller.dart';
import 'package:get/get.dart';

class MyDocumentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyDocumentController>(
      () => MyDocumentController(),
    );
  }
}
