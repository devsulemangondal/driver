import 'package:driver/app/models/tax_model.dart';

class ExtraChargeModel {
  String? id;
  String? chargeDetail;
  String? extraCharge;

  @override
  String toString() {
    return 'ExtraChargeModel{id: $id, chargeDetail: $chargeDetail, extraCharge: $extraCharge, taxList: $taxList}';
  }

  List<TaxModel>? taxList;

  ExtraChargeModel({this.id, this.chargeDetail, this.taxList, this.extraCharge});

  ExtraChargeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargeDetail = json['chargeDetail'];
    extraCharge = json['extraCharge'] ?? "0";
    if (json['taxList'] != null) {
      taxList = <TaxModel>[];
      json['taxList'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chargeDetail'] = chargeDetail;
    data['extraCharge'] = extraCharge;
    if (taxList != null) {
      data['taxList'] = taxList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
