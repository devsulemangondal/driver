class StatusModel {
  List<Status>? status;

  StatusModel({this.status});

  StatusModel.fromJson(Map<String, dynamic> json) {
    if (json['status'] != null) {
      status = <Status>[];
      json['status'].forEach((v) {
        status!.add(Status.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (status != null) {
      data['status'] = status!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Status {
  String? name;
  String? flag;

  Status({this.name, this.flag});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['flag'] = flag;
    return data;
  }
}
