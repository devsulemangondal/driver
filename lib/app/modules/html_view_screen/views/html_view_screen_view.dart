import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../controllers/html_view_screen_controller.dart';

class HtmlViewScreenView extends StatelessWidget {
  const HtmlViewScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HtmlViewScreenController>(
      init: HtmlViewScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(controller.title.toString()),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: HtmlWidget(
                controller.policy.toString(),
                textStyle: DefaultTextStyle.of(context).style,
                key: const Key('uniqueKey'),
              ),
            ),
          ),
        );
      },
    );
  }
}