import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class ReviewScreenController extends GetxController{
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;

  @ override
  void onInit() {
    getReview();
    super.onInit();
  }
  Future<void> getReview() async {
    try {
      final value = await FireStoreUtils.getDriverReview(FireStoreUtils.getCurrentUid());
      if (value != null) {
        reviewList.addAll(value);
      }
    } catch (_) {

    }
  }

}