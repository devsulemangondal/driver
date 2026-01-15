
import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final Widget? progressIndicator;
  final BoxFit? fit;
  final double? borderRadius;
  final Color? color;
  final bool? isProfile;

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    required this.imageUrl,
    this.borderRadius,
    this.errorWidget,
    this.progressIndicator,
    this.color,
    this.isProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: CachedNetworkImage(
        fit: fit ?? BoxFit.cover,
        height: height ?? ScreenSize.height(8, context),
        width: width ?? ScreenSize.width(15, context),
        imageUrl: imageUrl,
        color: color,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            Shimmer.fromColors(
              baseColor: AppThemeData.grey300,
              highlightColor: AppThemeData.grey200,
              child: Container(
                height: height ?? ScreenSize.height(8, context),
                width: width ?? ScreenSize.width(15, context),
                color: AppThemeData.grey300,
              ),
            ),

        errorWidget: (context, url, error) {

          return Container(
            height: height ?? ScreenSize.height(8, context),
            width: width ?? ScreenSize.width(15, context),
            color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey200,
            child: errorWidget ?? Image.asset(
              isProfile! ? Constant.userPlaceHolder : Constant.placeLogo,
              height: height ?? ScreenSize.height(8, context),
              width: width ?? ScreenSize.width(15, context),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
