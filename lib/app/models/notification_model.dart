// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  String? type;
  String? title;
  String? description;
  String? orderId;
  String? ownerId;
  String? customerId;
  String? driverId;
  String? senderId;
  Timestamp? createdAt;

  NotificationModel({
    this.id,
    this.title,
    this.description,
    this.orderId,
    this.ownerId,
    this.customerId,
    this.driverId,
    this.senderId,
    this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    orderId = json['orderId'];
    ownerId = json['ownerId'];
    customerId = json['customerId'];
    driverId = json['driverId'];
    senderId = json['senderId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['description'] = description;
    data['orderId'] = orderId;
    data['customerId'] = customerId;
    data['driverId'] = driverId;
    data['ownerId'] = ownerId;
    data['senderId'] = senderId;
    data['createdAt'] = createdAt;
    return data;
  }

  Map<String, dynamic> toNotificationJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['description'] = description;
    data['orderId'] = orderId;
    data['customerId'] = customerId;
    data['ownerId'] = ownerId;
    data['driverId'] = driverId;
    data['senderId'] = senderId;
    return data;
  }
}
