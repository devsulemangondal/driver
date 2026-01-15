// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/add_address_model.dart';
import 'package:driver/app/models/admin_commission.dart';
import 'package:driver/app/models/cart_model.dart';
import 'package:driver/app/models/coupon_model.dart';
import 'package:driver/app/models/reject_driver_reason_model.dart';
import 'package:driver/app/models/tax_model.dart';

class OrderModel {
  String? id;
  String? customerId;
  String? vendorId;
  String? driverId;
  String? orderStatus;
  List<CartModel>? items;
  AddAddressModel? customerAddress;
  AddAddressModel? vendorAddress;
  String? paymentType;
  bool? paymentStatus;
  String? discount;
  String? transactionPaymentId;
  String? totalAmount;
  String? subTotal;
  String? deliveryInstruction;
  String? cookingInstruction;
  AdminCommission? adminCommissionDriver;
  AdminCommission? adminCommissionVendor;
  Timestamp? createdAt;
  CouponModel? coupon;
  List<TaxModel>? taxList;
  List<TaxModel>? packagingTaxList;
  List<TaxModel>? deliveryTaxList;
  bool? foodIsReadyToPickup;
  List<dynamic>? rejectedDriverIds;
  List<RejectDriverReasonModel>? rejectedDriverReason;
  String? cancelledBy;
  String? deliveryCharge;
  String? cancelledReason;
  Timestamp? assignedAt;
  String? deliveryType;
  String? platFormFee;
  String? packagingFee;
  String? deliveryTip;
  ETAModel? estimatedDeliveryTime;

  OrderModel(
      {this.id,
      this.customerId,
      this.vendorId,
      this.driverId,
      this.orderStatus,
      this.items,
      this.customerAddress,
      this.vendorAddress,
      this.createdAt,
      this.paymentType,
      this.paymentStatus,
      this.discount,
      this.transactionPaymentId,
      this.coupon,
      this.totalAmount,
      this.subTotal,
      this.deliveryInstruction,
      this.cookingInstruction,
      this.adminCommissionVendor,
      this.adminCommissionDriver,
      this.taxList,
      this.rejectedDriverReason,
      this.packagingTaxList,
      this.deliveryTaxList,
      this.foodIsReadyToPickup,
      this.rejectedDriverIds,
      this.cancelledBy,
      this.deliveryCharge,
      this.cancelledReason,
      this.assignedAt,
      this.platFormFee,
      this.packagingFee,
      this.deliveryTip,
      this.deliveryType,
      this.estimatedDeliveryTime});

