// ignore_for_file: depend_on_referenced_packages, unused_catch_stack

import 'dart:developer' as developer;

import 'package:driver/app/models/notification_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreenController extends GetxController {
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;

  RxBool isLoading = false.obs;

  RxList<NotificationModel> todayNotifications = <NotificationModel>[].obs;
  RxList<NotificationModel> yesterdayNotifications = <NotificationModel>[].obs;
  RxList<NotificationModel> olderNotifications = <NotificationModel>[].obs;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  var groupedNotifications = <String, List<NotificationModel>>{}.obs;

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }

  void getNotifications() {
    isLoading.value = true;

    try {
      FireStoreUtils.getNotificationList().listen((snapshot) {
        List<NotificationModel> notifications = [];

        for (var doc in snapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          NotificationModel notification = NotificationModel.fromJson(data);
          notifications.add(notification);
        }

        notificationList.value = notifications;
        groupNotificationsByDate();
        isLoading.value = false;
      });
    } catch (e, stacktrace) {
      isLoading.value = false;
    }
  }

  void groupNotificationsByDate() {
    try {
      Map<String, List<NotificationModel>> tempGroupedNotifications = {};

      for (var notification in notificationList) {
        if (notification.createdAt != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(notification.createdAt!.toDate());
          tempGroupedNotifications.putIfAbsent(formattedDate, () => []);
          tempGroupedNotifications[formattedDate]!.add(notification);
        }
      }

      groupedNotifications.value = tempGroupedNotifications;
    } catch (e, stack) {
      developer.log("Error in groupNotificationsByDate", error: e, stackTrace: stack);
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    try {
      await fireStore.collection(CollectionName.notification).doc(notification.id).delete();

      groupNotificationsByDate();
    } catch (e, stack) {
      developer.log("Error in deleteNotification", error: e, stackTrace: stack);
    }
  }
}
