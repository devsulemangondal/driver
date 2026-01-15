// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String? rating;
  Timestamp? date;
  String? customerId;
  String? comment;
  String? serviceId;

  ReviewModel({this.id, this.date, this.rating, this.customerId, this.comment, this.serviceId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    rating = json['rating'] ?? '0.0';
    customerId = json['customerId'];
    comment = json['comment'];
    serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['customerId'] = customerId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['serviceId'] = serviceId;
    return data;
  }
}
