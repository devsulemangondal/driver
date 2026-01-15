
// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String? title;
  String? amount;
  String? code;
  String? vendorId;
  bool? active;
  String? id;
  String? minAmount;
  Timestamp? expireAt;
  bool? isFix;
  bool? isPrivate;
  bool? isVendorOffer;
  CouponModel({this.title, this.amount, this.code, this.vendorId, this.active, this.id, this.minAmount, this.expireAt, this.isFix, this.isPrivate, this.isVendorOffer});

  CouponModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    amount = json['amount'] ?? '0.0';
    code = json['code'];
    active = json['active'];
    minAmount = json['minAmount'];
    id = json['id'];
    isPrivate = json['isPrivate'];
    expireAt = json['expireAt'];
    isFix = json['isFix'];
    isVendorOffer = json['isVendorOffer'];
    vendorId = json['vendorId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['amount'] = amount;
    data['code'] = code;
    data['minAmount'] = minAmount;
    data['active'] = active;
    data['id'] = id;
    data['isPrivate'] = isPrivate;
    data['expireAt'] = expireAt;
    data['isFix'] = isFix;
    data['isVendorOffer'] = isVendorOffer;
    data['vendorId'] = vendorId;
    return data;
  }
}
