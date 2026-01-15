// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

Widget placeHolderWidget({String? placeHolderImage, double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment}) {
  return PlaceHolderWidget(
    height: height,
    width: width,
    alignment: alignment ?? Alignment.center,
  );
}

String commonPrice(num price) {
  try {
    var formatter = NumberFormat('#,##,000.00');
    return formatter.format(price);
  } catch (e,stack) {
    developer.log("Error in commonPrice: $e", error: e, stackTrace: stack);
    return price.toString();
  }
}

