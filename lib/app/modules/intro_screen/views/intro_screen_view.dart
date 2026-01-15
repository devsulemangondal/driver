import 'package:driver/app/models/onboarding_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/intro_screen_controller.dart';
import 'widgets/intro_page_view.dart';

class IntroScreenView extends StatelessWidget {
  const IntroScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: IntroScreenController(),
        builder: (controller) {
          return Obx(
            () =>  Scaffold(
              backgroundColor: Colors.transparent,
              body: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.onboardingList.length,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  controller.currentPage.value = index;
                },
                itemBuilder: (context, index) {
                  OnboardingScreenModel item = controller.onboardingList[index];
                  return IntroScreenPage(
                    title: item.title!,
                    body: item.description!,
                    textColor: index == 0
                        ? AppThemeData.danger300
                        : index == 1
                            ? AppThemeData.primary300
                            : AppThemeData.info300,
                    imageDarkMode: item.darkModeImage!,
                    imageLightMode: item.lightModeImage!,
                  );
                },
              ),
            ),
          );
        });
  }
}
