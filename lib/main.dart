import 'dart:developer' as developer;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:driver/app/modules/splash_screen/views/splash_screen_view.dart';
import 'package:driver/constant/global_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:driver/firebase_options.dart';
import 'package:driver/services/localization_service.dart';
import 'package:driver/themes/styles.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Preferences.initPref();
  Get.put(GlobalController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final DarkThemeProvider _themeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      _themeProvider.darkTheme =
      await _themeProvider.darkThemePreference.getTheme();
    } catch (e, stack) {
      developer.log("Error loading theme", error: e, stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard globally
        FocusManager.instance.primaryFocus?.unfocus();
      },
      behavior: HitTestBehavior.translucent, // ensures taps pass through
      child: ChangeNotifierProvider(
        create: (_) => _themeProvider,
        child: Consumer<DarkThemeProvider>(
          builder: (context, themeProvider, child) {
            return ScreenUtilInit(
              designSize: const Size(390, 844),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return GetMaterialApp(
                  title: 'Go4Food Driver'.tr,
                  debugShowCheckedModeBanner: false,
                  theme: Styles.themeData(
                    themeProvider.darkTheme == 0
                        ? true
                        : themeProvider.darkTheme == 1
                        ? false
                        : themeProvider.getSystemThem(),
                    context,
                  ),
                  localizationsDelegates: const [
                    CountryLocalizations.delegate,
                  ],
                  locale: LocalizationService.locale,
                  fallbackLocale: LocalizationService.locale,
                  translations: LocalizationService(),
                  builder: (context, child) {
                    return SafeArea(bottom: true, top: false, child: EasyLoading.init()(context, child));
                  },
                  initialRoute: AppPages.initial,
                  getPages: AppPages.routes,
                  // home: GetX<GlobalController>(
                  //   init: GlobalController(),
                  //   builder: (_) => const SplashScreenView(),
                  // ),
                  home: const SplashScreenView(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

