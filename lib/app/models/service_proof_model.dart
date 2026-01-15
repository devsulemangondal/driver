class ServiceProofModel {
  String? title;
  String? description;
  String? id;
  String? bookingId;
  List<dynamic>? image;

  ServiceProofModel({this.title, this.description, this.id, this.bookingId, this.image});

  ServiceProofModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    id = json['id'];
    bookingId = json['bookingId'];
    image = json['image'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['id'] = id;
    data['bookingId'] = bookingId;
    data['image'] = image;
    return data;
  }
}
