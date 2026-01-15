class RejectDriverReasonModel {
  String? reason;
  String? driverId;

  RejectDriverReasonModel({
    this.reason,
    this.driverId
  });

  RejectDriverReasonModel.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = reason;
    data['driverId'] = driverId;

    return data;
  }
}
