// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/document_model.dart';

class OwnerModel {
  String? id;
  String? vendorId;
  String? firstName;
  String? lastName;
  String? slug;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? userType;
  String? loginType;
  bool? active;
  bool? isOpen;
  String? profileImage;
  String? fcmToken;
  String? walletAmount;
  Timestamp? createdAt;
  bool? isVerified;
  List<OwnerVerifyDocumentModel>? verifyDocument;
  List<dynamic>? searchNameKeywords;
  List<dynamic>? searchEmailKeywords;

  @override
  String toString() {
    return 'OwnerModel{id: $id, vendorId: $vendorId, firstName: $firstName, lastName: $lastName, slug: $slug, email: $email, countryCode: $countryCode, phoneNumber: $phoneNumber, userType: $userType, loginType: $loginType, active: $active, isOpen: $isOpen, profileImage: $profileImage, fcmToken: $fcmToken, walletAmount: $walletAmount, createdAt: $createdAt,  verifyDocument: $verifyDocument}';
  }

  String fullNameString() {
    return '$firstName $lastName';
  }

  OwnerModel({
    this.id,
    this.vendorId,
    this.firstName,
    this.lastName,
    this.slug,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.userType,
    this.loginType,
    this.active,
    this.isVerified,
    this.isOpen,
    this.profileImage,
    this.fcmToken,
    this.walletAmount,
    this.createdAt,
    this.verifyDocument,
    this.searchNameKeywords,
    this.searchEmailKeywords,
  });

  OwnerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendorId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    slug = json['slug'];
    email = json['email'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    userType = json['userType'];
    loginType = json['loginType'];
    active = json['active'];
    isOpen = json['isOpen'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    isVerified = json['isVerified'] ?? false;
    walletAmount = json['walletAmount'] ?? "0.0";
    searchNameKeywords = json['searchNameKeywords'] ?? [];
    searchEmailKeywords = json['searchEmailKeywords'] ?? [];
    if (json['verifyDocument'] != null) {
      verifyDocument = <OwnerVerifyDocumentModel>[];
      json['verifyDocument'].forEach((v) {
        verifyDocument!.add(OwnerVerifyDocumentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? "";
    data['vendorId'] = vendorId ?? "";
    data['firstName'] = firstName ?? "";
    data['lastName'] = lastName ?? "";
    data['slug'] = slug ?? "";
    data['email'] = email ?? "";
    data['countryCode'] = countryCode ?? "";
    data['phoneNumber'] = phoneNumber ?? "";
    data['userType'] = userType ?? "";
    data['loginType'] = loginType ?? "";
    data['active'] = active ?? false;
    data['isOpen'] = isOpen ?? false;
    data['profileImage'] = profileImage ?? "";
    data['fcmToken'] = fcmToken ?? "";
    data['walletAmount'] = walletAmount;
    data['isVerified'] = isVerified;
    data['createdAt'] = createdAt ?? Timestamp.now();
    data['searchNameKeywords'] = searchNameKeywords;
    data['searchEmailKeywords'] = searchEmailKeywords;
    if (verifyDocument != null) {
      data['verifyDocument'] = verifyDocument!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
