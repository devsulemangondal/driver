// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/notification_model.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:googleapis_auth/auth_io.dart'; // For OAuth 2.0
import 'package:http/http.dart' as http;

class SendNotification {
  static final _scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  static Future getCharacters() {
    return http.get(Uri.parse(Constant.jsonFileURL.toString()));
  }

  static Future<String> getAccessToken() async {
    Map<String, dynamic> jsonData = {};

    await getCharacters().then((response) {
      jsonData = json.decode(response.body);
    });
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(jsonData);

    final client = await clientViaServiceAccount(serviceAccountCredentials, _scopes);
    return client.credentials.accessToken.data;
  }

  static Future<void> sendOneNotification({
    required String token,
    required String title,
    required String body,
    required String type,
    required bool isPayment,
    required bool isSaveNotification,
    required Map<String, dynamic> payload,
    String? orderId,
    String? ownerId,
    String? customerId,
    String? driverId,
    String? senderId,
    bool isNewOrder = false,
  }) async {
    // Save notification in Firestore if orderId is provided
    NotificationModel notificationModel = NotificationModel();
    if (orderId != null) {
      notificationModel.id = Constant.getUuid();
      notificationModel.type = type;
      notificationModel.title = title;
      notificationModel.description = body;
      notificationModel.orderId = orderId;
      notificationModel.customerId = customerId;
      notificationModel.driverId = driverId;
      notificationModel.ownerId = ownerId;
      notificationModel.senderId = senderId;
      notificationModel.createdAt = Timestamp.now();

      if (isSaveNotification) {
        await FireStoreUtils.setNotification(notificationModel);
      }
    }

    final String accessToken = await getAccessToken();

    Map<String, dynamic> mergedPayload = {
      ...orderId != null ? notificationModel.toNotificationJson() : payload,
      'isNewOrder': isNewOrder ? 'true' : 'false',
    };

    // Fixed message payload
    Map<String, dynamic> message = {
      'token': token,
      'data': mergedPayload, // use only data for iOS custom handling
      'android': {
        'notification': {
          'channel_id': isNewOrder ? 'orders_channel' : 'default_channel',
          'title': title,
          'body': body,
          'sound': isNewOrder ? 'order_sound' : 'default',
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
      'apns': {
        'headers': {'apns-priority': '10'},
        'payload': {
          'aps': {
            'alert': {'title': title, 'body': body}, // required for display
            'sound': isNewOrder ? 'order_sound.wav' : 'default', // iOS sound
            'content-available': 1,
          },
        },
      },
    };

    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/${Constant.senderId}/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'message': message}),
      );

      log("✅ Notification sent: ${response.body}");
    } catch (e) {
      log("❌ Error sending notification: $e");
    }
  }
}