import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/themes/font_family.dart';
import 'package:flutter/material.dart';


class PriceRowView extends StatelessWidget {
  final String price;
  final String title;
  final Color priceColor;
  final Color titleColor;
  final String? fontFamily;

  const PriceRowView({
    super.key,
    required this.title,
    required this.price,
    required this.priceColor,
    required this.titleColor,
    this.fontFamily = FontFamily.regular,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            child: TextCustom(
              title: title,
              fontSize: 14,
              textAlign: TextAlign.start,
              fontFamily: fontFamily,
              color: titleColor,
            ),
          ),
        ),
        SizedBox(
          child: TextCustom(
            title: price,
            fontSize: 14,
            fontFamily: fontFamily,
            color: priceColor,
          ),
        ),
      ],
    );
  }
}
