// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/app/models/location_lat_lng.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/models/payment_method_model.dart';
import 'package:driver/app/models/vendor_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/order_status.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:driver/app/models/admin_commission.dart';
import 'package:driver/app/models/currency_model.dart';
import 'package:driver/app/models/status_model.dart';
import 'package:driver/app/models/tax_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/preferences.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;

class Constant {
  static DriverUserModel? driverUserModel;
  static VendorModel? vendorModel;
  static CurrencyModel? currencyModel;
  static AdminCommission? adminCommissionDriver;
  static AdminCommission? adminCommissionVendor;
  static StatusModel? statusModel;

  static String mapAPIKey = "";
  static String googleLoginType = 'google';
  static String phoneLoginType = 'phone';
  static String appleLoginType = "apple";
  static String owner = 'owner';
  static String user = 'user';
  static String driver = 'driver';
  static String emailLoginType = 'email';
  static String provider = "Provider";
  static int totalCompleteBookingList = 0;
  static PaymentModel? paymentModel;
  static String? referralAmount = "0.0";
  static String paymentCallbackURL = 'https://elaynetech.com/callback';
  static String minimumAmountToWithdrawal = "0";
  static String minimumAmountToDeposit = "100";
  static String radius = "20";
  static String senderId = "";
  static String jsonFileURL = "";
  static String termsAndConditions = "";
  static String privacyPolicy = "";
  static String aboutApp = "";
  static String supportEmail = "";
  static String phoneNumber = "";
  static String notificationServerKey = "";
  static RxString appName = "".obs;
  static String? appColor;
  static bool? isDriverDocumentVerification;
  static bool isLogin = false;
  static LocationLatLng? currentLocation = LocationLatLng(latitude: 23.0225, longitude: 72.5714);
  static String driverLocationUpdate = "10";
  static String secondsForOrderCancel = "60";
  static RxBool isDriverOnline = false.obs;

  static String? country;

  static const userPlaceHolder1 =
      'https://firebasestorage.googleapis.com/v0/b/goride-1a752.appspot.com/o/placeholderImages%2Fuser-placeholder.jpeg?alt=media&token=34a73d67-ba1d-4fe4-a29f-271d3e3ca115';

  static const userPlaceHolder = 'assets/images/user_placeholder.png';
  static const placeLogo = 'assets/images/place_logo.png';
  static const userProfileUrl =
      'https://s3-alpha-sig.figma.com/img/20d5/da6d/b190e6e3976b2e61bb6266d015024d1e?Expires=1731888000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=SX4deLi0xrmRyzogAhwim9YFeqJgG6VAkJFpQikP1INNWLqPxtTuWYn9QxR2izi8fac653gXC9cvq6WMaKFpn0l2kJn2hVUl-hllV8dT0mxoQ9QW~ScMr3-q4gdgSkTdG2kajM819HPwfcHWPckZ5BCSDog9ahOBdnkSJj~9VgNQtIkK1jOX0HfT527rnCCYBUXmFDHb1Dcx1nCyxFVSYhpaKiuFgfbrxKXkPlzAk6dphr-XXdUSdbBfdzAMwednEBStu9olh7jcMJbKSJrEpyLmJ4Qv7dpBNhM48J2l-vD1C1zZXpajDaQPdB0J7McldtN0xOoNJaCBNU~QZ8KO-w__';

  static const demo = 'https://c8.alamy.com/comp/M4KDT8/handsome-indian-carpenter-or-wood-driver-in-action-isolated-over-white-M4KDT8.jpg';

  static OwnerModel? ownerModel;

  static String getUuid() {
    try {
      return const Uuid().v4();
    } catch (e, stack) {
      developer.log("Error in getUuid", error: e, stackTrace: stack);
      return '';
    }
  }

  static Widget loader() {
    try {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    } catch (e, stack) {
      developer.log("Error in loader", error: e, stackTrace: stack);
      return const Center(
        child: Text('Something went wrong'),
      );
    }
  }

