// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:driver/app/widget/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../themes/app_colors.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final String? placeHolderImage;
  final AlignmentGeometry? alignment;
  final bool usePlaceholderIfUrlEmpty;
  final bool circle;
  final double? radius;
  final Widget? child;

  const CachedImageWidget({
    super.key,
    required this.url,
    required this.height,
    this.width,
    this.fit,
    this.color,
    this.placeHolderImage,
    this.alignment,
    this.radius,
    this.usePlaceholderIfUrlEmpty = true,
    this.circle = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (url.validate().isEmpty) {
      return Container(
        height: height,
        width: width ?? height,
        color: color ?? grey.withOpacity(0.1),
        alignment: alignment,
        child: Stack(
          children: [
            PlaceHolderWidget(
              height: height,
              width: width,
              alignment: alignment ?? Alignment.center,
            ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
            child ?? const Offstage(),
          ],
        ),
      ).cornerRadiusWithClipRRect(radius ?? (radius ?? (circle ? (height / 2) : 0)));
    } else if (url.validate().startsWith('http')) {
      return CachedNetworkImage(
        placeholder: (_, __) {
          return Stack(
            children: [
              placeHolderWidget(
                placeHolderImage: placeHolderImage,
                height: height,
                width: width ?? height,
                fit: fit,
                alignment: alignment,
              ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
              child ?? const Offstage(),
            ],
          );
        },
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Shimmer.fromColors(
              baseColor: AppThemeData.grey300,
              highlightColor: AppThemeData.grey200,
              child: Container(
                height: height,
                width: width ?? ScreenSize.width(15, context),
                color: AppThemeData.grey300,
              ),
            ),
        imageUrl: url,
        height: height,
        width: width ?? height,
        fit: fit,
        color: color,
        alignment: alignment as Alignment? ?? Alignment.center,
        errorWidget: (_, s, d) {
          return Stack(
            children: [
              placeHolderWidget(
                placeHolderImage: placeHolderImage,
                height: height,
                width: width ?? height,
                fit: fit,
                alignment: alignment,
              ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
              child ?? const Offstage(),
            ],
          );
        },
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    } else {
      return Image.asset(
        url,
        height: height,
        width: width ?? height,
        fit: fit,
        color: color,
        alignment: alignment ?? Alignment.center,
        errorBuilder: (_, s, d) {
          return Stack(
            children: [
              placeHolderWidget(
                height: height,
                width: width ?? height,
                fit: fit,
                alignment: alignment,
              ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0)),
              child ?? const Offstage(),
            ],
          );
        },
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    }
  }
}
