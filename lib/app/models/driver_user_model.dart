// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/location_lat_lng.dart';

import 'positions_model.dart';

class DriverUserModel {
  String? driverId;
  String? firstName;
  String? lastName;
  String? slug;
  String? email;
  String? password;
  String? countryCode;
  String? phoneNumber;
  String? userType;
  String? loginType;
  bool? active;
  bool? isOnline;
  bool? isVerified;
  String? profileImage;
  String? fcmToken;
  String? walletAmount;
  String? status;
  String? orderId;
  String? vendorId;
  Timestamp? createdAt;
  LocationLatLng? location;
  Positions? position;
  DriverVehicleDetails? driverVehicleDetails;
  dynamic rotation;
  String? reviewSum;
  String? reviewCount;
  List<dynamic>? searchNameKeywords;
  List<dynamic>? searchEmailKeywords;

  String fullNameString() {
    return '$firstName $lastName';
  }

  DriverUserModel({
    this.driverId,
    this.firstName,
    this.lastName,
    this.slug,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.userType,
    this.loginType,
    this.active,
    this.isOnline,
    this.isVerified,
    this.profileImage,
    this.fcmToken,
    this.walletAmount,
    this.createdAt,
    this.location,
    this.position,
    this.driverVehicleDetails,
    this.status,
    this.orderId,
    this.rotation,
    this.reviewSum,
    this.reviewCount,
    this.vendorId,
    this.searchNameKeywords,
    this.searchEmailKeywords,
  });

  @override
  String toString() {
    return 'DriverUserModel{driverId: $driverId,vendorId: $vendorId firstName: $firstName, lastName: $lastName, slug: $slug, email: $email, countryCode: $countryCode, phoneNumber: $phoneNumber, userType: $userType, loginType: $loginType, active: $active, isOnline: $isOnline, isVerified: $isVerified, profileImage: $profileImage, fcmToken: $fcmToken, walletAmount: $walletAmount, createdAt: $createdAt, location: $location, position: $position, driverVehicleDetails: $driverVehicleDetails, rotation: $rotation, reviewSum: $reviewSum, reviewCount: $reviewCount, searchNameKeywords: $searchNameKeywords, searchEmailKeywords: $searchEmailKeywords}';
  }

  DriverUserModel.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    vendorId = json['vendorId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    slug = json['slug'];
    email = json['email'];
    password = json['password'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    userType = json['userType'];
    loginType = json['loginType'];
    active = json['active'];
    isOnline = json['isOnline'];
    isVerified = json['isVerified'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    walletAmount = json['walletAmount'] ?? "0.0";
    driverVehicleDetails = json['driverVehicleDetails'] != null ? DriverVehicleDetails.fromJson(json["driverVehicleDetails"]) : null;
    location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : LocationLatLng();
    position = json['position'] != null ? Positions.fromJson(json['position']) : Positions();
    rotation = json['rotation'];
    status = json['status'];
    orderId = json['orderId'];
    reviewSum = json['reviewSum'] ?? "0.0";
    reviewCount = json['reviewCount'] ?? "0.0";
    searchNameKeywords = json['searchNameKeywords'] ?? [];
    searchEmailKeywords = json['searchEmailKeywords'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['driverId'] = driverId;
    data['vendorId'] = vendorId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['slug'] = slug;
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['phoneNumber'] = phoneNumber;
    data['userType'] = userType;
    data['loginType'] = loginType;
    data['active'] = active ?? false;
    data['isOnline'] = isOnline ?? false;
    data['isVerified'] = isVerified ?? false;
    data['profileImage'] = profileImage;
    data['fcmToken'] = fcmToken;
    data['walletAmount'] = walletAmount;
    data['createdAt'] = createdAt ?? Timestamp.now();
    data['status'] = status;
    data['orderId'] = orderId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (driverVehicleDetails != null) {
      data["driverVehicleDetails"] = driverVehicleDetails!.toJson();
    }
    if (position != null) {
      data['position'] = position!.toJson();
    }
    data['rotation'] = rotation;
    data['reviewSum'] = reviewSum;
    data['reviewCount'] = reviewCount;
    data['searchNameKeywords'] = searchNameKeywords;
    data['searchEmailKeywords'] = searchEmailKeywords;
    return data;
  }
}

class DriverVehicleDetails {
  String? vehicleTypeName;
  String? vehicleImage;
  String? modelName;
  String? vehicleNumber;
  bool? isVerified;

  DriverVehicleDetails({
    this.vehicleTypeName,
    this.vehicleImage,
    this.modelName,
    this.vehicleNumber,
    this.isVerified,
  });

  factory DriverVehicleDetails.fromRawJson(String str) => DriverVehicleDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DriverVehicleDetails.fromJson(Map<String, dynamic> json) => DriverVehicleDetails(
        vehicleTypeName: json["vehicleTypeName"],
        vehicleImage: json["vehicleImage"],
        modelName: json["modelName"],
        vehicleNumber: json["vehicleNumber"],
        isVerified: json["isVerified"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleTypeName": vehicleTypeName ?? '',
        "vehicleImage": vehicleImage ?? '',
        "modelName": modelName ?? '',
        "vehicleNumber": vehicleNumber ?? '',
        "isVerified": isVerified ?? false,
      };
}
