class VerifyDocumentModel {
  String? documentId;
  List<dynamic>? documentImage;
  bool? isVerify;
  bool? isTwoSide;

  VerifyDocumentModel({this.documentId, required this.documentImage, this.isVerify, this.isTwoSide});

  VerifyDocumentModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    documentImage = json["documentImage"] ?? [];
    isVerify = json['isVerify'];
    isTwoSide = json['isTwoSide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['documentId'] = documentId;
    data['documentImage'] = documentImage ?? [];

    data['isVerify'] = isVerify;
    data['isTwoSide'] = isTwoSide;
    return data;
  }
}