  @override
  String toString() {
    return 'OrderModel{id: $id, customerId: $customerId, platFormFee: $platFormFee,packagingTaxList: $packagingTaxList,deliveryTaxList: $deliveryTaxList,packagingFee: $packagingFee,deliveryTip: $deliveryTip, vendorId: $vendorId, driverId: $driverId, orderStatus: $orderStatus, items: $items, customerAddress: $customerAddress, vendorAddress: $vendorAddress, paymentType: $paymentType, paymentStatus: $paymentStatus, discount: $discount, totalAmount: $totalAmount, subTotal: $subTotal, deliveryInstruction: $deliveryInstruction, cookingInstruction: $cookingInstruction, adminCommissionDriver: $adminCommissionDriver, createdAt: $createdAt, coupon: $coupon, taxList: $taxList, requestDriverID: $rejectedDriverIds, cancelledBy: $cancelledBy, cancelledReason: $cancelledReason, assignedAt: $assignedAt , deliveryType:$deliveryType, estimatedDeliveryTime: $estimatedDeliveryTime}';
  }

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    vendorId = json['vendorId'];
    driverId = json['driverId'];
    orderStatus = json['orderStatus'];
    createdAt = json['createdAt'];
    paymentType = json['paymentType'];
    paymentStatus = json['paymentStatus'];
    discount = json['discount'];
    transactionPaymentId = json['transactionPaymentId'];
    totalAmount = json['totalAmount'];
    subTotal = json['subTotal'];
    deliveryInstruction = json['deliveryInstruction'];
    cookingInstruction = json['cookingInstruction'];
    if (json['cartItems'] != null) {
      if (json['cartItems'] is List) {
        items = List<CartModel>.from(json['cartItems'].map((x) => CartModel.fromJson(x)));
      } else {
        items = [];
      }
    } else {
      items = [];
    }
    customerAddress = json['customerAddress'] != null ? AddAddressModel.fromJson(json['customerAddress']) : AddAddressModel();
    vendorAddress = json['vendorAddress'] != null ? AddAddressModel.fromJson(json['vendorAddress']) : AddAddressModel();
    adminCommissionDriver = json['admin_commission_driver'] != null ? AdminCommission.fromJson(json['admin_commission_driver']) : null;
    adminCommissionVendor = json['admin_commission_vendor'] != null ? AdminCommission.fromJson(json['admin_commission_vendor']) : null;
    coupon = json['coupon'] != null ? CouponModel.fromJson(json['coupon']) : null;
    if (json['taxList'] != null) {
      taxList = <TaxModel>[];
      json['taxList'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    if (json['packagingTaxList'] != null) {
      packagingTaxList = <TaxModel>[];
      json['packagingTaxList'].forEach((v) {
        packagingTaxList!.add(TaxModel.fromJson(v));
      });
    }
    if (json['deliveryTaxList'] != null) {
      deliveryTaxList = <TaxModel>[];
      json['deliveryTaxList'].forEach((v) {
        deliveryTaxList!.add(TaxModel.fromJson(v));
      });
    }
    if (json['rejectedDriverReason'] != null) {
      rejectedDriverReason = <RejectDriverReasonModel>[];
      json['rejectedDriverReason'].forEach((v) {
        rejectedDriverReason!.add(RejectDriverReasonModel.fromJson(v));
      });
    }
    foodIsReadyToPickup = json['foodIsReadyToPickup'];
    rejectedDriverIds = json['rejectedDriverIds'] ?? [];
    cancelledBy = json['cancelledBy'];
    deliveryCharge = json['deliveryCharge'];
    cancelledReason = json['cancelledReason'];
    assignedAt = json['assignedAt'];
    deliveryType = json['deliveryType'];
    platFormFee = json['platFormFee'];
    packagingFee = json['packagingFee'];
    deliveryTip = json['deliveryTip'];
    estimatedDeliveryTime = json['estimatedDeliveryTime'] != null ? ETAModel.fromJson(json['estimatedDeliveryTime']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['vendorId'] = vendorId;
    data['driverId'] = driverId;
    data['orderStatus'] = orderStatus;
    data['createdAt'] = createdAt;
    data['paymentType'] = paymentType;
    data['paymentStatus'] = paymentStatus;
    data['discount'] = discount;
    data['transactionPaymentId'] = transactionPaymentId;
    data['totalAmount'] = totalAmount;
    data['subTotal'] = subTotal;
    data['deliveryInstruction'] = deliveryInstruction;
    data['cookingInstruction'] = cookingInstruction;
    if (items != null) {
      data['cartItems'] = items!.map((item) => item.toJson()).toList();
    }
    if (customerAddress != null) {
      data['customerAddress'] = customerAddress!.toJson();
    }
    if (vendorAddress != null) {
      data['vendorAddress'] = vendorAddress!.toJson();
    }
    if (adminCommissionDriver != null) {
      data['admin_commission_driver'] = adminCommissionDriver!.toJson();
    }
    if (adminCommissionVendor != null) {
      data['admin_commission_vendor'] = adminCommissionVendor!.toJson();
    }
    if (rejectedDriverReason != null) {
      data['rejectedDriverReason'] = rejectedDriverReason!.map((v) => v.toJson()).toList();
    }
    if (coupon != null) {
      data['coupon'] = coupon!.toJson();
    }
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }
    if (packagingTaxList != null) {
      data['packagingTaxList'] = packagingTaxList!.map((v) => v.toJson()).toList();
    }
    if (deliveryTaxList != null) {
      data['deliveryTaxList'] = deliveryTaxList!.map((v) => v.toJson()).toList();
    }
    data['rejectedDriverIds'] = rejectedDriverIds;
    data['foodIsReadyToPickup'] = foodIsReadyToPickup;
    data['cancelledBy'] = cancelledBy;
    data['deliveryCharge'] = deliveryCharge;
    data['cancelledReason'] = cancelledReason;
    data['assignedAt'] = assignedAt;
    data['deliveryType'] = deliveryType;
    data['platFormFee'] = platFormFee;
    data['packagingFee'] = packagingFee;
    data['deliveryTip'] = deliveryTip;
    if (estimatedDeliveryTime != null) {
      data['estimatedDeliveryTime'] = estimatedDeliveryTime!.toJson();
    }
    return data;
  }
}

class ETAModel {
  String? prepMinutes;
  String? driverToVendorMinutes;
  String? vendorToCustomerMinutes;
  String? totalMinutes;
  Timestamp? estimatedDeliveryAt;
  Timestamp? lastUpdated;

  ETAModel({this.prepMinutes, this.driverToVendorMinutes, this.vendorToCustomerMinutes, this.totalMinutes, this.estimatedDeliveryAt, this.lastUpdated});

  ETAModel.fromJson(Map<String, dynamic> json) {
    prepMinutes = json['prepMinutes'];
    driverToVendorMinutes = json['driverToVendorMinutes'];
    vendorToCustomerMinutes = json['vendorToCustomerMinutes'];
    totalMinutes = json['totalMinutes'];
    estimatedDeliveryAt = json['estimatedDeliveryAt'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prepMinutes'] = prepMinutes;
    data['driverToVendorMinutes'] = driverToVendorMinutes;
    data['vendorToCustomerMinutes'] = vendorToCustomerMinutes;
    data['totalMinutes'] = totalMinutes;
    data['estimatedDeliveryAt'] = estimatedDeliveryAt;
    data['lastUpdated'] = lastUpdated;
    return data;
  }
}
