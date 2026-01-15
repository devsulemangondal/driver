// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/bank_details_model.dart';

class WithdrawModel {
  String? id;
  String? ownerId;
  String? note;
  String? paymentStatus;
  String? adminNote;
  String? type;
  String? amount;
  String? paymentId;
  Timestamp? createdDate;
  Timestamp? paymentDate;
  BankDetailsModel? bankDetails;

  WithdrawModel({
    this.id,
    this.ownerId,
    this.note,
    this.paymentStatus,
    this.adminNote,
    this.amount,
    this.type,
    this.createdDate,
    this.paymentDate,
    this.paymentId,
    this.bankDetails,
  });

  @override
  String toString() {
    return 'WithdrawModel{id: $id, ownerId: $ownerId, note: $note, paymentStatus: $paymentStatus, adminNote: $adminNote, amount: $amount, createdDate: $createdDate, paymentDate: $paymentDate, bankDetails: $bankDetails}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['note'] = note;
    data['paymentStatus'] = paymentStatus;
    data['adminNote'] = adminNote;
    data['amount'] = amount;
    data['type'] = type;
    data['paymentId'] = paymentId;
    data['createdDate'] = createdDate;
    data['paymentDate'] = paymentDate;

    if (bankDetails != null) {
      data['bank_details'] = bankDetails!.toJson();
    }
    return data;
  }

  WithdrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    note = json['note'];
    paymentStatus = json['paymentStatus'];
    paymentId = json['paymentId'];
    adminNote = json['adminNote'];
    amount = json['amount'];
    type = json['type'];
    createdDate = json['createdDate'];
    paymentDate = json['paymentDate'];
    bankDetails = json['bank_details'] != null ? BankDetailsModel.fromJson(json['bank_details']) : null;
  }
}
