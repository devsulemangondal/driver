import 'dart:convert';

import 'package:driver/app/models/variation_model.dart';

class CartModel {
  int? id;
  String? productId;
  String? customerId;
  int? quantity;
  int? itemPrice;
  int? totalAmount;
  String? productName;
  List<dynamic>? addOns;
  VariationModel? variation;
  String? vendorId;
  String? preparationTime;

  CartModel({
    this.id,
    this.productId,
    this.customerId,
    this.quantity,
    this.itemPrice,
    this.totalAmount,
    this.productName,
    this.addOns,
    this.variation,
    this.vendorId,
    this.preparationTime,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    customerId = json['customerId'];
    quantity = json['quantity'];
    itemPrice = json['itemPrice'] != null ? int.tryParse(json['itemPrice'].toString()) : null;
    totalAmount = json['totalAmount'];
    productName = json['productName'];
    addOns = json['addOns'] == "null" || json['addOns'] == null
        ? null
        : "String" == json['addOns'].runtimeType.toString()
            ? List<dynamic>.from(jsonDecode(json['addOns']))
            : List<dynamic>.from(json['addOns']);
    variation = json['variation'] == "null" || json['variation'] == null
        ? null
        : "String" == json['variation'].runtimeType.toString()
            ? VariationModel.fromJson(jsonDecode(json['variation']))
            : VariationModel.fromJson(json['variation']);
    vendorId = json['vendorId'];
    preparationTime = json['preparationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['customerId'] = customerId;
    data['quantity'] = quantity;
    data['itemPrice'] = itemPrice;
    data['totalAmount'] = totalAmount;
    data['productName'] = productName;
    data['addOns'] = addOns;
    if (variation != null) {
      data['variation'] = variation!.toJson();
    }
    data['vendorId'] = vendorId;
    data['preparationTime'] = preparationTime;
    return data;
  }
}
