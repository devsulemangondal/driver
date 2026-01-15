// ignore_for_file: unnecessary_overrides

import 'dart:developer' as developer;

import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/models/reject_driver_reason_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';

class OrderDetailsScreenController extends GetxController {
  RxBool isRejected = true.obs;
  RxBool isLoading = true.obs;

  Rx<OrderModel> orderModel = OrderModel().obs;
  Rx<CustomerUserModel> customerUSerModel = CustomerUserModel().obs;
  Rx<ReviewModel> reviewModel = ReviewModel().obs;

  RxString userRejectedReasons = ''.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    try {
      isLoading.value = true;
      dynamic argumentData = Get.arguments;

      if (argumentData != null) {
        customerUSerModel.value = await argumentData['CustomerUserModel'];
        orderModel.value = await argumentData['OrderModel'];
        isRejected.value = await argumentData['isRejected'];
        await getReview();
      }

      if (isRejected.value == true) {
        final rejectedReasons = orderModel.value.rejectedDriverReason ?? [];

        final matchingReason = rejectedReasons.firstWhere(
              (reason) => reason.driverId == FireStoreUtils.getCurrentUid(),
          orElse: () => RejectDriverReasonModel(reason: 'No reason found', driverId: ''),
        );

        userRejectedReasons.value = matchingReason.reason ?? 'No reason found';
      }
    } catch (e, stack) {
      developer.log("Error in getArgument", error: e, stackTrace: stack);

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getReview() async {
    try {
      final value = await FireStoreUtils.getReview(orderModel.value.id.toString());
      if (value != null) {
        reviewModel.value = value;
      }
    } catch (e, stack) {
      developer.log("Error in getReview", error: e, stackTrace: stack);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
