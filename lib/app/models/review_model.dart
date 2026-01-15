// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String? rating;
  Timestamp? date;
  String? customerId;
  String? orderId;
  String? comment;
  String? vendorId;
  String? driverId;
  String? type;

  ReviewModel({this.id, this.date, this.rating, this.orderId,this.customerId, this.comment, this.vendorId, this.driverId, this.type});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    rating = json['rating'];
    customerId = json['customerId'];
    comment = json['comment'];
    vendorId = json['vendorId'];
    orderId = json['orderId'];
    driverId = json['driverId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['customerId'] = customerId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['vendorId'] = vendorId;
    data['orderId'] = orderId;
    data['driverId'] = driverId;
    data['type'] = type;
    return data;
  }
}
