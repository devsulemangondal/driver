class VariationModel {
  String? name;
  List<OptionModel>? optionList;
  bool? inStock;

  VariationModel({this.name,this.optionList , this.inStock});


  @override
  String toString() {
    return 'VariationModel{name: $name, optionList: $optionList, inStock: $inStock}';
  }

  VariationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['optionList'] != null) {
      optionList = <OptionModel>[];
      json['optionList'].forEach((v) {
        optionList!.add(OptionModel.fromJson(v));
      });
    } else {
      optionList = [];
    }
    inStock = json['inStock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (optionList != null) {
      data['optionList'] = optionList!.map((v) => v.toJson()).toList();
    }
    data['inStock'] = inStock;
    return data;
  }
}
class OptionModel {
  String? name;
  String? price;

  OptionModel({this.name, this.price});

  @override
  String toString() {
    return 'OptionModel{name: $name, price: $price}';
  }

  OptionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
