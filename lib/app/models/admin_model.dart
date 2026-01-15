class AdminModel {
  String? id;
  String? name;
  String? email;
  String? image;
  String? contactNumber;
  bool? isDemo;

  AdminModel({this.id, this.name, this.email, this.image, this.contactNumber,  this.isDemo});

  AdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    contactNumber = json['contactNumber'];
    isDemo = json['isDemo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image ?? "";
    data['contactNumber'] = contactNumber ?? "";
    return data;
  }
}
