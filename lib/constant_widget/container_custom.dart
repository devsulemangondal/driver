import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContainerCustom extends StatelessWidget {
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final Color? borderColor;

  const ContainerCustom({
    super.key,
    this.alignment = Alignment.center,
    this.padding,
    this.margin,
    this.borderColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
        margin: margin ?? paddingEdgeInsets(horizontal: 0, vertical: 8),
        alignment: alignment,
        padding: padding ?? paddingEdgeInsets(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: themeChange.isDarkTheme() ? AppThemeData.darkBackGroundColor : AppThemeData.primaryWhite,
        ),
        child: child);
  }
}

class ContainerCustomSub extends StatelessWidget {
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final Color? borderColor;
  final double? height;
  final double? width;

  const ContainerCustomSub({
    super.key,
    this.alignment = Alignment.center,
    this.padding,
    this.margin,
    this.borderColor,
    this.child,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
        height: height,
        width: width,
        margin: margin ?? paddingEdgeInsets(horizontal: 0, vertical: 0),
        alignment: alignment,
        padding: padding ?? paddingEdgeInsets(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.grey100,
        ),
        child: child);
  }
}
