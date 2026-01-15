class AddonsModel {
  String? name;
  String? price;
  bool? inStock;

  AddonsModel({this.name, this.price, this.inStock});

  @override
  String toString() {
    return 'AddonsModel{name: $name, price: $price, inStock: $inStock}';
  }

  AddonsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    inStock = json['inStock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['price'] = price;
    data['inStock'] = inStock;
    return data;
  }
}
