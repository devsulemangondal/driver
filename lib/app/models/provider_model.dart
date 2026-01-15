// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/location_lat_lng.dart';

class ProviderModel {
  String? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? userType;
  bool? active;
  bool? isDocumentVerify;
  String? password;
  String? profileImage;
  String? fcmToken;
  String? address;
  String? walletAmount;
  Timestamp? createdAt;
  LocationLatLng? location;

  ProviderModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.userName,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.userType,
      this.active,
      this.password,
      this.profileImage,
      this.fcmToken,
      this.address,
      this.location,
      this.walletAmount,
        this.isDocumentVerify,
        this.createdAt});

  ProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userName = json['userName'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    userType = json['userType'];
    active = json['active'];
    password = json['password'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    address = json['address'];
    createdAt = json['createdAt'];
    walletAmount = json['walletAmount'];
    isDocumentVerify = json['isDocumentVerify'] ?? false;
    location = json['location'] != null ? LocationLatLng.fromJson(json['location']) : LocationLatLng();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? "";
    data['firstName'] = firstName ?? "";
    data['lastName'] = lastName ?? "";
    data['userName'] = userName ?? "";
    data['email'] = email ?? "";
    data['countryCode'] = countryCode ?? "";
    data['phoneNumber'] = phoneNumber ?? "";
    data['userType'] = userType ?? "";
    data['active'] = active ?? "";
    data['password'] = password ?? "";
    data['profileImage'] = profileImage ?? "";
    data['fcmToken'] = fcmToken ?? "";
    data['address'] = address ?? "";
    data['walletAmount'] = walletAmount ?? "";
    data['isDocumentVerify'] = isDocumentVerify;
    data['createdAt'] = createdAt ?? Timestamp.now();
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}
