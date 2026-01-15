import 'dart:developer';

import 'package:flutter/material.dart';

Widget spaceH({double? height}) => SizedBox(height: height ?? 10.0);

Widget spaceW({double? width}) => SizedBox(width: width ?? 10.0);

void printLog(String data) => log(data.toString());

EdgeInsets paddingEdgeInsets({double horizontal = 16, double vertical = 16}) {
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

Container divider(BuildContext context, {Color? color, double height = 1}) {
  return Container(height: height);
}
