// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingScreenModel {
  String? id;
  String? title;
  String? description;
  String? lightModeImage;
  String? darkModeImage;
  String? type;
  bool? status;
  Timestamp? createdAt;

  OnboardingScreenModel({this.id, this.title, this.description, this.lightModeImage, this.darkModeImage, this.type, this.status, this.createdAt});

  OnboardingScreenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    lightModeImage = json['lightModeImage'];
    darkModeImage = json['darkModeImage'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['lightModeImage'] = lightModeImage;
    data['darkModeImage'] = darkModeImage;
    data['type'] = type;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
