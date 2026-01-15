// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:developer';
import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/models/positions_model.dart';
import 'package:driver/app/models/reject_driver_reason_model.dart';
import 'package:driver/app/models/vendor_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/home_screen/views/widget/reject_order.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/order_status.dart';
import 'package:driver/constant/send_notification.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/location_lat_lng.dart';
import 'package:driver/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: unused_import
import 'package:driver/app/models/notification_model.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenController extends GetxController {
  // RxList<String> rejectOrderList = <String>['Vehicle issues', 'Emergency situations', 'Busy Schedule', 'Unsafe Location', 'Long Distance'].obs;
  RxBool driverStatus = false.obs;
  RxBool isRestaurantDataLoading = true.obs;
  RxBool isLoading = true.obs;
  RxBool isOrderDataLoading = false.obs;
  Rx<TextEditingController> otherRejectReasonController = TextEditingController().obs;

  RxString selectedRejectOrderReason = "".obs;
  RxBool isLocationLoading = false.obs;

  GoogleMapController? mapController;
  RxBool isBottomSheetOpen = false.obs;
  RxBool isBottomSheetOpenDetail = false.obs;
  Rx<VendorModel> restaurantModel = VendorModel().obs;
  Rx<CustomerUserModel> customerModel = CustomerUserModel().obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxList<dynamic> rejectOrderList = [].obs;

  @override
  void onInit() {
    super.onInit();
    _startLocationTracking();
    updateCurrentLocation();
    getDriverOrder();
    addMarkerSetup();
  }

  Future<void> addPaymentInWallet() async {
    log("----------------> 1");

    double orderSubTotalAmount = double.parse(orderModel.value.subTotal!);
    double restaurantTaxAmount = 0.0;
    double packagingFee = double.tryParse(orderModel.value.packagingFee ?? "0") ?? 0;
    double platformFee = double.tryParse(orderModel.value.platFormFee ?? "0") ?? 0;
    double packagingTaxAmount = 0.0;
    double discountAmount = 0;

    double deliveryCharge = double.parse(orderModel.value.deliveryCharge!);
    double deliveryTip = double.tryParse(orderModel.value.deliveryTip ?? "0") ?? 0;
    double deliveryTaxAmount = 0.0;

    if (orderModel.value.coupon != null && orderModel.value.coupon!.isVendorOffer == true) {
      discountAmount = double.tryParse(orderModel.value.discount ?? "0") ?? 0;
    }

    for (var taxModel in orderModel.value.taxList!) {
      restaurantTaxAmount += double.parse(
        Constant.calculateTax(
          amount: orderSubTotalAmount.toString(),
          taxModel: taxModel,
        ).toString(),
      );
    }

    if (orderModel.value.deliveryCharge != null && orderModel.value.deliveryCharge != "0.0" && orderModel.value.deliveryCharge != "0") {
      for (var taxModel in orderModel.value.deliveryTaxList!) {
        deliveryTaxAmount += double.parse(
          Constant.calculateTax(
            amount: deliveryCharge.toString(),
            taxModel: taxModel,
          ).toString(),
        );
      }
    }

    if (orderModel.value.packagingFee != null && orderModel.value.packagingFee != "0.0" && orderModel.value.packagingFee != "0") {
      for (var taxModel in orderModel.value.packagingTaxList!) {
        packagingTaxAmount += double.parse(
          Constant.calculateTax(
            amount: packagingFee.toString(),
            taxModel: taxModel,
          ).toString(),
        );
      }
    }

    double ownerWalletTopAmount = (orderSubTotalAmount - discountAmount) + restaurantTaxAmount + packagingFee + packagingTaxAmount;

    // Owner Amount
    await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
      id: Constant.getUuid(),
      amount: ownerWalletTopAmount.toStringAsFixed(2),
      createdDate: Timestamp.now(),
      paymentType: orderModel.value.paymentType,
      transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: ownerModel.value.id,
      isCredit: true,
      type: Constant.owner,
      note: "Order Amount Credited".tr,
    ));

    await FireStoreUtils.updateOwnerWallet(
      amount: ownerWalletTopAmount.toStringAsFixed(2),
      ownerID: ownerModel.value.id.toString(),
    );

    if (orderModel.value.adminCommissionVendor != null && orderModel.value.adminCommissionVendor!.active == true) {
      // Admin Commission
      double vendorCommission = Constant.calculateAdminCommission(
        amount: (orderSubTotalAmount - discountAmount).toStringAsFixed(2),
        adminCommission: orderModel.value.adminCommissionVendor,
      );
      await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
        id: Constant.getUuid(),
        amount: vendorCommission.toString(),
        createdDate: Timestamp.now(),
        paymentType: orderModel.value.paymentType,
        transactionId: orderModel.value.transactionPaymentId,
        userId: ownerModel.value.id,
        isCredit: false,
        type: Constant.owner,
        note: "Admin Commission Debited".tr,
      ));
      await FireStoreUtils.updateOwnerWallet(
        amount: "-${vendorCommission.toString()}",
        ownerID: ownerModel.value.id.toString(),
      );
    }

    if (orderModel.value.paymentType == "Cash on Delivery") {
      log("----------------> 4");

      // Delivery charge
      await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
        id: Constant.getUuid(),
        amount: (deliveryCharge + deliveryTaxAmount).toString(),
        createdDate: Timestamp.now(),
        paymentType: orderModel.value.paymentType,
        transactionId: orderModel.value.transactionPaymentId,
        userId: FireStoreUtils.getCurrentUid(),
        isCredit: true,
        type: Constant.driver,
        note: "Delivery Charge".tr,
      ));

      // Driver tips
      if (orderModel.value.deliveryTip != null && orderModel.value.deliveryTip!.isNotEmpty && orderModel.value.deliveryTip != '0.0' && orderModel.value.deliveryTip != '0') {
        await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
          id: Constant.getUuid(),
          amount: deliveryTip.toString(),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: FireStoreUtils.getCurrentUid(),
          isCredit: true,
          type: Constant.driver,
          note: "Delivery Tip".tr,
        ));
      }

      print("----------------> 5");
      print((deliveryCharge + deliveryTaxAmount) + deliveryTip);
      await FireStoreUtils.updateDriverWalletDebited(
        amount: ((deliveryCharge + deliveryTaxAmount) + deliveryTip).toString(),
        driverID: driverUserModel.value.driverId.toString(),
      );

      // Driver Commission Deduction
      if (orderModel.value.adminCommissionDriver != null || orderModel.value.adminCommissionDriver!.active == true) {
        double driverCommission = Constant.calculateAdminCommission(
          amount: orderModel.value.deliveryCharge.toString(),
          adminCommission: orderModel.value.adminCommissionDriver,
        );

        await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
          id: Constant.getUuid(),
          amount: driverCommission.toString(),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: driverUserModel.value.driverId,
          isCredit: false,
          type: Constant.driver,
          note: "Admin Commission Debited".tr,
        ));

        print("----------------> 5");
        print("-${driverCommission.toString()}");
        await FireStoreUtils.updateDriverWalletDebited(
          amount: "-${driverCommission.toString()}",
          driverID: driverUserModel.value.driverId.toString(),
        );
      }

      // Order Amount Deduction from Driver Wallet order is COD
      await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
        id: Constant.getUuid(),
        amount: (ownerWalletTopAmount + platformFee).toStringAsFixed(2),
        createdDate: Timestamp.now(),
        paymentType: orderModel.value.paymentType,
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: FireStoreUtils.getCurrentUid(),
        isCredit: false,
        type: Constant.driver,
        note: "Order Amount Debited".tr,
      ));

      print("----------------> 5");
      print("-${ownerWalletTopAmount.toString()}");

      await FireStoreUtils.updateDriverWalletDebited(
        amount: "-${(ownerWalletTopAmount + platformFee).toString()}",
        driverID: driverUserModel.value.driverId.toString(),
      );
    } else {
      // Driver amount
      await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
        id: Constant.getUuid(),
        amount: (deliveryCharge + deliveryTaxAmount).toString(),
        createdDate: Timestamp.now(),
        paymentType: orderModel.value.paymentType,
        transactionId: orderModel.value.transactionPaymentId,
        userId: FireStoreUtils.getCurrentUid(),
        isCredit: true,
        type: Constant.driver,
        note: "Delivery Charge".tr,
      ));

      await FireStoreUtils.updateDriverWalletDebited(
        amount: (deliveryCharge + deliveryTaxAmount).toString(),
        driverID: driverUserModel.value.driverId.toString(),
      );

      // Driver tips
      if (orderModel.value.deliveryTip != null && orderModel.value.deliveryTip!.isNotEmpty && orderModel.value.deliveryTip != '0.0' && orderModel.value.deliveryTip != '0') {
        await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
          id: Constant.getUuid(),
          amount: deliveryTip.toString(),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: FireStoreUtils.getCurrentUid(),
          isCredit: true,
          type: Constant.driver,
          note: "Delivery Tip".tr,
        ));

        await FireStoreUtils.updateDriverWalletDebited(
          amount: deliveryTip.toString(),
          driverID: driverUserModel.value.driverId.toString(),
        );
      }

      // Driver Commission Deduction
      if (orderModel.value.adminCommissionDriver != null || orderModel.value.adminCommissionDriver!.active == true) {
        double driverCommission = Constant.calculateAdminCommission(
          amount: orderModel.value.deliveryCharge.toString(),
          adminCommission: orderModel.value.adminCommissionDriver,
        );

        await FireStoreUtils.setWalletTransaction(WalletTransactionModel(
          id: Constant.getUuid(),
          amount: driverCommission.toString(),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: driverUserModel.value.driverId,
          isCredit: false,
          type: Constant.driver,
          note: "Admin Commission Debited".tr,
        ));

        await FireStoreUtils.updateDriverWalletDebited(
          amount: "-${driverCommission.toString()}",
          driverID: driverUserModel.value.driverId.toString(),
        );
      }
    }

    Map<String, dynamic> playLoad = {"orderId": orderModel.value.id};

    SendNotification.sendOneNotification(
        isPayment: orderModel.value.paymentStatus ?? false,
        isSaveNotification: true,
        token: customerModel.value.fcmToken.toString(),
        title: 'Order delivered successfully 📦'.tr,
        body: 'Your order#${orderModel.value.id.toString().substring(0, 4)} Delivered Successfully.',
        type: 'order',
        orderId: orderModel.value.id,
        senderId: FireStoreUtils.getCurrentUid(),
        customerId: customerModel.value.id,
        payload: playLoad,
        isNewOrder: false);

    SendNotification.sendOneNotification(
        isPayment: orderModel.value.paymentStatus ?? false,
        isSaveNotification: true,
        token: ownerModel.value.fcmToken.toString(),
        title: 'Order delivered successfully 📦'.tr,
        body: 'Order delivered successfully and check your wallet order#${orderModel.value.id.toString().substring(0, 4)}',
        type: 'order',
        orderId: orderModel.value.id,
        senderId: FireStoreUtils.getCurrentUid(),
        ownerId: ownerModel.value.id.toString(),
        payload: playLoad,
        isNewOrder: false);

    SendNotification.sendOneNotification(
        isPayment: orderModel.value.paymentStatus ?? false,
        isSaveNotification: true,
        token: driverUserModel.value.fcmToken.toString(),
        title: 'Order delivered successfully 📦'.tr,
        body: 'The order has been successfully delivered to the customer. Great job!',
        type: 'order',
        orderId: orderModel.value.id,
        senderId: FireStoreUtils.getCurrentUid(),
        customerId: driverUserModel.value.driverId,
        payload: playLoad,
        isNewOrder: false);
  }

  loc.Location location = loc.Location();

  Future<void> updateCurrentLocation() async {
    try {
      isLocationLoading.value = true;
      loc.PermissionStatus permissionStatus = await location.hasPermission();

      if (permissionStatus == loc.PermissionStatus.granted) {
        try {
          location.enableBackgroundMode(enable: true);
          location.changeSettings(
            accuracy: loc.LocationAccuracy.high,
            distanceFilter: double.parse(Constant.driverLocationUpdate.toString()),
            interval: 10000,
          );

          location.onLocationChanged.listen((locationData) async {
            try {
              Constant.currentLocation = LocationLatLng(
                latitude: locationData.latitude,
                longitude: locationData.longitude,
              );

              markers.clear();
              if (pickUpIcon != null) {
                addMarker(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!,
                  id: "driver",
                  descriptor: pickUpIcon!,
                  rotation: locationData.heading ?? 0.0,
                );
              } else {}

              updateCameraLocation(
                LatLng(locationData.latitude!, locationData.longitude!),
                LatLng(locationData.latitude!, locationData.longitude!),
                mapController,
              );

              DriverUserModel? driverUserModel = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid());

              if (driverUserModel != null && driverUserModel.isOnline == true) {
                driverUserModel.location = LocationLatLng(
                  latitude: locationData.latitude,
                  longitude: locationData.longitude,
                );

                GeoFirePoint position = GeoFlutterFire().point(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!,
                );

                driverUserModel.position = Positions(
                  geoPoint: position.geoPoint,
                  geohash: position.hash,
                );

                driverUserModel.rotation = locationData.heading;
                // if (driverUserModel.orderId != null && driverUserModel.orderId!.isNotEmpty) {
                //   await Constant.updateEtaFromDriverLocation(
                //     driverId: FireStoreUtils.getCurrentUid(),
                //     driverLat: driverUserModel.location!.latitude ?? 0.0,
                //     driverLng: driverUserModel.location!.longitude ?? 0.0,
                //   );
                // }
                await FireStoreUtils.updateDriverUser(driverUserModel);
              }

              isLocationLoading.value = false;
            } catch (e, stack) {
              developer.log("Error in location onLocationChanged", error: e, stackTrace: stack);
            }
          });
        } catch (e) {
          isLocationLoading.value = false;
        }
      } else {
        try {
          location.requestPermission().then((permissionStatus) {
            if (permissionStatus == loc.PermissionStatus.granted) {
              try {
                location.enableBackgroundMode(enable: true);
                location.changeSettings(
                  accuracy: loc.LocationAccuracy.high,
                  distanceFilter: double.parse(Constant.driverLocationUpdate.toString()),
                  interval: 500000,
                );

                location.onLocationChanged.listen((locationData) async {
                  try {
                    Constant.currentLocation = LocationLatLng(
                      latitude: locationData.latitude,
                      longitude: locationData.longitude,
                    );

                    LatLng currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);
                    updateCameraLocation(currentLatLng, currentLatLng, mapController);
                    addMarkerSetup();

                    DriverUserModel? driverUserModel = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid());

                    if (driverUserModel != null && driverUserModel.isOnline == true) {
                      driverUserModel.location = LocationLatLng(
                        latitude: locationData.latitude,
                        longitude: locationData.longitude,
                      );
                      driverUserModel.rotation = locationData.heading;

                      GeoFirePoint position = GeoFlutterFire().point(
                        latitude: locationData.latitude!,
                        longitude: locationData.longitude!,
                      );

                      driverUserModel.position = Positions(
                        geoPoint: position.geoPoint,
                        geohash: position.hash,
                      );

                      // if (driverUserModel.orderId != null && driverUserModel.orderId!.isNotEmpty) {
                      //   await Constant.updateEtaFromDriverLocation(
                      //     driverId: FireStoreUtils.getCurrentUid(),
                      //     driverLat: driverUserModel.location!.latitude ?? 0.0,
                      //     driverLng: driverUserModel.location!.longitude ?? 0.0,
                      //   );
                      // }
                      await FireStoreUtils.updateDriverUser(driverUserModel);
                    }
                  } catch (e) {
                    if (kDebugMode) {}
                  }
                });
              } catch (e) {
                if (kDebugMode) {}
              }
            }
            isLocationLoading.value = false;
          });
        } catch (e) {
          isLocationLoading.value = false;
        }
      }
    } catch (e) {
      isLocationLoading.value = false;
    }

    update();
  }

  Future<void> _startLocationTracking() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          ShowToastDialog.showToast("Please enable location services.".tr);
          return;
        }
      }

      loc.PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == loc.PermissionStatus.denied) {
        permissionStatus = await location.requestPermission();
        if (permissionStatus != loc.PermissionStatus.granted) {
          ShowToastDialog.showToast("Location permission denied.".tr);
          return;
        }
      }
      try {
        bool backgroundEnabled = await location.enableBackgroundMode(enable: true);
        if (!backgroundEnabled) {
          ShowToastDialog.showToast("Background location permission denied.".tr);
          return;
        }
      } on PlatformException {
        // ShowToastDialog.showToast("Please allow 'Always' location access in settings.");
        return;
      }
      location.changeSettings(
        accuracy: loc.LocationAccuracy.high,
        distanceFilter: double.parse(Constant.driverLocationUpdate.toString()),
        interval: 10000,
      );

      location.onLocationChanged.listen((loc.LocationData currentLocation) {
        developer.log("Location changed: ${currentLocation.latitude}, ${currentLocation.longitude}");
      });
    } on PlatformException catch (e, stack) {
      developer.log("Error in _startLocationTracking", error: e, stackTrace: stack);
    } catch (e) {
      developer.log("Unexpected error in _startLocationTracking", error: e);
    }
  }

  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  Rx<OrderModel> orderModel = OrderModel().obs;

  // Future<void> getDriverOrder() async {
  //   try {
  //     isLoading.value = true;
  //
  //     FireStoreUtils.fireStore.collection(CollectionName.driver).doc(FireStoreUtils.getCurrentUid()).snapshots().listen((event) async {
  //       try {
  //         if (event.exists) {
  //           driverUserModel.value = DriverUserModel.fromJson(event.data()!);
  //           driverStatus.value = driverUserModel.value.isOnline ?? false;
  //           Constant.isDriverOnline.value = driverUserModel.value.isOnline ?? false;
  //           Constant.driverUserModel = driverUserModel.value;
  //
  //           if (driverUserModel.value.orderId != null && driverUserModel.value.orderId!.isNotEmpty) {
  //             try {
  //               isOrderDataLoading.value = true;
  //               timerForAssignedOrder(driverUserModel.value.orderId.toString());
  //
  //               FireStoreUtils.fireStore.collection(CollectionName.orders).doc(driverUserModel.value.orderId).snapshots().listen((orderEvent) async {
  //                 try {
  //                   if (orderEvent.exists) {
  //                     orderModel.value = OrderModel.fromJson(orderEvent.data()!);
  //                     await restaurantAndCustomerData(
  //                       orderModel.value.vendorId.toString(),
  //                       orderModel.value.customerId.toString(),
  //                     );
  //
  //                     if (orderModel.value.orderStatus == OrderStatus.driverAssigned ||
  //                         orderModel.value.orderStatus == OrderStatus.driverAccepted ||
  //                         orderModel.value.orderStatus == OrderStatus.orderOnReady) {
  //                       getPolyline(
  //                         sourceLatitude: driverUserModel.value.location!.latitude,
  //                         sourceLongitude: driverUserModel.value.location!.longitude,
  //                         destinationLatitude: orderModel.value.vendorAddress?.location?.latitude ?? 0.0,
  //                         destinationLongitude: orderModel.value.vendorAddress?.location?.longitude ?? 0.0,
  //                       );
  //                     } else if (orderModel.value.orderStatus == OrderStatus.driverPickup) {
  //                       getPolyline(
  //                         sourceLatitude: driverUserModel.value.location!.latitude,
  //                         sourceLongitude: driverUserModel.value.location!.longitude,
  //                         destinationLatitude: orderModel.value.customerAddress?.location?.latitude ?? 0.0,
  //                         destinationLongitude: orderModel.value.customerAddress?.location?.longitude ?? 0.0,
  //                       );
  //                     }
  //
  //                     polyLines.clear();
  //                     markers.clear();
  //                     polylinePoints = PolylinePoints(apiKey: Constant.mapAPIKey);
  //                     addMarker(
  //                       latitude: Constant.currentLocation?.latitude ?? 0.0,
  //                       longitude: Constant.currentLocation?.longitude ?? 0.0,
  //                       id: "driver",
  //                       descriptor: pickUpIcon!,
  //                       rotation: 0.0,
  //                     );
  //
  //                     isOrderDataLoading.value = false;
  //                     isLoading.value = false;
  //                     update();
  //                   }
  //                 } catch (e) {
  //                   isOrderDataLoading.value = false;
  //                   isLoading.value = false;
  //                 }
  //               });
  //             } catch (e) {
  //               isOrderDataLoading.value = false;
  //               isLoading.value = false;
  //             }
  //           } else {
  //             polyLines.clear();
  //             stopTimer();
  //             isOrderDataLoading.value = false;
  //             isLoading.value = false;
  //             update();
  //           }
  //         } else {
  //           polyLines.clear();
  //           polylinePoints = PolylinePoints(apiKey: Constant.mapAPIKey);
  //           addMarker(
  //             latitude: Constant.currentLocation?.latitude ?? 0.0,
  //             longitude: Constant.currentLocation?.longitude ?? 0.0,
  //             id: "driver",
  //             descriptor: pickUpIcon!,
  //             rotation: 0.0,
  //           );
  //           isLoading.value = false;
  //         }
  //         update();
  //       } catch (e, stack) {
  //         developer.log("Error in getDriverOrder", error: e, stackTrace: stack);
  //         isLoading.value = false;
  //         isOrderDataLoading.value = false;
  //         update();
  //       }
  //     });
  //   } catch (e) {
  //     isLoading.value = false;
  //     isOrderDataLoading.value = false;
  //   }
  // }

  String? lastFetchedOrderId;

  Future<void> getDriverOrder() async {
    try {
      isLoading.value = true;

      FireStoreUtils.fireStore.collection(CollectionName.driver).doc(FireStoreUtils.getCurrentUid()).snapshots().listen((event) async {
        try {
          if (event.exists) {
            driverUserModel.value = DriverUserModel.fromJson(event.data()!);
            driverStatus.value = driverUserModel.value.isOnline ?? false;
            Constant.isDriverOnline.value = driverUserModel.value.isOnline ?? false;
            Constant.driverUserModel = driverUserModel.value;

            String? currentOrderId = driverUserModel.value.orderId;

            if (currentOrderId != null && currentOrderId.isNotEmpty) {
              // 🔒 Prevent repeating order logic if same orderId
              if (lastFetchedOrderId != currentOrderId) {
                lastFetchedOrderId = currentOrderId;

                isOrderDataLoading.value = true;
                timerForAssignedOrder(currentOrderId);

                FireStoreUtils.fireStore.collection(CollectionName.orders).doc(currentOrderId).snapshots().listen((orderEvent) async {
                  try {
                    if (orderEvent.exists) {
                      orderModel.value = OrderModel.fromJson(orderEvent.data()!);

                      await restaurantAndCustomerData(
                        orderModel.value.vendorId.toString(),
                        orderModel.value.customerId.toString(),
                      );

                      if (orderModel.value.orderStatus == OrderStatus.driverAssigned ||
                          orderModel.value.orderStatus == OrderStatus.driverAccepted ||
                          orderModel.value.orderStatus == OrderStatus.orderOnReady) {
                        getPolyline(
                          sourceLatitude: driverUserModel.value.location!.latitude,
                          sourceLongitude: driverUserModel.value.location!.longitude,
                          destinationLatitude: orderModel.value.vendorAddress?.location?.latitude ?? 0.0,
                          destinationLongitude: orderModel.value.vendorAddress?.location?.longitude ?? 0.0,
                        );
                      } else if (orderModel.value.orderStatus == OrderStatus.driverPickup) {
                        getPolyline(
                          sourceLatitude: driverUserModel.value.location!.latitude,
                          sourceLongitude: driverUserModel.value.location!.longitude,
                          destinationLatitude: orderModel.value.customerAddress?.location?.latitude ?? 0.0,
                          destinationLongitude: orderModel.value.customerAddress?.location?.longitude ?? 0.0,
                        );
                      }

                      polyLines.clear();
                      markers.clear();
                      polylinePoints = PolylinePoints(apiKey: Constant.mapAPIKey);

                      addMarker(
                        latitude: Constant.currentLocation?.latitude ?? 0.0,
                        longitude: Constant.currentLocation?.longitude ?? 0.0,
                        id: "driver",
                        descriptor: pickUpIcon!,
                        rotation: 0.0,
                      );

                      isOrderDataLoading.value = false;
                      isLoading.value = false;
                      update();
                    }
                  } catch (e) {
                    isOrderDataLoading.value = false;
                    isLoading.value = false;
                  }
                });
              }
            } else {
              lastFetchedOrderId = null; // reset if no order
              polyLines.clear();
              stopTimer();
              isOrderDataLoading.value = false;
              isLoading.value = false;
              update();
            }
          } else {
            polyLines.clear();
            polylinePoints = PolylinePoints(apiKey: Constant.mapAPIKey);
            addMarker(
              latitude: Constant.currentLocation?.latitude ?? 0.0,
              longitude: Constant.currentLocation?.longitude ?? 0.0,
              id: "driver",
              descriptor: pickUpIcon!,
              rotation: 0.0,
            );
            isLoading.value = false;
          }
          update();
        } catch (e, stack) {
          developer.log("Error in getDriverOrder", error: e, stackTrace: stack);
          isLoading.value = false;
          isOrderDataLoading.value = false;
          update();
        }
      });
    } catch (e) {
      isLoading.value = false;
      isOrderDataLoading.value = false;
    }
  }

  BitmapDescriptor? pickUpIcon;
  BitmapDescriptor? dropIcon;
  BitmapDescriptor? bikeIcon;
  BitmapDescriptor? customerIcon;

  void getPolyline({
    required double? sourceLatitude,
    required double? sourceLongitude,
    required double? destinationLatitude,
    required double? destinationLongitude,
  }) async {
    try {
      if (sourceLatitude != null && sourceLongitude != null && destinationLatitude != null && destinationLongitude != null) {
        polyLines.clear();
        markers.clear();
        List<LatLng> polylineCoordinates = [];

        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          request: PolylineRequest(
            origin: PointLatLng(sourceLatitude, sourceLongitude),
            destination: PointLatLng(destinationLatitude, destinationLongitude),
            mode: TravelMode.driving,
          ),
        );

        if (result.points.isNotEmpty) {
          for (var point in result.points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
        } else {}

        switch (orderModel.value.orderStatus) {
          case OrderStatus.driverAssigned:
            addMarker(
              latitude: sourceLatitude,
              longitude: sourceLongitude,
              id: "driver",
              descriptor: pickUpIcon!,
              rotation: 0.0,
            );
            addMarker(
              latitude: destinationLatitude,
              longitude: destinationLongitude,
              id: "restaurant",
              descriptor: dropIcon!,
              rotation: 0.0,
            );
            break;

          case OrderStatus.driverAccepted:
          case OrderStatus.orderOnReady:
            addMarker(
              latitude: sourceLatitude,
              longitude: sourceLongitude,
              id: "driver",
              descriptor: bikeIcon!,
              rotation: driverUserModel.value.rotation ?? 0.0,
            );
            addMarker(
              latitude: destinationLatitude,
              longitude: destinationLongitude,
              id: "restaurant",
              descriptor: dropIcon!,
              rotation: 0.0,
            );
            break;

          case OrderStatus.driverPickup:
            addMarker(
              latitude: sourceLatitude,
              longitude: sourceLongitude,
              id: "driver",
              descriptor: bikeIcon!,
              rotation: driverUserModel.value.rotation ?? 0.0,
            );
            addMarker(
              latitude: destinationLatitude,
              longitude: destinationLongitude,
              id: "customer",
              descriptor: customerIcon!,
              rotation: 0.0,
            );
            break;

          default:
        }

        addPolyLine(polylineCoordinates);
      } else {}
    } catch (e, stack) {
      developer.log("Error in getPolyline", error: e, stackTrace: stack);
    }
  }

  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  PolylinePoints polylinePoints = PolylinePoints(apiKey: Constant.mapAPIKey);

  Future<void> addPolyLine(List<LatLng> polylineCoordinates) async {
    try {
      if (polylineCoordinates.isEmpty) {
        return;
      }

      PolylineId id = const PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        consumeTapEvents: true,
        color: AppThemeData.primary500,
        startCap: Cap.roundCap,
        width: 4,
      );

      polyLines[id] = polyline;

      updateCameraLocation(polylineCoordinates.first, polylineCoordinates.last, mapController);
    } catch (e, stack) {
      developer.log("Error in addPolyLine", error: e, stackTrace: stack);
    }
  }

  Future<void> addMarkerSetup() async {
    try {
      final Uint8List pickUpUint8List = await Constant().getBytesFromAsset('assets/icons/ic_pick_up_map.png', 80);
      final Uint8List dropUint8List = await Constant().getBytesFromAsset('assets/icons/ic_drop_in_map.png', 80);
      final Uint8List bikeUint8List = await Constant().getBytesFromAsset('assets/icons/ic_bike.png', 80);
      final Uint8List customerUint8List = await Constant().getBytesFromAsset('assets/icons/ic_customer.png', 80);

      pickUpIcon = BitmapDescriptor.fromBytes(pickUpUint8List);
      dropIcon = BitmapDescriptor.fromBytes(dropUint8List);
      bikeIcon = BitmapDescriptor.fromBytes(bikeUint8List);
      customerIcon = BitmapDescriptor.fromBytes(customerUint8List);
    } catch (e, stack) {
      developer.log("Error in addMarkerSetup", error: e, stackTrace: stack);
      ShowToastDialog.showToast("${"Failed to load marker icons:".tr} $e");
    }
  }

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  void addMarker({
    required double? latitude,
    required double? longitude,
    required String id,
    required BitmapDescriptor descriptor,
    required double? rotation,
  }) {
    try {
      if (latitude == null || longitude == null) {
        throw Exception("Latitude or Longitude is null");
      }

      MarkerId markerId = MarkerId(id);
      Marker marker = Marker(
        markerId: markerId,
        icon: descriptor,
        position: LatLng(latitude, longitude),
        rotation: rotation ?? 0.0,
      );

      markers[markerId] = marker;
    } catch (e, stack) {
      developer.log("Error in addMarker", error: e, stackTrace: stack);
      ShowToastDialog.showToast("${"Failed to add marker:".tr} $e");
    }
  }

  Future<void> updateCameraLocation(LatLng source, LatLng destination, GoogleMapController? mapController) async {
    if (mapController == null) return;

    try {
      LatLngBounds bounds;

      // Logic for calculating LatLngBounds is kept as requested
      if (source.latitude > destination.latitude && source.longitude > destination.longitude) {
        bounds = LatLngBounds(southwest: destination, northeast: source);
      } else if (source.longitude > destination.longitude) {
        bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude),
        );
      } else if (source.latitude > destination.latitude) {
        bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude),
        );
      } else {
        bounds = LatLngBounds(southwest: source, northeast: destination);
      }

      // ✅ For same location (source == destination), directly move to location instead of bounds
      if (source.latitude == destination.latitude && source.longitude == destination.longitude) {
        const zoomLevelForSameLocation = 18.0;
        final CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(source, zoomLevelForSameLocation);
        // Use maxRetry: 5 for the initial critical move to increase channel connection reliability
        await safeAnimateCamera(cameraUpdate, mapController, maxRetry: 5);
        return;
      }

      final CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 80);

      // 🔹 Wait briefly before applying camera update (ensures map is ready)
      await Future.delayed(const Duration(milliseconds: 300));

      // Use maxRetry: 5 for the initial critical move
      await checkCameraLocation(cameraUpdate, mapController, maxRetry: 5);
    } catch (e, stack) {
      developer.log("❌ Error in updateCameraLocation", error: e, stackTrace: stack);
    }
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController, {int retryCount = 0, int maxRetry = 3}) async {
    try {
      // Pass the maxRetry count through to safeAnimateCamera
      await safeAnimateCamera(cameraUpdate, mapController, maxRetry: maxRetry);

      // 🔹 Wait a bit before reading visible region
      await Future.delayed(const Duration(milliseconds: 400));

      LatLngBounds region = await mapController.getVisibleRegion();

      if (region.southwest.latitude == -90 && retryCount < maxRetry) {
        // Retry after small delay if region invalid
        await Future.delayed(const Duration(milliseconds: 300));
        return checkCameraLocation(cameraUpdate, mapController, retryCount: retryCount + 1, maxRetry: maxRetry);
      }
    } catch (e, stack) {
      developer.log("❌ Error in checkCameraLocation", error: e, stackTrace: stack);

      // 🔹 Safe retry logic for transient errors
      if (retryCount < maxRetry) {
        await Future.delayed(const Duration(milliseconds: 400));
        return checkCameraLocation(cameraUpdate, mapController, retryCount: retryCount + 1, maxRetry: maxRetry);
      }
    }
  }

  Future<void> safeAnimateCamera(CameraUpdate update, GoogleMapController mapController, {int retry = 0, int maxRetry = 3}) async {
    try {
      await mapController.animateCamera(update);
    } on PlatformException catch (e, stack) {
      // Check for the specific 'channel-error' and ensure we haven't exhausted retries
      if (e.code.contains('channel-error') && retry < maxRetry) {
        developer.log("⚠️ animateCamera channel not ready — retrying (${retry + 1}/$maxRetry)...", error: e);

        // Use a longer delay on the first retry (800ms) where the channel error is most likely
        // due to initial map loading, then revert to 500ms for subsequent attempts.
        final delayMs = retry == 0 ? 800 : 500;
        await Future.delayed(Duration(milliseconds: delayMs));

        return safeAnimateCamera(update, mapController, retry: retry + 1, maxRetry: maxRetry);
      } else {
        // Log failure only when retries are exhausted or a different error occurs
        developer.log("❌ animateCamera failed permanently after $retry retries", error: e, stackTrace: stack);
      }
    } catch (e, stack) {
      developer.log("❌ Unexpected error in animateCamera", error: e, stackTrace: stack);
    }
  }

  Future<void> openGoogleMaps() async {
    ShowToastDialog.showLoader('Please Wait..'.tr);
    try {
      String googleMapsUrl = "";

      if (orderModel.value.orderStatus == OrderStatus.driverAssigned || orderModel.value.orderStatus == OrderStatus.driverAccepted) {
        googleMapsUrl =
            "https://www.google.com/maps/dir/?api=1&origin=${driverUserModel.value.location!.latitude},${driverUserModel.value.location!.longitude}&destination=${orderModel.value.vendorAddress!.location!.latitude},${orderModel.value.vendorAddress!.location!.longitude}&travelmode=driving";
      } else if (orderModel.value.orderStatus == OrderStatus.driverPickup) {
        googleMapsUrl =
            "https://www.google.com/maps/dir/?api=1&origin=${driverUserModel.value.location!.latitude},${driverUserModel.value.location!.longitude}&destination=${orderModel.value.customerAddress!.location!.latitude},${orderModel.value.customerAddress!.location!.longitude}&travelmode=driving";
      }

      final uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        ShowToastDialog.closeLoader();
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $googleMapsUrl';
      }
    } catch (e, stack) {
      developer.log("Error in openGoogleMaps", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> updateDriverIsOnline() async {
    try {
      Constant.driverUserModel!.isOnline = driverStatus.value;

      if (driverStatus.value == true) {
        updateCurrentLocation();
      } else {
        polyLines.clear();
        markers.clear();
        update();
      }

      await FireStoreUtils.updateDriverUser(Constant.driverUserModel!);
    } catch (e, stack) {
      developer.log("Error in updateDriverIsOnline", error: e, stackTrace: stack);
    }
  }

  Future<void> restaurantAndCustomerData(String restaurantID, String customerUserID) async {
    try {
      final restaurant = await FireStoreUtils.getRestaurant(restaurantID);
      final customer = await FireStoreUtils.getCustomerUserData(customerUserID);

      if (restaurant != null && customer != null) {
        restaurantModel.value = restaurant;
        customerModel.value = customer;

        final owner = await FireStoreUtils.getOwnerProfile(restaurant.ownerId.toString());
        if (owner != null) {
          ownerModel.value = owner;
        }

        final reasons = await FireStoreUtils.getRejectOrderReason();

        rejectOrderList.value = reasons;
      } else {
        ShowToastDialog.showToast("Failed to load restaurant or customer data.".tr);
      }
    } catch (e, stack) {
      developer.log("Error in restaurantAndCustomerData", error: e, stackTrace: stack);
    } finally {
      isRestaurantDataLoading.value = false;
    }
  }

  StatefulBuilder rejectOrderBottomSheet(BuildContext context, HomeScreenController controller, DarkThemeProvider themeChange, OrderModel bookingModel) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: ScreenSize.height(75, context),
          width: ScreenSize.height(100, context),
          child: Obx(
            () => SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.h),
                        width: 72.w,
                        height: 8.h,
                        decoration: BoxDecoration(color: AppThemeData.grey400, borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                    spaceH(height: 20.h),
                    TextCustom(
                      title: "Reject Order".tr,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    TextCustom(
                      title: "Choose a reason for Reject your order.".tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppThemeData.grey600,
                    ),
                    spaceH(height: 24.h),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.rejectOrderList.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => RadioListTile(
                            value: controller.rejectOrderList[index],
                            groupValue: controller.selectedRejectOrderReason.value,
                            controlAffinity: ListTileControlAffinity.trailing,
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppThemeData.primary300,
                            title: Text(
                              controller.rejectOrderList[index].toString(),
                              style: TextStyle(
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: FontFamily.regular,
                              ),
                            ),
                            onChanged: (value) {
                              controller.selectedRejectOrderReason.value = value!; // Update selected reason
                              controller.otherRejectReasonController.value.text = ''; // Clear "Other Reason" input if switching
                            },
                          ),
                        );
                      },
                    ),
                    RadioListTile(
                      value: "Other Reason".tr,
                      groupValue: controller.selectedRejectOrderReason.value,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppThemeData.primary300,
                      title: Text(
                        "Other Reason".tr,
                        style: TextStyle(
                          color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: FontFamily.regular,
                        ),
                      ),
                      onChanged: (value) {
                        controller.selectedRejectOrderReason.value = value!;
                      },
                    ),
                    if (controller.selectedRejectOrderReason.value == "Other Reason".tr)
                      TextFieldWidget(
                        title: "Enter other reason".tr,
                        hintText: "Enter other reason".tr,
                        validator: (value) => value != null && value.isNotEmpty ? null : "This field required".tr,
                        controller: controller.otherRejectReasonController.value,
                        onPress: () {},
                      ),
                    spaceH(height: 54.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundShapeButton(
                            size: Size(173.w, ScreenSize.height(6, context)),
                            title: "Keep order".tr,
                            buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey200,
                            buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey500 : AppThemeData.grey500,
                            onTap: () {
                              Navigator.pop(context);
                            }),
                        RoundShapeButton(
                            size: Size(173.w, ScreenSize.height(6, context)),
                            title: "Reject order".tr,
                            buttonColor: AppThemeData.primary300,
                            buttonTextColor: AppThemeData.primaryWhite,
                            onTap: () {
                              if (controller.selectedRejectOrderReason.value == '') {
                                return ShowToastDialog.showToast("Select Reject order reason".tr);
                              }
                              if (controller.selectedRejectOrderReason.value == 'Other Reason' && controller.otherRejectReasonController.value.text == '') {
                                return ShowToastDialog.showToast("Enter Reject order reason".tr);
                              }

                              bookingModel.rejectedDriverReason ??= [];

                              if (controller.selectedRejectOrderReason.value == "Other Reason".tr) {
                                RejectDriverReasonModel rejectedOrderModel =
                                    RejectDriverReasonModel(reason: controller.otherRejectReasonController.value.text, driverId: FireStoreUtils.getCurrentUid());
                                bookingModel.rejectedDriverReason!.add(rejectedOrderModel);
                              } else {
                                bookingModel.rejectedDriverReason!
                                    .add(RejectDriverReasonModel(reason: controller.selectedRejectOrderReason.value, driverId: FireStoreUtils.getCurrentUid()));
                              }

                              bookingModel.driverId = "";
                              bookingModel.orderStatus = OrderStatus.driverRejected;
                              bookingModel.rejectedDriverIds!.add(FireStoreUtils.getCurrentUid());
                              driverUserModel.value.orderId = null;
                              driverUserModel.value.status = 'free';
                              FireStoreUtils.updateOrder(bookingModel);
                              FireStoreUtils.updateDriverUser(driverUserModel.value);
                              Get.offAll(() => RejectOrderView());
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  RxInt remainingSeconds = 0.obs;
  Timer? timer;

  void timerForAssignedOrder(String orderId) {
    try {
      FirebaseFirestore.instance.collection(CollectionName.orders).doc(orderId).snapshots().listen((doc) {
        try {
          if (!doc.exists) return;

          final data = doc.data();
          if (data == null) return;

          String assignedDriverId = data['driverId'];
          String currentDriverId = FireStoreUtils.getCurrentUid();

          if (assignedDriverId == currentDriverId) {
            int totalSeconds = int.tryParse(Constant.secondsForOrderCancel) ?? 180;
            Timestamp? assignedAtTimestamp = data['assignedAt'];

            if (assignedAtTimestamp != null) {
              int elapsedSeconds = DateTime.now().difference(assignedAtTimestamp.toDate()).inSeconds;
              int remaining = totalSeconds - elapsedSeconds;

              if (remaining <= 0) {
                stopTimer();
                return;
              } else {
                startSecondsTimer(remaining);
              }
            } else {
              startSecondsTimer(totalSeconds);
            }
          } else {
            stopTimer();
          }
        } catch (e, stack) {
          developer.log("Error in timerForAssignedOrder", error: e, stackTrace: stack);
        }
      });
    } catch (e, stack) {
      developer.log("Error in timerForAssignedOrder", error: e, stackTrace: stack);
    }
  }

  void startSecondsTimer(int seconds) {
    try {
      remainingSeconds.value = seconds;

      timer?.cancel(); // Cancel any existing timer

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        try {
          if (remainingSeconds.value <= 1) {
            timer.cancel();
            stopTimer();
            // Optionally: handle timeout (e.g., auto-reject)
          } else {
            remainingSeconds.value--;
          }
        } catch (e) {
          timer.cancel();
        }
      });
    } catch (e, stack) {
      developer.log("Error in startSecondsTimer", error: e, stackTrace: stack);
    }
  }

  void stopTimer() {
    try {
      timer?.cancel();
      remainingSeconds.value = 0;
    } catch (e, stack) {
      developer.log("Error in stopTimer", error: e, stackTrace: stack);
    }
  }

  String formatSeconds(int seconds) {
    try {
      final minutes = (seconds ~/ 60).toString();
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return "$minutes:$secs";
    } catch (e, stack) {
      developer.log("Error in formatSeconds", error: e, stackTrace: stack);
      return "00:00";
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseFirestore.instance.collection(CollectionName.driver).doc(FireStoreUtils.getCurrentUid()).delete();

      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (error) {
      log("Firebase Auth Exception : $error");
    } catch (error) {
      log("Error : $error");
    }
  }
}
