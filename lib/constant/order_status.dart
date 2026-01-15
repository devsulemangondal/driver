import 'dart:developer' as developer;

import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderStatus {
  static const String orderPending = "order_pending";
  static const String orderAccepted = "order_accepted";
  static const String orderRejected = "order_rejected";
  static const String orderComplete = "order_complete";
  static const String orderCancel = "order_cancel";
  static const String orderOnReady = "order_on_ready";
  static const String driverAssigned = "driver_assigned";
  static const String driverAccepted = "driver_accepted";
  static const String driverRejected = "driver_rejected";
  static const String driverPickup = "driver_picked";

  static String getOrderStatusTitle(String status) {
    String bookingStatus = '';
    if (status == orderPending) {
      bookingStatus = 'Pending';
    } else if (status == orderAccepted || status == driverAssigned) {
      bookingStatus = 'Accepted';
    } else if (status == orderCancel) {
      bookingStatus = 'Cancelled';
    } else if (status == orderComplete) {
      bookingStatus = 'Completed';
    } else if (status == orderRejected) {
      bookingStatus = 'Rejected';
    } else if (status == driverAccepted) {
      bookingStatus = 'Driver Accepted';
    } else if (status == orderOnReady) {
      bookingStatus = 'On Ready';
    } else if (status == orderRejected) {
      bookingStatus = 'Rejected';
    } else if (status == driverPickup) {
      bookingStatus = 'Picked';
    }
    return bookingStatus;
  }

  static Color getOrderStatusTitleColor(String status, BuildContext context) {
    try {
      Color color = const Color(0xff9d9d9d);
      final themeChange = Provider.of<DarkThemeProvider>(context);

      if (status == orderPending) {
        color = AppThemeData.secondary300;
      } else if (status == orderAccepted || status == driverAssigned) {
        color = AppThemeData.pending300;
      } else if (status == orderCancel) {
        color = themeChange.isDarkTheme() ? AppThemeData.danger200 : AppThemeData.danger400;
      } else if (status == orderComplete) {
        color = themeChange.isDarkTheme() ? AppThemeData.success200 : AppThemeData.success400;
      } else if (status == orderRejected) {
        color = AppThemeData.primary300;
      } else if (status == driverAccepted) {
        color = AppThemeData.pending300;
      } else if (status == orderOnReady || status == driverPickup) {
        color = AppThemeData.accent300;
      } else if (status == orderComplete) {
        color = AppThemeData.success300;
      }

      return color;
    } catch (e, stack) {
      developer.log("Error getting order status title color", error: e, stackTrace: stack);
      return const Color(0xff9d9d9d);
    }
  }

  static Color getOrderStatusBackgroundColor(String status, BuildContext context) {
    try {
      Color color = const Color(0xff00B2CB);
      final themeChange = Provider.of<DarkThemeProvider>(context);

      if (status == orderPending) {
        color = themeChange.isDarkTheme()
            ? AppThemeData.secondary600
            : AppThemeData.secondary50;
      } else if (status == orderAccepted || status == driverAssigned) {
        color = themeChange.isDarkTheme()
            ? AppThemeData.pending600
            : AppThemeData.pending50;
      } else if (status == orderCancel) {
        color = themeChange.isDarkTheme()
            ? AppThemeData.danger600
            : AppThemeData.danger50;
      } else if (status == orderComplete) {
        color = themeChange.isDarkTheme()
            ? AppThemeData.success600
            : AppThemeData.success50;
      } else if (status == orderRejected) {
        color = themeChange.isDarkTheme()
            ? AppThemeData.primary600
            : AppThemeData.primary50;
      } else if (status == driverAccepted) {
        color = themeChange.isDarkTheme()
            ? AppThemeData.pending600
            : AppThemeData.pending50;
      } else if (status == orderOnReady || status == driverPickup) {
        color = themeChange.isDarkTheme()
            ? AppThemeData.accent600
            : AppThemeData.accent50;
      }

      return color;
    } catch (e,stack) {
      developer.log("Error in getOrderStatusBackgroundColor", error: e, stackTrace: stack);
    }
      return const Color(0xff00B2CB);
    }
  }

