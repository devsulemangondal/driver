// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/admin_commission.dart';
import 'package:driver/app/models/admin_model.dart';
import 'package:driver/app/models/bank_details_model.dart';
import 'package:driver/app/models/currency_model.dart';
import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/document_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/language_model.dart';
import 'package:driver/app/models/notification_model.dart';
import 'package:driver/app/models/onboarding_model.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/models/payment_method_model.dart';
import 'package:driver/app/models/referral_model.dart';
import 'package:driver/app/models/review_customer_model.dart';
import 'package:driver/app/models/status_model.dart';
import 'package:driver/app/models/transaction_log_model.dart';
import 'package:driver/app/models/vendor_model.dart';
import 'package:driver/app/models/verify_driver_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/models/withdraw_model.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

import '../constant/order_status.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    try {
      final doc =
          await fireStore.collection(CollectionName.driver).doc(uid).get();
      isExist = doc.exists;
    } catch (e, stack) {
      developer.log("Error in userExistOrNot", error: e, stackTrace: stack);
      isExist = false;
    }
    return isExist;
  }

  static Future<bool?> setTransactionLog(
      TransactionLogModel transactionLogModel) async {
    try {
      await fireStore
          .collection(CollectionName.transactionLog)
          .doc(transactionLogModel.id)
          .set(transactionLogModel.toJson());
      return true;
    } catch (e, stack) {
      developer.log("Error in setTransactionLog", error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<bool> isLogin() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        return await userExistOrNot(currentUser.uid);
      } else {
        return false;
      }
    } catch (e, stack) {
      developer.log("Error in isLogin", error: e, stackTrace: stack);
      return false;
    }
  }

  static Future<DriverUserModel?> getDriverProfile(String uuid) async {
    try {
      final docSnapshot =
          await fireStore.collection(CollectionName.driver).doc(uuid).get();

      if (docSnapshot.exists) {
        final driverData = docSnapshot.data();
        if (driverData != null) {
          final driverModel = DriverUserModel.fromJson(driverData);
          Constant.driverUserModel = driverModel;
          return driverModel;
        }
      }
      return null;
    } catch (error, stack) {
      developer.log("Error in getDriverProfile",
          error: error, stackTrace: stack);
      return null;
    }
  }

  static Future<bool?> setWalletTransaction(
      WalletTransactionModel walletTransactionModel) async {
    bool isAdded = false;
    try {
      await fireStore
          .collection(CollectionName.walletTransaction)
          .doc(walletTransactionModel.id)
          .set(walletTransactionModel.toJson());
      isAdded = true;
    } catch (e, stack) {
      developer.log("Error in setWalletTransaction",
          error: e, stackTrace: stack);
      isAdded = false;
    }
    return isAdded;
  }

  static Future<bool?> updateDriverWallet({required String amount}) async {
    bool isAdded = false;

    try {
      final driverProfile =
          await getDriverProfile(FireStoreUtils.getCurrentUid());

      if (driverProfile != null) {
        DriverUserModel ownerModel = driverProfile;

        double currentAmount =
            double.tryParse(ownerModel.walletAmount.toString()) ?? 0.0;
        double addAmount = double.tryParse(amount) ?? 0.0;
        ownerModel.walletAmount = (currentAmount + addAmount).toString();

        isAdded = await FireStoreUtils.updateDriverUser(ownerModel);
      }
    } catch (e, stack) {
      developer.log("Error in updateDriverWallet", error: e, stackTrace: stack);
      isAdded = false;
    }

    return isAdded;
  }

  static Future<bool?> updateDriverWalletDebited({
    required String amount,
    required String driverID,
  }) async {
    bool isDebited = false;

    try {
      final driverProfile = await getDriverProfile(driverID);

      if (driverProfile != null) {
        DriverUserModel driverModel = driverProfile;

        double currentAmount =
            double.tryParse(driverModel.walletAmount.toString()) ?? 0.0;
        double debitAmount = double.tryParse(amount) ?? 0.0;

        print("=====>");
        print(currentAmount);
        print(debitAmount);
        driverModel.walletAmount = (currentAmount + debitAmount).toString();

        isDebited = await FireStoreUtils.updateDriverUser(driverModel);
      }
    } catch (e, stack) {
      developer.log("Error in updateDriverWalletDebited",
          error: e, stackTrace: stack);
      isDebited = false;
    }

    return isDebited;
  }

  static Future<bool?> updateOwnerWallet(
      {required String amount, required String ownerID}) async {
    bool isAdded = false;

    try {
      final ownerProfile = await getOwnerProfile(ownerID);

      if (ownerProfile != null) {
        OwnerModel ownerModel = ownerProfile;

        double currentAmount =
            double.tryParse(ownerModel.walletAmount.toString()) ?? 0.0;
        double debitAmount = double.tryParse(amount) ?? 0.0;
        ownerModel.walletAmount = (currentAmount + debitAmount).toString();

        isAdded = await FireStoreUtils.updateOwner(ownerModel);
      }
    } catch (e, stack) {
      developer.log("Error in update Owner Wallet ",
          error: e, stackTrace: stack);
      isAdded = false;
    }

    return isAdded;
  }

  static Future<bool> updateOwner(OwnerModel ownerModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.owner)
          .doc(ownerModel.id)
          .update(ownerModel.toJson());

      isUpdate = true;
    } catch (e, stack) {
      developer.log("Error in updateOwner", error: e, stackTrace: stack);
      isUpdate = false;
    }

    return isUpdate;
  }

  static Future<bool> addDriver(DriverUserModel driverModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.driver)
          .doc(driverModel.driverId)
          .set(driverModel.toJson());

      Constant.driverUserModel = driverModel;
      isUpdate = true;
    } catch (e, stack) {
      developer.log("Error in addDriver", error: e, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<bool> addVerifyDriver(VerifyDriverModel driverModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.verifyDriver)
          .doc(driverModel.driverId)
          .set(driverModel.toJson());

      isUpdate = true;
    } catch (e, stack) {
      developer.log("Error in addVerifyDriver", error: e, stackTrace: stack);
      isUpdate = false;
    }

    return isUpdate;
  }

  static Future<bool> updateVerifyDriver(VerifyDriverModel driverModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.verifyDriver)
          .doc(driverModel.driverId)
          .update(driverModel.toJson());

      isUpdate = true;
    } catch (e, stack) {
      developer.log("Error in updateVerifyDriver", error: e, stackTrace: stack);
      isUpdate = false;
    }

    return isUpdate;
  }

  static Future<VerifyDriverModel?> getDocuments() async {
    VerifyDriverModel? verifyDriverModel;

    try {
      final docSnapshot = await fireStore
          .collection(CollectionName.verifyDriver)
          .doc(FireStoreUtils.getCurrentUid())
          .get();

      if (docSnapshot.exists) {
        verifyDriverModel = VerifyDriverModel.fromJson(docSnapshot.data()!);
      }
    } catch (e, stack) {
      developer.log("Error in getDocuments", error: e, stackTrace: stack);
      verifyDriverModel = null;
    }

    return verifyDriverModel;
  }

  static Future<DocumentModel?> getDocument(String uuid) async {
    DocumentModel? documentModel;

    try {
      final docSnapshot =
          await fireStore.collection(CollectionName.documents).doc(uuid).get();

      if (docSnapshot.exists) {
        documentModel = DocumentModel.fromJson(docSnapshot.data()!);
      }
    } catch (e, stack) {
      developer.log("Error in getDocument", error: e, stackTrace: stack);
      documentModel = null;
    }

    return documentModel;
  }

  static Future<DriverUserModel?> getDriverUserProfile(String uuid) async {
    DriverUserModel? driverUserModel;

    try {
      final docSnapshot =
          await fireStore.collection(CollectionName.driver).doc(uuid).get();

      if (docSnapshot.exists) {
        driverUserModel = DriverUserModel.fromJson(docSnapshot.data()!);
        Constant.driverUserModel = driverUserModel;
      }
    } catch (e, stack) {
      developer.log("Error in getDriverUserProfile",
          error: e, stackTrace: stack);
      driverUserModel = null;
    }

    return driverUserModel;
  }

  static Future<bool> addBankDetail(BankDetailsModel bankDetailsModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.bankDetails)
          .doc(bankDetailsModel.id)
          .set(bankDetailsModel.toJson());

      isUpdate = true;
    } catch (e, stack) {
      developer.log("Error in addBankDetail", error: e, stackTrace: stack);
      isUpdate = false;
    }

    return isUpdate;
  }

  static Future<bool> updateBankDetail(
      BankDetailsModel bankDetailsModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.bankDetails)
          .doc(bankDetailsModel.id)
          .update(bankDetailsModel.toJson());

      isUpdate = true;
    } catch (e, stack) {
      developer.log("Error in updateBankDetail", error: e, stackTrace: stack);
      isUpdate = false;
    }

    return isUpdate;
  }

  static Future<bool> updateDriverUser(DriverUserModel driverUserModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.driver)
          .doc(driverUserModel.driverId)
          .set(driverUserModel.toJson());

      isUpdate = true;
    } catch (e, stack) {
      developer.log("Error in updateDriverUserProfile",
          error: e, stackTrace: stack);
      isUpdate = false;
    }

    return isUpdate;
  }

  Future<PaymentModel?> getPayment() async {
    PaymentModel? paymentModel;

    try {
      final docSnapshot = await fireStore
          .collection(CollectionName.settings)
          .doc("payment")
          .get();

      if (docSnapshot.exists) {
        paymentModel = PaymentModel.fromJson(docSnapshot.data()!);
        Constant.paymentModel = paymentModel;
      }
    } catch (e, stack) {
      developer.log("Error in getPayment", error: e, stackTrace: stack);
      paymentModel = null;
    }

    return paymentModel;
  }

  static Future<List<BankDetailsModel>?> getBankDetailList(
      String? ownerId) async {
    List<BankDetailsModel> bankDetailsList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.bankDetails)
          .where("driverId", isEqualTo: ownerId)
          .get();

      for (var element in querySnapshot.docs) {
        BankDetailsModel bankDetailModel =
            BankDetailsModel.fromJson(element.data());
        bankDetailsList.add(bankDetailModel);
      }
    } catch (e, stack) {
      developer.log("Error in getBankDetailList", error: e, stackTrace: stack);
      return null;
    }

    return bankDetailsList;
  }

  static Future<List<WalletTransactionModel>?> getWalletTransaction() async {
    List<WalletTransactionModel> walletTransactionModelList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.walletTransaction)
          .where('userId', isEqualTo: FireStoreUtils.getCurrentUid())
          .where('type', isEqualTo: Constant.driver)
          .orderBy('createdDate', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        WalletTransactionModel walletTransactionModel =
            WalletTransactionModel.fromJson(element.data());
        walletTransactionModelList.add(walletTransactionModel);
      }
    } catch (e, stack) {
      developer.log("Error in getWalletTransaction",
          error: e, stackTrace: stack);
      return null;
    }

    return walletTransactionModelList;
  }

  static Future<List<OrderModel>?> getCompletedOrder() async {
    List<OrderModel> completedOrderListList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.orders)
          .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
          .where('orderStatus', isEqualTo: 'order_complete')
          .orderBy('createdAt', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        OrderModel orderModel = OrderModel.fromJson(element.data());
        completedOrderListList.add(orderModel);
      }
    } catch (e, stack) {
      developer.log("Error in getCompletedOrder", error: e, stackTrace: stack);
      return null;
    }

    return completedOrderListList;
  }

  static Future<List<OrderModel>?> getAllOrder() async {
    List<OrderModel> allOrderListList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.orders)
          .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
          .orderBy('createdAt', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        OrderModel orderModel = OrderModel.fromJson(element.data());
        allOrderListList.add(orderModel);
      }
    } catch (e, stack) {
      developer.log("Error in getAllOrder", error: e, stackTrace: stack);
      return null;
    }

    return allOrderListList;
  }

  static Future<List<OrderModel>> getOrderListForStatement(
      DateTimeRange? dateTimeRange) async {
    List<OrderModel> orderList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.orders)
          .where('driverId', isEqualTo: FireStoreUtils.getCurrentUid())
          .where(
            'createdAt',
            isGreaterThanOrEqualTo: dateTimeRange!.start,
            isLessThan: dateTimeRange.end,
          )
          .orderBy('createdAt', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        OrderModel documentModel = OrderModel.fromJson(element.data());
        orderList.add(documentModel);
      }
    } catch (e, stack) {
      developer.log("Error in getOrderListForStatement",
          error: e, stackTrace: stack);
    }

    return orderList;
  }

  static Future<List<OrderModel>?> getRejectsOrder() async {
    List<OrderModel> rejectOrderListList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.orders)
          .where('rejectedDriverIds',
              arrayContains: FireStoreUtils.getCurrentUid())
          .orderBy('createdAt', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        OrderModel rejectOrderModel = OrderModel.fromJson(element.data());
        rejectOrderListList.add(rejectOrderModel);
      }
    } catch (e, stack) {
      developer.log("Error in getRejectsOrder", error: e, stackTrace: stack);
      return null;
    }

    return rejectOrderListList;
  }

  static Future<List<WithdrawModel>> getWithDrawRequest() async {
    List<WithdrawModel> withdrawalList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.withdrawalHistory)
          .where('ownerId', isEqualTo: getCurrentUid())
          .orderBy('createdDate', descending: true)
          .get();

      for (var element in querySnapshot.docs) {
        WithdrawModel documentModel = WithdrawModel.fromJson(element.data());
        withdrawalList.add(documentModel);
      }
    } catch (e, stack) {
      developer.log("Error in getWithDrawRequest", error: e, stackTrace: stack);
    }

    return withdrawalList;
  }

  static Future<bool?> setWithdrawRequest(WithdrawModel withdrawModel) async {
    bool isAdded = false;

    try {
      await fireStore
          .collection(CollectionName.withdrawalHistory)
          .doc(withdrawModel.id)
          .set(withdrawModel.toJson());

      isAdded = true;
    } catch (e, stack) {
      developer.log("Error in setWithdrawRequest", error: e, stackTrace: stack);
      isAdded = false;
    }

    return isAdded;
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> languageList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.languages)
          .where('active', isEqualTo: true)
          .get();

      for (var element in querySnapshot.docs) {
        LanguageModel languageModel = LanguageModel.fromJson(element.data());
        languageList.add(languageModel);
      }
    } catch (e, stack) {
      developer.log("Error in getLanguage", error: e, stackTrace: stack);
      return null;
    }

    return languageList;
  }

  static Future<OwnerModel?> getOwnerProfile(String uuid) async {
    OwnerModel? ownerModel;

    try {
      final docSnapshot =
          await fireStore.collection(CollectionName.owner).doc(uuid).get();

      if (docSnapshot.exists) {
        ownerModel = OwnerModel.fromJson(docSnapshot.data()!);
      }
    } catch (e, stack) {
      developer.log("Error in getOwnerProfile", error: e, stackTrace: stack);
      ownerModel = null;
    }

    return ownerModel;
  }

  static Future<ReviewModel?> getReview(String orderId) async {
    ReviewModel? reviewModel;

    try {
      final docSnapshot =
          await fireStore.collection(CollectionName.review).doc(orderId).get();

      if (docSnapshot.data() != null) {
        reviewModel = ReviewModel.fromJson(docSnapshot.data()!);
      }
    } catch (e, stack) {
      developer.log("Error in getReview", error: e, stackTrace: stack);
      reviewModel = null;
    }

    return reviewModel;
  }

  static Future<List<dynamic>> getRejectOrderReason() async {
    try {
      final doc = await fireStore
          .collection(CollectionName.settings)
          .doc('driver_reject_reason')
          .get();

      if (doc.data() != null) {
        // Access the 'reason' field instead of 'reasons'
        final reasons = doc.data()!["reasons"];

        return reasons != null ? List<dynamic>.from(reasons) : [];
      } else {
        return [];
      }
    } catch (e, stack) {
      developer.log("Error in getRejectOrderReason",
          error: e, stackTrace: stack);
      return [];
    }
  }

  static Future<List<DocumentModel>?> getDocumentsList() async {
    List<DocumentModel> documentList = [];

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.documents)
          .where('type', isEqualTo: 'Driver')
          .where('active', isEqualTo: true)
          .get();

      for (var element in querySnapshot.docs) {
        DocumentModel categoryModel = DocumentModel.fromJson(element.data());
        documentList.add(categoryModel);
      }
    } catch (e, stack) {
      developer.log("Error in getDocumentsList", error: e, stackTrace: stack);
      return null;
    }

    return documentList;
  }

  Future<CurrencyModel?> getCurrency() async {
    CurrencyModel? currencyModel;

    try {
      final querySnapshot = await fireStore
          .collection(CollectionName.currencies)
          .where("active", isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        currencyModel = CurrencyModel.fromJson(querySnapshot.docs.first.data());
      }
    } catch (e, stack) {
      developer.log("Error in getCurrency", error: e, stackTrace: stack);
      return null;
    }

    return currencyModel;
  }

  Future<void> getAdminCommissionDriver() async {
    try {
      final doc = await fireStore
          .collection(CollectionName.settings)
          .doc("admin_commission")
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey("admin_commission_driver")) {
          AdminCommission adminCommission =
              AdminCommission.fromJson(data["admin_commission_driver"]);
          log("Driver commission map: ${data["admin_commission_driver"]}");
          if (adminCommission.active == true) {
            Constant.adminCommissionDriver = adminCommission;
          }
        }
      }
    } catch (e, stack) {
      developer.log('Error fetching admin commission: $e',
          error: e, stackTrace: stack);
    }
  }

  Future<void> getAdminCommissionVendor() async {
    try {
      final doc = await fireStore
          .collection(CollectionName.settings)
          .doc("admin_commission")
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data.containsKey("admin_commission_vendor")) {
          AdminCommission adminCommission =
              AdminCommission.fromJson(data["admin_commission_vendor"]);
          log("Driver commission map: ${data["admin_commission_vendor"]}");
          if (adminCommission.active == true) {
            Constant.adminCommissionVendor = adminCommission;
          }
        }
      }
    } catch (e, stack) {
      developer.log('Error fetching admin commission: $e',
          error: e, stackTrace: stack);
    }
  }

  Future<void> getSettings() async {
    try {
      final constantDoc = await fireStore
          .collection(CollectionName.settings)
          .doc("constant")
          .get();
      if (constantDoc.exists) {
        final data = constantDoc.data()!;
        Constant.senderId = data["notification_senderId"];
        Constant.jsonFileURL = data["jsonFileURL"];
        Constant.radius = data["radius"] ?? "50";
        Constant.minimumAmountToDeposit =
            data["minimum_amount_deposit"] ?? "100";
        Constant.minimumAmountToWithdrawal =
            data["minimum_amount_withdraw"] ?? "100";
        Constant.mapAPIKey = data["googleMapKey"] ?? "";
        Constant.termsAndConditions = data["termsAndConditions"];
        Constant.privacyPolicy = data["privacyPolicy"];
        Constant.aboutApp = data["aboutApp"];
        Constant.notificationServerKey = data["notification_senderId"] ?? "";
        Constant.secondsForOrderCancel = data["secondsForOrderCancel"] ?? "60";
        Constant.appName.value = data["appName"];
        Constant.appColor = data["driverAppColor"];
        Constant.referralAmount = data["referral_Amount"];
        Constant.isDriverDocumentVerification =
            data["isDriverDocumentVerification"];
      }
    } catch (e, stack) {
      developer.log("Error in getSettings", error: e, stackTrace: stack);
    }

    try {
      final statusDoc = await fireStore
          .collection(CollectionName.settings)
          .doc("status")
          .get();
      Constant.statusModel = StatusModel.fromJson(statusDoc.data()!);
    } catch (e, stack) {
      developer.log("Error in getStatus", error: e, stackTrace: stack);
    }
  }

  static Stream<QuerySnapshot> getNotificationList() {
    try {
      final uid = FireStoreUtils.getCurrentUid();

      return fireStore
          .collection(CollectionName.notification)
          .where('driverId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (e, stack) {
      developer.log("Error in getNotificationList",
          error: e, stackTrace: stack);
      return const Stream.empty(); // Return empty stream on error
    }
  }

  static Future<bool?> setNotification(
      NotificationModel notificationModel) async {
    bool isAdded = false;
    try {
      await fireStore
          .collection(CollectionName.notification)
          .doc(notificationModel.id)
          .set(notificationModel.toJson());
      isAdded = true;
    } catch (e, stack) {
      developer.log("Error in setNotification", error: e, stackTrace: stack);

      isAdded = false;
    }
    return isAdded;
  }

  late StreamController<DriverUserModel?> getNearestServiceRequestController;

  Stream<DriverUserModel?> getServiceNearestByFeatured(
      {double? latitude, double? longLatitude}) async* {
    getNearestServiceRequestController =
        StreamController<DriverUserModel?>.broadcast();

    try {
      Query query = fireStore
          .collection(CollectionName.driver)
          .where("isOnline", isEqualTo: true)
          .where("active", isEqualTo: true);

      GeoFirePoint center = GeoFlutterFire().point(
        latitude: latitude ?? 0.0,
        longitude: longLatitude ?? 0.0,
      );

      Stream<List<DocumentSnapshot>> stream =
          GeoFlutterFire().collection(collectionRef: query).within(
                center: center,
                radius: double.parse(Constant.radius),
                field: 'position',
                strictMode: true,
              );

      stream.listen((List<DocumentSnapshot> documentList) {
        try {
          DriverUserModel? nearestDriver;

          for (var document in documentList) {
            final data = document.data() as Map<String, dynamic>;
            DriverUserModel driverModel = DriverUserModel.fromJson(data);

            if (driverModel.driverId != FireStoreUtils.getCurrentUid()) {
              nearestDriver = driverModel;
              break;
            }
          }

          getNearestServiceRequestController.sink.add(nearestDriver);
        } catch (innerError) {
          getNearestServiceRequestController.sink.add(null);
        }
      }, onError: (streamError) {
        getNearestServiceRequestController.sink.add(null);
      });
    } catch (e, stack) {
      developer.log("Error in getServiceNearestByFeatured",
          error: e, stackTrace: stack);
      getNearestServiceRequestController.sink.add(null);
    }

    yield* getNearestServiceRequestController.stream;
  }

  static Future<bool> updateOrder(OrderModel bookingModel) async {
    bool isUpdate = false;

    try {
      await fireStore
          .collection(CollectionName.orders)
          .doc(bookingModel.id)
          .update(bookingModel.toJson());
      isUpdate = true;
    } catch (error, stack) {
      developer.log("Error in updateOrder", error: error, stackTrace: stack);
      isUpdate = false;
    }
    return isUpdate;
  }

  static Future<VendorModel?> getRestaurant(String uuid) async {
    VendorModel? restaurantModel;

    try {
      final doc =
          await fireStore.collection(CollectionName.vendors).doc(uuid).get();
      if (doc.exists) {
        restaurantModel = VendorModel.fromJson(doc.data()!);
      }
    } catch (error, stack) {
      developer.log("Error in getRestaurant", error: error, stackTrace: stack);
      restaurantModel = null;
    }
    return restaurantModel;
  }

  static Future<CustomerUserModel?> getCustomerUserData(String uuid) async {
    CustomerUserModel? userModel;

    try {
      final doc =
          await fireStore.collection(CollectionName.customers).doc(uuid).get();
      if (doc.exists) {
        userModel = CustomerUserModel.fromJson(doc.data()!);
      }
    } catch (error, stack) {
      developer.log("Error in getCustomerUserData",
          error: error, stackTrace: stack);
      userModel = null;
    }

    return userModel;
  }

  Stream<List<OrderModel>> getNewOrder() async* {
    try {
      final snapshots = fireStore
          .collection(CollectionName.orders)
          .where('orderStatus', whereIn: [OrderStatus.orderAccepted])
          .orderBy('createdAt', descending: true)
          .snapshots();

      await for (final snapshot in snapshots) {
        final orders = snapshot.docs
            .map((doc) => OrderModel.fromJson(doc.data()))
            .toList();
        yield orders;
      }
    } catch (e, stack) {
      developer.log("Error in getNewOrder", error: e, stackTrace: stack);
      yield [];
    }
  }

  static Future<List<ReviewModel>?> getDriverReview(String driverId) async {
    List<ReviewModel> reviewModelList = [];

    try {
      final snapshot = await fireStore
          .collection(CollectionName.review)
          .where("driverId", isEqualTo: driverId)
          .where('type', isEqualTo: Constant.driver)
          .get();

      for (var element in snapshot.docs) {
        ReviewModel reviewModel = ReviewModel.fromJson(element.data());
        reviewModelList.add(reviewModel);
      }
    } catch (e, stack) {
      developer.log("Error in getDriverReview", error: e, stackTrace: stack);
      return null;
    }
    return reviewModelList;
  }

  static Future<List<OnboardingScreenModel>> getOnboardingDataList() async {
    List<OnboardingScreenModel> onboardingList = [];
    try {
      var snapshot = await fireStore
          .collection(CollectionName.onboardingScreen)
          .where('status', isEqualTo: true)
          .where('type', isEqualTo: 'driver')
          .orderBy('createdAt', descending: false)
          .get();
      for (var element in snapshot.docs) {
        onboardingList.add(OnboardingScreenModel.fromJson(element.data()));
      }
    } catch (e) {
      developer.log("Failed to fetch Onboarding list: $e");
    }
    return onboardingList;
  }

  static Future<ReferralModel?> getReferral() async {
    ReferralModel? referralModel;
    await fireStore
        .collection(CollectionName.referral)
        .doc(FireStoreUtils.getCurrentUid())
        .get()
        .then((value) {
      if (value.exists) {
        referralModel = ReferralModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      developer.log("Failed to get Referral: $error");
      referralModel = null;
    });
    return referralModel;
  }

  static Future<ReferralModel?> getReferralUserByCode(
      String referralCode) async {
    ReferralModel? referralModel;
    try {
      await fireStore
          .collection(CollectionName.referral)
          .where("referralCode", isEqualTo: referralCode)
          .get()
          .then((value) {
        referralModel = ReferralModel.fromJson(value.docs.first.data());
      });
    } catch (e, s) {
      developer.log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return null;
    }
    return referralModel;
  }

  static Future<String?> referralAdd(ReferralModel referral) async {
    try {
      await fireStore
          .collection(CollectionName.referral)
          .doc(referral.userId)
          .set(referral.toJson());
    } catch (e, s) {
      developer.log('add referral error:  $e $s');
      return null;
    }
    return null;
  }

  static Future<bool?> checkReferralCodeValidOrNot(String referralCode) async {
    bool? isExit;
    try {
      await fireStore
          .collection(CollectionName.referral)
          .where("referralCode", isEqualTo: referralCode)
          .get()
          .then((value) {
        if (value.size > 0) {
          isExit = true;
        } else {
          isExit = false;
        }
      });
    } catch (e, s) {
      developer.log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return false;
    }
    return isExit;
  }

  static Future<bool?> updateWalletForReferral({
    required String userId,
    required String amount,
    required String role,
  }) async {
    bool isAdded = false;

    // 3 Roles Support
    String collection;
    if (role == Constant.user) {
      collection = CollectionName.customers;
    } else if (role == Constant.driver) {
      collection = CollectionName.driver;
    } else if (role == Constant.owner) {
      collection = CollectionName.owner;
    } else {
      collection = CollectionName.customers;
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      double currentWalletAmount = double.tryParse(
              docSnapshot.data()?['walletAmount']?.toString() ?? '0') ??
          0;
      double updatedWalletAmount = currentWalletAmount + double.parse(amount);

      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userId)
          .update({
        'walletAmount': updatedWalletAmount.toStringAsFixed(2),
      }).then((value) {
        isAdded = true;
      }).catchError((error) {
        developer.log('Error updating wallet for referral: $error');
        isAdded = false;
      });
    } else {
      developer.log("User not found in $collection collection for ID: $userId");
    }
    return isAdded;
  }

  static Future<AdminModel?> getAdminProfile() async {
    try {
      final snapshot =
          await fireStore.collection(CollectionName.admin).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        AdminModel adminModel = AdminModel.fromJson(data);
        return adminModel;
      } else {
        developer.log('No admin profile found in Firestore');
      }
    } catch (e, stack) {
      developer.log('Error fetching admin profile: $e',
          error: e, stackTrace: stack);
    }
    return null;
  }
}