  static String getReferralCode(String firstTwoChar) {
    var rng = math.Random();
    return firstTwoChar + (rng.nextInt(9000) + 1000).toString();
  }

  static int getRandomNumber() {
    try {
      var rng = Random();
      var code = rng.nextInt(900000) + 100000;
      return code;
    } catch (e, stack) {
      developer.log("Error in getRandomNumber", error: e, stackTrace: stack);
      return 100000;
    }
  }

  static String calculateReview({required String? reviewCount, required String? reviewSum}) {
    try {
      if (reviewCount == "0.0" && reviewSum == "0.0") {
        return "0.0";
      }
      double count = double.parse(reviewCount ?? "0");
      double sum = double.parse(reviewSum ?? "0");

      if (count == 0) return "0.0";

      return (sum / count).toStringAsFixed(1);
    } catch (e, stack) {
      developer.log("Error in calculateReview", error: e, stackTrace: stack);
      return "0.0";
    }
  }

  static String? validateEmail(String? value) {
    try {
      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern);

      if (value == null || value.isEmpty) {
        return "Email is Required";
      } else if (!regExp.hasMatch(value)) {
        return "Invalid Email";
      } else {
        return null;
      }
    } catch (e, stack) {
      developer.log("Error in validateEmail", error: e, stackTrace: stack);
      return "Invalid Email";
    }
  }

  static String? validatePassword(String? value) {
    try {
      if (value == null || value.isEmpty || value.length < 6) {
        return "Minimum password length should be 6".tr;
      } else {
        return null;
      }
    } catch (e, stack) {
      developer.log("Error in validatePassword", error: e, stackTrace: stack);
      return "Invalid password".tr;
    }
  }

  static Widget showEmptyView(BuildContext context, {required String message}) {
    try {
      final themeChange = Provider.of<DarkThemeProvider>(context);
      return Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            color: themeChange.isDarkTheme() ? AppThemeData.gallery200 : AppThemeData.gallery800,
          ),
        ),
      );
    } catch (e) {
      return const Center(
        child: Text(
          "Something went wrong",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
  }

  static Future<String> uploadUserImageToFireStorage(File image, String filePath, String fileName) async {
    try {
      Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
      UploadTask uploadTask = upload.putFile(image);
      var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
      return downloadUrl.toString();
    } catch (e, stack) {
      developer.log("Error in uploadUserImageToFireStorage", error: e, stackTrace: stack);
      return '';
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    try {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: width,
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    } catch (e, stack) {
      developer.log("Error in getBytesFromAsset", error: e, stackTrace: stack);
      rethrow;
    }
  }

  static Future<List<String>> uploadServiceImage(List<String> images) async {
    List<String> imageUrls = [];
    try {
      imageUrls = await Future.wait(
        images.map(
          (image) => uploadUserImageToFireStorage(
            File(image),
            "serviceImages/${FireStoreUtils.getCurrentUid()}",
            File(image).path.split("/").last,
          ),
        ),
      );
    } catch (e, stack) {
      developer.log("Error in uploadServiceImage", error: e, stackTrace: stack);
    }
    return imageUrls;
  }

  static String fullNameString(String? firstName, String? lastName) {
    try {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } catch (e, stack) {
      developer.log("Error Full Name", error: e, stackTrace: stack);
      return '';
    }
  }

  static String maskMobileNumber({String? mobileNumber, String? countryCode}) {
    try {
      if (mobileNumber == null || countryCode == null) {
        return "";
      }

      if (mobileNumber.length < 4) {
        return "$countryCode ${'*' * mobileNumber.length}";
      }

      String firstTwoDigits = mobileNumber.substring(0, 2);
      String lastTwoDigits = mobileNumber.substring(mobileNumber.length - 2);
      String maskedNumber = firstTwoDigits + 'x' * (mobileNumber.length - 4) + lastTwoDigits;

      return "$countryCode $maskedNumber";
    } catch (e, stack) {
      developer.log("Error in maskMobileNumber", error: e, stackTrace: stack);
      return "";
    }
  }

  static bool hasValidUrl(String value) {
    try {
      if (value.isEmpty) return false;

      String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';
      RegExp regExp = RegExp(pattern);

      return regExp.hasMatch(value);
    } catch (e, stack) {
      developer.log("Error in hasValidUrl", error: e, stackTrace: stack);
      return false;
    }
  }

  static Color getRatingBarColor(int rating) {
    try {
      if (rating == 1 || rating == 2) {
        return AppThemeData.ratingBarColor;
      } else if (rating == 3) {
        return const Color(0xFFff6200);
      } else if (rating == 4 || rating == 5) {
        return const Color(0xFF73CB92);
      } else {
        return AppThemeData.ratingBarColor;
      }
    } catch (e, stack) {
      developer.log("Error in getRatingBarColor", error: e, stackTrace: stack);
      return AppThemeData.ratingBarColor;
    }
  }

  static String amountShow({required String? amount}) {
    try {
      double parsedAmount = double.parse(amount ?? "0.0");
      int decimalDigits = Constant.currencyModel?.decimalDigits ?? 2;
      String symbol = Constant.currencyModel?.symbol ?? '';
      bool symbolAtRight = Constant.currencyModel?.symbolAtRight ?? false;

      String formattedAmount = parsedAmount.toStringAsFixed(decimalDigits);

      return symbolAtRight ? "$formattedAmount $symbol" : "$symbol$formattedAmount";
    } catch (e, stack) {
      developer.log("Error in amountShow", error: e, stackTrace: stack);
      return "";
    }
  }

  static double calculateTax({String? amount, TaxModel? taxModel}) {
    double taxAmount = 0.0;

    try {
      if (taxModel != null && taxModel.active == true) {
        if (taxModel.isFix == true) {
          taxAmount = double.parse(taxModel.value.toString());
        } else {
          double parsedAmount = double.parse(amount ?? "0.0");
          double taxRate = double.parse(taxModel.value?.toString() ?? "0.0");
          taxAmount = (parsedAmount * taxRate) / 100;
        }
      }
    } catch (e, stack) {
      developer.log("Error in calculateTax", error: e, stackTrace: stack);
    }

    return taxAmount;
  }

  static String calculateDistanceInKm(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    try {
      double distanceInMeters = Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
      double distanceInKm = distanceInMeters / 1000;
      return distanceInKm.toStringAsFixed(2);
    } catch (e, stack) {
      developer.log("Error in calculateDistanceInKm", error: e, stackTrace: stack);
      return "0.00";
    }
  }

  static double calculateAdminCommission({
    String? amount,
    AdminCommission? adminCommission,
  }) {
    double commissionAmount = 0.0;
    try {
      if (adminCommission != null && adminCommission.active == true) {
        if (adminCommission.isFix == true) {
          commissionAmount = double.parse(adminCommission.value.toString());
        } else {
          double parsedAmount = double.parse(amount ?? "0.0");
          double commissionRate = double.parse(adminCommission.value?.toString() ?? "0.0");
          commissionAmount = (parsedAmount * commissionRate) / 100;
        }
      }
    } catch (e, stack) {
      developer.log("Error in calculateAdminCommission", error: e, stackTrace: stack);
    }

    return commissionAmount;
  }

  static String showId(String id) {
    try {
      return '#${id.substring(0, 4)}';
    } catch (e, stack) {
      developer.log("Error in showId", error: e, stackTrace: stack);
      return '#0000';
    }
  }

  static String timestampToDate(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('dd MMMM yyyy').format(dateTime);
    } catch (e, stack) {
      developer.log("Error in timestampToDate", error: e, stackTrace: stack);
      return '';
    }
  }

  static String timestampToTime(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('HH:mm aa').format(dateTime);
    } catch (e, stack) {
      developer.log("Error in timestampToTime", error: e, stackTrace: stack);
      return '';
    }
  }

  static String timestampToDateTime(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('dd MMMM yyyy \'at\' hh:mm a').format(dateTime);
    } catch (e, stack) {
      developer.log("Error in timestampToDateTime", error: e, stackTrace: stack);
      return '';
    }
  }

  static String timestampToTime12Hour(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      return DateFormat.jm().format(dateTime);
    } catch (e, stack) {
      developer.log("Error in timestampToTime12Hour", error: e, stackTrace: stack);
      return '';
    }
  }

  Future<void> commonLaunchUrl(String url, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
    try {
      await launchUrl(Uri.parse(url), mode: launchMode);
    } catch (e, stack) {
      developer.log("Error in commonLaunchUrl", error: e, stackTrace: stack);
      ShowToastDialog.showToast('Invalid URL: $url');
    }
  }

  void launchCall(String? url) {
    try {
      if (url.validate().isNotEmpty) {
        final telUrl = isIOS ? 'tel://${url!}' : 'tel:${url!}';
        commonLaunchUrl(telUrl, launchMode: LaunchMode.externalApplication);
      } else {
        ShowToastDialog.showToast('Phone number is empty or invalid.');
      }
    } catch (e, stack) {
      developer.log("Error in launchCall", error: e, stackTrace: stack);
      ShowToastDialog.showToast('Unable to initiate the call.');
    }
  }

  void launchMail(String? url) {
    try {
      if (url.validate().isNotEmpty) {
        commonLaunchUrl('mailto:${url!}', launchMode: LaunchMode.externalApplication);
      } else {
        ShowToastDialog.showToast('Email address is empty or invalid.');
      }
    } catch (e, stack) {
      developer.log("Error in launchMail", error: e, stackTrace: stack);
      ShowToastDialog.showToast('Unable to open the mail app.');
    }
  }

  static LanguageModel getLanguage() {
    try {
      final String user = Preferences.getString(Preferences.languageCodeKey);
      Map<String, dynamic> userMap = jsonDecode(user);
      return LanguageModel.fromJson(userMap);
    } catch (e, stack) {
      developer.log("Error in getLanguage", error: e, stackTrace: stack);
      return LanguageModel();
    }
  }

  static String timeAgo(Timestamp timestamp) {
    try {
      Duration diff = DateTime.now().difference(timestamp.toDate());
      if (diff.inDays > 365) {
        int years = (diff.inDays / 365).floor();
        return "$years ${years == 1 ? "year" : "years"} ago";
      }
      if (diff.inDays > 30) {
        int months = (diff.inDays / 30).floor();
        return "$months ${months == 1 ? "month" : "months"} ago";
      }
      if (diff.inDays > 7) {
        int weeks = (diff.inDays / 7).floor();
        return "$weeks ${weeks == 1 ? "week" : "weeks"} ago";
      }
      if (diff.inDays > 0) {
        return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
      }
      if (diff.inHours > 0) {
        return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
      }
      if (diff.inMinutes > 0) {
        return "${diff.inMinutes} min ago";
      }
      return "just now";
    } catch (e, stack) {
      developer.log("Error in timeAgo", error: e, stackTrace: stack);
      return "unknown time";
    }
  }

  static InputDecoration DefaultInputDecoration(BuildContext context) {
    try {
      final themeChange = Provider.of<DarkThemeProvider>(context);
      bool isDark = themeChange.isDarkTheme();

      return InputDecoration(
        iconColor: AppThemeData.primary500,
        isDense: true,
        filled: true,
        fillColor: isDark ? AppThemeData.grey1000 : AppThemeData.grey50,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: isDark ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: isDark ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: isDark ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: isDark ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          borderSide: BorderSide(
            color: isDark ? AppThemeData.grey900 : AppThemeData.grey50,
          ),
        ),
        hintText: "Select time",
        hintStyle: TextStyle(
          fontSize: 16,
          color: isDark ? AppThemeData.grey50 : AppThemeData.grey900,
          fontWeight: FontWeight.w500,
        ),
      );
    } catch (e, stack) {
      developer.log("Error in DefaultInputDecoration", error: e, stackTrace: stack);
      return const InputDecoration(
        hintText: "Select time",
        border: OutlineInputBorder(),
      );
    }
  }

  static List<String> generateKeywords(String text) {
    if (text.isEmpty) return [];

    final lower = text.toLowerCase().trim();
    final List<String> keywords = [];

    final words = lower.split(' ').where((w) => w.isNotEmpty).toList();

    for (int i = 0; i < words.length; i++) {
      for (int j = i + 1; j <= words.length; j++) {
        keywords.add(words.sublist(i, j).join(' '));
      }
    }

    for (var word in words) {
      for (int i = 1; i <= word.length; i++) {
        keywords.add(word.substring(0, i));
      }
    }

    for (int i = 1; i <= lower.length; i++) {
      keywords.add(lower.substring(0, i));
    }

    return keywords.toSet().toList();
  }

  static double haversineDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180.0;
    final dLon = (lon2 - lon1) * pi / 180.0;
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * pi / 180.0) * cos(lat2 * pi / 180.0) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static int estimateMinutesByDistanceKm(double km, {double avgKmph = 30.0}) {
    if (km <= 0 || km.isNaN) return 0;
    final hours = km / avgKmph;
    return max(1, (hours * 60).round());
  }

  static int parsePreparationTime(dynamic prep) {
    if (prep == null) return 0;
    final s = prep.toString().trim();
    final m = RegExp(r'\d+').firstMatch(s)?.group(0);
    if (m == null) return 0;
    return int.tryParse(m) ?? 0;
  }

  static Future<void> updateEtaFromDriverLocation({required String driverId, required double driverLat, required double driverLng, double avgKmph = 30.0}) async {
    try {
      // DRIVER DOC
      final driverDoc = await FirebaseFirestore.instance.collection(CollectionName.driver).doc(driverId).get();
      if (!driverDoc.exists || driverDoc.data() == null) {
        print('updateEtaFromDriverLocation: driver doc not found for $driverId');
        return;
      }
      final driverData = DriverUserModel.fromJson(driverDoc.data()!);
      final orderId = driverData.orderId ?? '';
      if (orderId.isEmpty) {
        print('updateEtaFromDriverLocation: driver $driverId has no active orderId');
        return;
      }

      // ORDER DOC
      final orderSnap = await FirebaseFirestore.instance.collection(CollectionName.orders).doc(orderId).get();
      if (!orderSnap.exists || orderSnap.data() == null) {
        print('updateEtaFromDriverLocation: order $orderId not found');
        return;
      }

      final orderData = OrderModel.fromJson(orderSnap.data()!);

      final vendorLoc = orderData.vendorAddress?.location;
      final customerLoc = orderData.customerAddress?.location;

      if (vendorLoc == null || vendorLoc.latitude == null || vendorLoc.longitude == null) {
        print('updateEtaFromDriverLocation: vendor location missing for order $orderId');
        return;
      }
      if (customerLoc == null || customerLoc.latitude == null || customerLoc.longitude == null) {
        print('updateEtaFromDriverLocation: customer location missing for order $orderId');
        return;
      }

      final vendorLat = vendorLoc.latitude!.toDouble();
      final vendorLng = vendorLoc.longitude!.toDouble();
      final custLat = customerLoc.latitude!.toDouble();
      final custLng = customerLoc.longitude!.toDouble();

      final status = orderData.orderStatus;
      print('updateEtaFromDriverLocation: order=$orderId status=$status');
      print('  driver=($driverLat, $driverLng), vendor=($vendorLat, $vendorLng), customer=($custLat, $custLng)');

      // PREP MINUTES
      int prepMinutes = 0;
      if (orderData.estimatedDeliveryTime != null && orderData.estimatedDeliveryTime!.prepMinutes != null && orderData.estimatedDeliveryTime!.prepMinutes!.isNotEmpty) {
        prepMinutes = int.tryParse(orderData.estimatedDeliveryTime!.prepMinutes.toString()) ?? 0;
      } else {
        if (orderData.items != null && orderData.items!.isNotEmpty) {
          for (final item in orderData.items!) {
            final p = parsePreparationTime(item.preparationTime);
            if (p > prepMinutes) prepMinutes = p;
          }
        }
      }
      if (prepMinutes == 0) prepMinutes = 10;

      int driverToVendorMin = 0;
      int vendorToCustomerMin = 0;

      // BEFORE PICKUP
      if (status == OrderStatus.orderAccepted || status == OrderStatus.driverAssigned || status == OrderStatus.driverAccepted || status == OrderStatus.orderOnReady) {
        final d2vKm = haversineDistanceKm(driverLat, driverLng, vendorLat, vendorLng);
        driverToVendorMin = estimateMinutesByDistanceKm(d2vKm, avgKmph: avgKmph);
        if (driverToVendorMin == 0 && d2vKm > 0) driverToVendorMin = 1;

        final v2cKm = haversineDistanceKm(vendorLat, vendorLng, custLat, custLng);
        vendorToCustomerMin = estimateMinutesByDistanceKm(v2cKm, avgKmph: avgKmph);
        if (vendorToCustomerMin == 0 && v2cKm > 0) vendorToCustomerMin = 1;

        print('  BEFORE_PICKUP: d2vKm=$d2vKm → $driverToVendorMin min, v2cKm=$v2cKm → $vendorToCustomerMin min');
      }
      // AFTER PICKUP
      else if (status == OrderStatus.driverPickup) {
        driverToVendorMin = 0;

        final d2cKm = haversineDistanceKm(driverLat, driverLng, custLat, custLng);
        vendorToCustomerMin = estimateMinutesByDistanceKm(d2cKm, avgKmph: avgKmph);
        if (vendorToCustomerMin == 0 && d2cKm > 0) vendorToCustomerMin = 1;

        print('  AFTER_PICKUP: d2cKm=$d2cKm → $vendorToCustomerMin min (driver→customer)');
      } else {
        print('updateEtaFromDriverLocation: status $status not ETA-tracked for order $orderId');
        return;
      }

      int total;
      if (status == OrderStatus.driverPickup) {
        total = vendorToCustomerMin;
      } else {
        total = prepMinutes + driverToVendorMin + vendorToCustomerMin;
      }

      final estimatedAt = DateTime.now().add(Duration(minutes: total));

      orderData.estimatedDeliveryTime ??= ETAModel();
      orderData.estimatedDeliveryTime!.prepMinutes = prepMinutes.toString();
      orderData.estimatedDeliveryTime!.driverToVendorMinutes = driverToVendorMin.toString();
      orderData.estimatedDeliveryTime!.vendorToCustomerMinutes = vendorToCustomerMin.toString();
      orderData.estimatedDeliveryTime!.totalMinutes = total.toString();
      orderData.estimatedDeliveryTime!.estimatedDeliveryAt = Timestamp.fromDate(estimatedAt);
      orderData.estimatedDeliveryTime!.lastUpdated = Timestamp.now();

      await FireStoreUtils.updateOrder(orderData);
      print('updateEtaFromDriverLocation: SAVE order=$orderId '
          'prep=$prepMinutes, d2v=$driverToVendorMin, v2c=$vendorToCustomerMin, total=$total');
    } catch (e, st) {
      print('updateEtaFromDriverLocation error: $e\n$st');
    }
  }
}
// orderData.estimatedDeliveryTime ??= ETAModel();
//
// final total = prepMinutes + driverToVendorMin + vendorToCustomerMin;
// final estimatedAt = DateTime.now().add(Duration(minutes: total));
//
// orderData.estimatedDeliveryTime!.prepMinutes = prepMinutes.toString();
// orderData.estimatedDeliveryTime!.driverToVendorMinutes = driverToVendorMin.toString();
// orderData.estimatedDeliveryTime!.vendorToCustomerMinutes = vendorToCustomerMin.toString();
// orderData.estimatedDeliveryTime!.totalMinutes = total.toString();
// orderData.estimatedDeliveryTime!.estimatedDeliveryAt = Timestamp.fromDate(estimatedAt);
// orderData.estimatedDeliveryTime!.lastUpdated = Timestamp.now();
//
// FireStoreUtils.updateOrder(orderData);
