class SubCategoryModel {
  String? id;
  String? categoryId;
  String? subCategoryName;

  SubCategoryModel({this.id, this.categoryId, this.subCategoryName});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    subCategoryName = json['subCategoryName'];
  }

  @override
  String toString() {
    return 'SubCategoryModel{id: $id, categoryId: $categoryId, subCategoryName: $subCategoryName}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['categoryId'] = categoryId;
    data['subCategoryName'] = subCategoryName;
    return data;
  }
}
