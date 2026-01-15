// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/addons_model.dart';
import 'package:driver/app/models/category_model.dart';
import 'package:driver/app/models/sub_category_model.dart';
import 'package:driver/app/models/variation_model.dart';

class ProductModel {
  String? id;
  String? vendorId;
  String? productName;
  String? categoryId;
  CategoryModel? categoryModel;
  String? subCategoryId;
  SubCategoryModel? subCategoryModel;
  String? foodType;
  String? discountType;
  String? maxQuantity;
  bool? status;
  bool? inStock;
  String? price;
  String? discount;
  String? description;
  Timestamp? createAt;
  String? productImage;
  List<AddonsModel>? addonsList;
  List<VariationModel>? variationList;
  List<dynamic>? likedUser;
  String? itemTag;
  String? reviewSum;
  String? reviewCount;
  List<dynamic>? searchKeywords;

  ProductModel({
    this.id,
    this.vendorId,
    this.productName,
    this.categoryId,
    this.categoryModel,
    this.subCategoryId,
    this.subCategoryModel,
    this.foodType,
    this.discountType,
    this.maxQuantity,
    this.status,
    this.inStock,
    this.price,
    this.discount,
    this.description,
    this.createAt,
    this.reviewSum,
    this.reviewCount,
    this.likedUser,
    this.itemTag,
    this.productImage,
    this.addonsList,
    this.variationList,
    this.searchKeywords,
  });

  @override
  String toString() {
    return 'ProductModel{id: $id, vendorId: $vendorId, productName: $productName, categoryId: $categoryId, categoryModel: $categoryModel, subCategoryId: $subCategoryId, subCategoryModel: $subCategoryModel, foodType: $foodType, discountType: $discountType, status: $status, inStock: $inStock, price: $price, discount: $discount, description: $description, createAt: $createAt, productImage: $productImage, addonsList: $addonsList, variationList: $variationList, likedUser: $likedUser, tagsList: $itemTag, reviewSum: $reviewSum, reviewCount: $reviewCount,searchKeywords:$searchKeywords}';
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    vendorId = json['vendorId'];
    productName = json['productName'] ?? "";
    categoryId = json['categoryId'] ?? "";
    subCategoryId = json['subCategoryId'] ?? "";
    foodType = json['foodType'] ?? "";
    discountType = json['discountType'] ?? "";
    maxQuantity = json['maxQuantity'] ?? "";
    status = json['status'];
    inStock = json['inStock'];
    price = json['price'];
    discount = json['discount'] ?? "";
    description = json['description'] ?? "";
    createAt = json['createAt'] ?? "";
    reviewSum = json['reviewSum'] ?? "0.0";
    reviewCount = json['reviewCount'] ?? "0.0";
    productImage = json['productImage'] ?? "";
    if (json['addonsList'] != null) {
      addonsList = <AddonsModel>[];
      json['addonsList'].forEach((v) {
        addonsList!.add(AddonsModel.fromJson(v));
      });
    } else {
      addonsList = [];
    }
    if (json['variationList'] != null) {
      variationList = <VariationModel>[];
      json['variationList'].forEach((v) {
        variationList!.add(VariationModel.fromJson(v));
      });
    } else {
      addonsList = [];
    }
    likedUser = json['likedUser'] ?? [];
    searchKeywords = json['searchKeywords'] ?? [];
    itemTag = json['itemTag'];
    subCategoryModel = json['subCategoryModel'] != null ? SubCategoryModel.fromJson(json['subCategoryModel']) : SubCategoryModel();
    categoryModel = json['categoryModel'] != null ? CategoryModel.fromJson(json['categoryModel']) : CategoryModel();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendorId'] = vendorId;
    data['productName'] = productName;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    data['foodType'] = foodType;
    data['discountType'] = discountType;
    data['maxQuantity'] = maxQuantity;
    data['status'] = status;
    data['inStock'] = inStock;
    data['price'] = price;
    data['discount'] = discount;
    data['description'] = description;
    data['createAt'] = createAt;
    data['productImage'] = productImage;
    if (addonsList != null) {
      data['addonsList'] = addonsList!.map((v) => v.toJson()).toList();
    }
    if (variationList != null) {
      data['variationList'] = variationList!.map((v) => v.toJson()).toList();
    }

    data['likedUser'] = likedUser;
    data['itemTag'] = itemTag;
    data['reviewSum'] = reviewSum;
    data['reviewCount'] = reviewCount;
    data['searchKeywords'] = searchKeywords;
    if (subCategoryModel != null) {
      data['subCategoryModel'] = subCategoryModel!.toJson();
    }
    if (categoryModel != null) {
      data['categoryModel'] = categoryModel!.toJson();
    }
    return data;
  }
}
