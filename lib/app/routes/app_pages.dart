import 'package:driver/app/modules/add_bank/bindings/add_bank_binding.dart';
import 'package:driver/app/modules/add_bank/views/add_bank_view.dart';
import 'package:driver/app/modules/earning/bindings/earnings_binding.dart';
import 'package:driver/app/modules/earning/views/earning_view.dart';
import 'package:driver/app/modules/home_screen/bindings/home_screen_binding.dart';
import 'package:driver/app/modules/home_screen/views/home_screen_view.dart';
import 'package:driver/app/modules/landing_screen/bindings/landing_screen_binding.dart';
import 'package:driver/app/modules/landing_screen/views/landing_screen_view.dart';
import 'package:driver/app/modules/my_bank/bindings/my_bank_binding.dart';
import 'package:driver/app/modules/my_bank/views/my_bank_view.dart';
import 'package:driver/app/modules/my_documents/bindings/my_documents_binding.dart';
import 'package:driver/app/modules/my_documents/views/my_documents_view.dart';
import 'package:driver/app/modules/my_wallet/bindings/my_wallet_binding.dart';
import 'package:driver/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:driver/app/modules/order_details_screen/bindings/orders_details_binding.dart';
import 'package:driver/app/modules/order_details_screen/views/orders_details_screen.dart';
import 'package:driver/app/modules/orders_screen/bindings/orders_screen_binding.dart';
import 'package:driver/app/modules/orders_screen/views/orders_screen_view.dart';
import 'package:driver/app/modules/referral_screen/bindings/referral_screen_binding.dart';
import 'package:driver/app/modules/referral_screen/views/referral_screen_view.dart';
import 'package:driver/app/modules/review_screen/bindings/review_screen_binding.dart';
import 'package:driver/app/modules/review_screen/views/review_screen_view.dart';
import 'package:driver/app/modules/signup_screen/bindings/signup_screen_binding.dart';
import 'package:driver/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:get/get.dart';
import '../modules/edit_profile_screen/bindings/edit_profile_screen_binding.dart';
import '../modules/edit_profile_screen/views/edit_profile_screen_view.dart';
import '../modules/html_view_screen/bindings/html_view_screen_binding.dart';
import '../modules/html_view_screen/views/html_view_screen_view.dart';
import '../modules/intro_screen/bindings/intro_screen_binding.dart';
import '../modules/intro_screen/views/intro_screen_view.dart';
import '../modules/language_screen/bindings/language_screen_binding.dart';
import '../modules/language_screen/views/language_screen_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/notification_screen/bindings/notification_screen_binding.dart';
import '../modules/notification_screen/views/notification_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeScreenView(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SCREEN,
      page: () => const NotificationScreenView(),
      binding: NotificationScreenBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreenView(),
      binding: EditProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE_SCREEN,
      page: () => const LanguageScreenView(),
      binding: LanguageScreenBinding(),
    ),
    GetPage(
      name: _Paths.INTRO_SCREEN,
      page: () => const IntroScreenView(),
      binding: IntroScreenBinding(),
    ),
    GetPage(
      name: _Paths.HTML_VIEW_SCREEN,
      page: () => const HtmlViewScreenView(),
      binding: HtmlViewScreenBinding(),
    ),

    GetPage(
      name: _Paths.LANDING_SCREEN,
      page: () => const LandingScreenView(),
      binding: LandingScreenBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_SCREEN,
      page: () => const SignupScreenView(),
      binding: SignupScreenBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS_SCREEN,
      page: () => const OrdersScreenView(),
      binding: OrdersScreenBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS_DETAILS_SCREEN,
      page: () => const OrdersDetailsScreen(),
      binding: OrdersDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BANK,
      page: () => const AddBankView(),
      binding: AddBankBinding(),
    ),
    GetPage(
      name: _Paths.MY_WALLET,
      page: () => const MyWalletView(),
      binding: MyWalletBinding(),
    ),
    GetPage(
      name: _Paths.MY_BANK,
      page: () => const MyBankView(),
      binding: MyBankBinding(),
    ),
    GetPage(
      name: _Paths.MY_DOCUMENTS,
      page: () => const MyDocumentsView(),
      binding: MyDocumentsBinding(),
    ),
    GetPage(
      name: _Paths.EARNING,
      page: () => const EarningView(),
      binding: EarningBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW_SCREEN,
      page: () => const ReviewScreenView(),
      binding: ReviewScreenBinding(),
    ),
    GetPage(
      name: _Paths.REFERRAL_SCREEN,
      page: () => const ReferralScreenView(),
      binding: ReferralScreenBinding(),
    ),
  ];
}
