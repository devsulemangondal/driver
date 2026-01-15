// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, strict_top_level_inference

import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/utils/validate_mobile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'global_widgets.dart';

class TextFieldWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final validator;
  final String? icon;
  bool? obscureText = false;
  Color? color;
  final int? line;
  final TextEditingController controller;
  final Function() onPress;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enable;
  final bool? enabled;
  final bool? readOnly;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldWidget({
    super.key,
    this.validator,
    this.enable,
    this.icon,
    this.prefix,
    this.suffix,
    this.obscureText,
    this.title,
    required this.hintText,
    required this.controller,
    required this.onPress,
    this.enabled,
    this.readOnly,
    this.color,
    this.line,
    this.onChanged,
    this.textInputType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: validator ?? (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
            keyboardType: textInputType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            textAlign: TextAlign.start,
            enabled: enabled,
            obscureText: obscureText ?? false,
            readOnly: readOnly ?? false,
            maxLines: line ?? 1,
            textAlignVertical: TextAlignVertical.top,
            onChanged: onChanged,
            style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular, fontSize: 14),
            decoration: prefix != null
                ? InputDecoration(
                    errorStyle: const TextStyle(fontFamily: FontFamily.regular),
                    isDense: true,
                    filled: true,
                    enabled: enable ?? true,
                    fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    prefix: Padding(
                      padding: EdgeInsets.only(
                        right: 12,
                      ),
                      child: prefix!,
                    ),
                    suffixIcon: Padding(padding: EdgeInsets.all(suffix != null ? 12 : 0), child: suffix),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.primary300 : AppThemeData.grey400, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppThemeData.danger300, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppThemeData.primary300, width: 1),
                    ),
                    hintText: hintText.tr,
                    labelText: title!.tr,
                    labelStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular),
                    hintStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600, fontFamily: FontFamily.regular))
                : InputDecoration(
                    errorStyle: const TextStyle(fontFamily: FontFamily.regular),
                    isDense: true,
                    filled: true,
                    enabled: enable ?? true,
                    fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    suffixIcon: Padding(padding: EdgeInsets.all(suffix != null ? 12 : 0), child: suffix),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.primary300 : AppThemeData.grey400, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppThemeData.danger300, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppThemeData.primary300, width: 1),
                    ),
                    hintText: hintText.tr,
                    labelText: title!.tr,
                    labelStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular),
                    hintStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600, fontFamily: FontFamily.regular)),
          ),
        ],
      ),
    );
  }
}

class MobileNumberTextField extends StatelessWidget {
  final String title;
  String countryCode = "";
  final TextEditingController controller;
  final Function() onPress;
  final bool? enabled;
  final bool? readOnly;

  MobileNumberTextField({super.key, required this.controller, required this.countryCode, required this.onPress, required this.title, this.enabled, this.readOnly});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            validator: (value) => validateMobile(value, countryCode),
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            ],
            controller: controller,
            textAlign: TextAlign.start,
            readOnly: readOnly ?? false,
            style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular, fontSize: 14),
            decoration: InputDecoration(
                errorStyle: const TextStyle(color: Colors.red),
                isDense: true,
                filled: true,
                enabled: enabled ?? true,
                fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CountryCodePicker(
                      searchStyle: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900, fontFamily: FontFamily.regular),
                      showFlag: true,
                      onChanged: (value) {
                        countryCode = value.dialCode.toString();
                      },
                      dialogTextStyle: TextStyle(fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900),
                      dialogBackgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      initialSelection: countryCode,
                      comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      flagDecoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                      textStyle: TextStyle(fontSize: 15, color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700, fontFamily: FontFamily.regular),
                    ),
                    Text(
                      "|",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: FontFamily.light,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                      ),
                    ),
                    spaceW(width: 16),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppThemeData.danger300, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppThemeData.primary300, width: 1),
                ),
                labelText: "Phone Number".tr,
                labelStyle: TextStyle(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular),
                hintText: "Enter Phone Number".tr,
                hintStyle: TextStyle(fontSize: 15, color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, fontFamily: FontFamily.regular)),
          ),
        ],
      ),
    );
  }
}
