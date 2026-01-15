class IntroScreenModel {
  String? description;
  String? id;
  String? title;
  String? image;

  IntroScreenModel({this.description, this.id, this.image, this.title});

  IntroScreenModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['image'] = image;
    data['title'] = title;
    return data;
  }
}
