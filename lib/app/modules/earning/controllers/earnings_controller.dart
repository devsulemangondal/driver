// ignore_for_file: depend_on_referenced_packages, unused_import

import 'dart:developer';
import 'dart:developer' as developer;

import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/models/pie_model.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EarningController extends GetxController {
  RxList<OrderModel> orderCompletedList = <OrderModel>[].obs;
  RxList<OrderModel> rejectOrderList = <OrderModel>[].obs;

  RxString selectedTimeRevenue = 'Monthly'.obs;
  RxString selectedTimeTotalOrders = 'Monthly'.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingChatData = false.obs;

  RxDouble totalEarning = 0.0.obs;
  RxDouble weeklyEarning = 0.0.obs;

  var rejectedOrderListCount = 0.obs;
  var completedOrderListCount = 0.obs;
  var cancelledOrderListCount = 0.obs;

  RxList<PieData> pieData = <PieData>[
    PieData('Rejected', 0, '0', AppThemeData.danger300),
    PieData('Completed', 0, '0', AppThemeData.secondary300),
    PieData('Cancelled', 0, '0', AppThemeData.info300),
  ].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  bool get isChartDataEmpty {
    return pieData.every((data) => data.yData == 0);
  }

  RxMap<String, double> dailyRevenue = {
    'Mon': 0.0,
    'Tue': 0.0,
    'Wed': 0.0,
    'Thu': 0.0,
    'Fri': 0.0,
    'Sat': 0.0,
    'Sun': 0.0,
  }.obs;

  RxMap<String, double> monthlyRevenue = {
    'Jan': 0.0,
    'Feb': 0.0,
    'Mar': 0.0,
    'Apr': 0.0,
    'May': 0.0,
    'Jun': 0.0,
    'Jul': 0.0,
    'Aug': 0.0,
    'Sep': 0.0,
    'Oct': 0.0,
    'Nov': 0.0,
    'Dec': 0.0,
  }.obs;

  Future<void> getData() async {
    try {
      isLoading.value = true;

      final completedOrders = await FireStoreUtils.getCompletedOrder();
      if (completedOrders != null) {
        orderCompletedList.value = completedOrders;
      }

      final rejectedOrders = await FireStoreUtils.getRejectsOrder();
      if (rejectedOrders != null) {
        rejectOrderList.value = rejectedOrders;
      }

      calculationOfRevenue();
      fetchOrderStats();
    } catch (e, stack) {
      developer.log("Error in getData", error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  bool shouldShowChart() {
    try {
      if (selectedTimeRevenue.value == 'Weekly') {
        return isDataAvailable(dailyRevenue);
      } else if (selectedTimeRevenue.value == 'Monthly') {
        return isDataAvailable(monthlyRevenue);
      }
    } catch (e, stack) {
      developer.log("Error in shouldShowChart", error: e, stackTrace: stack);
    }
    return false;
  }

  bool isDataAvailable(Map<String, double> data) {
    try {
      return data.values.any((value) => value > 0);
    } catch (e, stack) {
      developer.log("Error in isDataAvailable", error: e, stackTrace: stack);
      return false;
    }
  }

  List<BarChartGroupData> getBarGroups() {
    try {
      Map<String, double> dailyReven = dailyRevenue;
      Map<String, double> monthlyReve = monthlyRevenue;

      if (selectedTimeRevenue.value == 'Weekly') {
        List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

        return daysOfWeek.asMap().entries.map((entry) {
          String day = entry.value;
          double revenue = dailyReven[day] ?? 0.0;
          return BarChartGroupData(
            x: entry.key,
            barRods: [BarChartRodData(toY: revenue)],
          );
        }).toList();
      } else if (selectedTimeRevenue.value == 'Monthly') {
        List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        return months.asMap().entries.map((entry) {
          String month = entry.value;
          double revenue = monthlyReve[month] ?? 0.0;
          return BarChartGroupData(
            x: entry.key,
            barRods: [BarChartRodData(toY: revenue)],
          );
        }).toList();
      }
    } catch (e, stack) {
      developer.log("Error in getBarGroups", error: e, stackTrace: stack);
    }

    return [];
  }

  void calculationOfRevenue() {
    try {
      Timestamp today = Timestamp.now();
      DateTime todayDate = today.toDate();
      int currentYear = todayDate.year;
      DateTime weekStartDate = todayDate.subtract(Duration(days: 6));

      Map<String, double> tempDailyRevenue = {
        'Mon': 0.0,
        'Tue': 0.0,
        'Wed': 0.0,
        'Thu': 0.0,
        'Fri': 0.0,
        'Sat': 0.0,
        'Sun': 0.0,
      };
      Map<String, double> tempMonthlyRevenue = {
        'Jan': 0.0,
        'Feb': 0.0,
        'Mar': 0.0,
        'Apr': 0.0,
        'May': 0.0,
        'Jun': 0.0,
        'Jul': 0.0,
        'Aug': 0.0,
        'Sep': 0.0,
        'Oct': 0.0,
        'Nov': 0.0,
        'Dec': 0.0,
      };

      for (OrderModel order in orderCompletedList) {
        if (order.createdAt != null) {
          DateTime orderDate = order.createdAt!.toDate();

          if (orderDate.year == currentYear) {
            if (orderDate.isAfter(weekStartDate) && orderDate.isBefore(todayDate.add(Duration(days: 1)))) {
              String dayOfWeek = getDayOfWeek(orderDate);
              double orderSubtotal = double.tryParse(order.subTotal ?? '0') ?? 0.0;
              weeklyEarning.value += orderSubtotal;
              tempDailyRevenue[dayOfWeek] = tempDailyRevenue[dayOfWeek]! + orderSubtotal;
            }

            String month = getMonthName(orderDate);
            double orderSubtotal = double.tryParse(order.subTotal ?? '0') ?? 0.0;
            totalEarning.value += orderSubtotal;
            tempMonthlyRevenue[month] = tempMonthlyRevenue[month]! + orderSubtotal;
          }
        }
      }

      dailyRevenue.value = tempDailyRevenue;
      monthlyRevenue.value = tempMonthlyRevenue;

      if (tempDailyRevenue.values.every((value) => value == 0)) {
        if (kDebugMode) {}
      }
      if (tempMonthlyRevenue.values.every((value) => value == 0)) {
        if (kDebugMode) {}
      }
    } catch (e, stack) {
      developer.log("Error in calculationOfRevenue", error: e, stackTrace: stack);
    }
  }

  void updateChartData(int rejectedCount, int completedCount, int cancelledCount) {
    try {
      pieData.value = [
        PieData('Rejected', rejectedCount, '$rejectedCount', AppThemeData.danger300),
        PieData('Completed', completedCount, '$completedCount', AppThemeData.secondary300),
        PieData('Cancelled', cancelledCount, '$cancelledCount', AppThemeData.info300),
      ];
    } catch (e, stack) {
      developer.log("Error in updateChartData", error: e, stackTrace: stack);
    }
  }

  void fetchOrderStats() async {
    Timestamp today = Timestamp.now();
    isLoadingChatData.value = true;

    try {
      int rejectedOrdersCount = 0;
      int completedOrdersCount = 0;
      int cancelledOrdersCount = 0;

      if (selectedTimeTotalOrders.value == 'Monthly') {
        DateTime startOfYear = DateTime(today.toDate().year, 1, 1);
        DateTime endOfYear = DateTime(today.toDate().year + 1, 1, 0, 23, 59, 59);
        Timestamp startOfYearTimestamp = Timestamp.fromDate(startOfYear);
        Timestamp endOfYearTimestamp = Timestamp.fromDate(endOfYear);

        rejectedOrdersCount = rejectOrderList.where((order) {
          Timestamp orderTimestamp = order.createdAt!;
          return orderTimestamp.compareTo(startOfYearTimestamp) >= 0 && orderTimestamp.compareTo(endOfYearTimestamp) <= 0;
        }).length;

        completedOrdersCount = orderCompletedList.where((order) {
          Timestamp orderTimestamp = order.createdAt!;
          return order.orderStatus == 'order_complete' && orderTimestamp.compareTo(startOfYearTimestamp) >= 0 && orderTimestamp.compareTo(endOfYearTimestamp) <= 0;
        }).length;

        cancelledOrdersCount = rejectOrderList.where((order) {
          Timestamp orderTimestamp = order.createdAt!;
          return order.orderStatus == 'order_cancel' && orderTimestamp.compareTo(startOfYearTimestamp) >= 0 && orderTimestamp.compareTo(endOfYearTimestamp) <= 0;
        }).length;
      } else if (selectedTimeTotalOrders.value == 'Weekly') {
        DateTime weekStartDate = today.toDate().subtract(Duration(days: 7));
        DateTime weekEndDate = today.toDate();
        Timestamp weekStartTimestamp = Timestamp.fromDate(weekStartDate);
        Timestamp weekEndTimestamp = Timestamp.fromDate(weekEndDate);

        rejectedOrdersCount = rejectOrderList.where((order) {
          Timestamp orderTimestamp = order.createdAt!;
          return orderTimestamp.compareTo(weekStartTimestamp) >= 0 && orderTimestamp.compareTo(weekEndTimestamp) <= 0;
        }).length;

        completedOrdersCount = orderCompletedList.where((order) {
          Timestamp orderTimestamp = order.createdAt!;
          return order.orderStatus == 'order_complete' && orderTimestamp.compareTo(weekStartTimestamp) >= 0 && orderTimestamp.compareTo(weekEndTimestamp) <= 0;
        }).length;

        cancelledOrdersCount = rejectOrderList.where((order) {
          Timestamp orderTimestamp = order.createdAt!;
          return order.orderStatus == 'order_cancel' && orderTimestamp.compareTo(weekStartTimestamp) >= 0 && orderTimestamp.compareTo(weekEndTimestamp) <= 0;
        }).length;
      }

      rejectedOrderListCount.value = rejectedOrdersCount;
      completedOrderListCount.value = completedOrdersCount;
      cancelledOrderListCount.value = cancelledOrdersCount;

      updateChartData(rejectedOrdersCount, completedOrdersCount, cancelledOrdersCount);
    } catch (e, stack) {
      developer.log("Error in fetchOrderStats", error: e, stackTrace: stack);
    } finally {
      isLoadingChatData.value = false;
    }
  }
}

String getMonthName(DateTime date) {
  try {
    List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  } catch (e, stack) {
    developer.log("Error in getMonthName", error: e, stackTrace: stack);
    return 'Unknown';
  }
}

String getDayOfWeek(DateTime date) {
  try {
    List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek[date.weekday - 1];
  } catch (e, stack) {
    developer.log("Error in getDayOfWeek", error: e, stackTrace: stack);
    return 'Unknown';
  }
}
