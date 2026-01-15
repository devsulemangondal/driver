// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgImageWidget extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;

  const SvgImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    required this.imagePath,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      height: height,
      width: width,
      colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
