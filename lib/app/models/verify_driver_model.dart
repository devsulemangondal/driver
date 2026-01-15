// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/verify_document_model.dart';

class VerifyDriverModel {
  Timestamp? createAt;
  String? driverEmail;
  String? driverId;
  String? driverName;
  List<VerifyDocumentModel>? verifyDocument;

  VerifyDriverModel({
    this.createAt,
    this.driverEmail,
    this.driverId,
    this.driverName,
    this.verifyDocument,
  });


  @override
  String toString() {
    return 'VerifyDriverModel{createAt: $createAt, driverEmail: $driverEmail, driverId: $driverId, driverName: $driverName, verifyDocument: $verifyDocument}';
  }

  factory VerifyDriverModel.fromRawJson(String str) => VerifyDriverModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VerifyDriverModel.fromJson(Map<String, dynamic> json) => VerifyDriverModel(
        createAt: json["createAt"],
        driverEmail: json["driverEmail"],
        driverId: json["driverId"],
        driverName: json["driverName"],
        verifyDocument: List<VerifyDocumentModel>.from(json["verifyDocument"].map((x) => VerifyDocumentModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "createAt": createAt,
        "driverEmail": driverEmail,
        "driverId": driverId,
        "driverName": driverName,
        "verifyDocument": verifyDocument == null ? [] : List<dynamic>.from(verifyDocument!.map((x) => x.toJson())),
      };
}


