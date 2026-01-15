class CategoryModel {
  String? id;
  String? categoryName;
  String? image;
  bool? active;


  CategoryModel({this.id, this.categoryName, this.active, this.image});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    image = json['image'];
    active = json['active'];
  }

  @override
  String toString() {
    return 'CategoryModel{id: $id, categoryName: $categoryName, image: $image, active: $active}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryName'] = categoryName;
    data['image'] = image;
    data['active'] = active;
    return data;
  }
}
