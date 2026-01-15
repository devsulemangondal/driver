class DocumentModel {
  String? id;
  String? name;
  String? type;
  bool? active;
  bool? isTwoSide;

  DocumentModel({
    this.id,
    this.name,
    this.type,
    this.active,
    this.isTwoSide,
  });

  DocumentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['title'];
    type = json['type'];
    active = json['active'];
    isTwoSide = json['isTwoSide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = name;
    data['type'] = type;
    data['active'] = active;
    data['isTwoSide'] = isTwoSide;
    return data;
  }
}

class OwnerVerifyDocumentModel {
  String? documentId;
  String? documentImage;
  String? status;
  String? rejectedReason;

  OwnerVerifyDocumentModel({this.documentId, this.documentImage, this.status, this.rejectedReason});

  OwnerVerifyDocumentModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    documentImage = json['documentImage'];
    status = json['status'];
    rejectedReason = json['rejectedReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentId'] = documentId;
    data['documentImage'] = documentImage;
    data['status'] = status;
    data['rejectedReason'] = rejectedReason;
    return data;
  }
}

