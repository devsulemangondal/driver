// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN_SCREEN = _Paths.LOGIN_SCREEN;
  static const SPLASH_SCREEN = _Paths.SPLASH_SCREEN;
  static const LANDING_SCREEN = _Paths.LANDING_SCREEN;
  static const NOTIFICATION_SCREEN = _Paths.NOTIFICATION_SCREEN;
  static const EDIT_PROFILE_SCREEN = _Paths.EDIT_PROFILE_SCREEN;
  static const LANGUAGE_SCREEN = _Paths.LANGUAGE_SCREEN;
  static const INTRO_SCREEN = _Paths.INTRO_SCREEN;
  static const HTML_VIEW_SCREEN = _Paths.HTML_VIEW_SCREEN;
  static const UPCOMING_BOOKING_LIST_SCREEN = _Paths.UPCOMING_BOOKING_LIST_SCREEN;
  static const SIGNUP_SCREEN = _Paths.SIGNUP_SCREEN;
  static const ORDERS_SCREEN = _Paths.ORDERS_SCREEN;
  static const ORDERS_DETAILS_SCREEN = _Paths.ORDERS_DETAILS_SCREEN;
  static const ADD_BANK = _Paths.ADD_BANK;
  static const MY_WALLET = _Paths.MY_WALLET;
  static const MY_BANK = _Paths.MY_BANK;
  static const MY_DOCUMENTS = _Paths.MY_DOCUMENTS;
  static const EARNING = _Paths.EARNING;
  static const REVIEW_SCREEN = _Paths.REVIEW_SCREEN;
  static const REFERRAL_SCREEN = _Paths.REFERRAL_SCREEN;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const LOGIN_SCREEN = '/login-screen';
  static const SPLASH_SCREEN = '/splash-screen';
  static const NOTIFICATION_SCREEN = '/notification-screen';
  static const EDIT_PROFILE_SCREEN = '/edit-profile-screen';
  static const LANGUAGE_SCREEN = '/language-screen';
  static const INTRO_SCREEN = '/intro-screen';
  static const HTML_VIEW_SCREEN = '/html-view-screen';
  static const UPCOMING_BOOKING_LIST_SCREEN = '/upcoming-booking-list-screen';
  static const LANDING_SCREEN = '/landing-screen';
  static const SIGNUP_SCREEN = '/signup-screen';
  static const ORDERS_SCREEN = '/orders-screen';
  static const ORDERS_DETAILS_SCREEN = '/orders-details-screen';
  static const ADD_BANK = '/add-bank';
  static const MY_WALLET = '/my-wallet';
  static const MY_BANK = '/my-bank';
  static const MY_DOCUMENTS = '/update-document';
  static const EARNING = '/earning';
  static const REVIEW_SCREEN = '/review-screen';
  static const REFERRAL_SCREEN = '/referral-screen';
}
