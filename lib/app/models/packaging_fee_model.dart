class PackagingFeeModel {
  String? price;
  bool? active;

  PackagingFeeModel({this.price, this.active});

  PackagingFeeModel.fromJson(Map<String, dynamic> json) {
    price = json['price'] ?? '0.0';
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['active'] = active;
    return data;
  }
}
