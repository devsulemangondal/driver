// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:driver/app/models/cart_model.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> generateOrdersExcelSheet(List<OrderModel> orderList, DateTimeRange selectedRange) async {
  try {
    if (orderList.isEmpty) {
      ShowToastDialog.showToast("No data found for the selected date range.".tr);
      return;
    }

    String formattedStartDate = DateFormat('dd-MM-yyyy').format(selectedRange.start);
    String formattedEndDate = DateFormat('dd-MM-yyyy').format(selectedRange.end);

    var excel = Excel.createExcel();
    Sheet sheet = excel['Orders_Report'];
    excel.setDefaultSheet('Orders_Report');

    sheet.appendRow([
      TextCellValue("Order ID"),
      TextCellValue("Restaurant Address"),
      TextCellValue("Customer Address"),
      TextCellValue("Total Amount"),
      TextCellValue("Payment Type"),
      TextCellValue("Payment Status"),
      TextCellValue("Delivery Charge"),
      TextCellValue("Items"),
      TextCellValue("Cart IDs"),
      TextCellValue("Add-Ons"),
      TextCellValue("Order Date"),
    ]);

    String formatItems(List<CartModel>? items) {
      if (items == null || items.isEmpty) return '-';
      return items.map((item) => "${item.productName ?? 'Unknown'} (${item.quantity ?? 0})").join("\n");
    }

    String formatCartIds(List<CartModel>? items) {
      if (items == null || items.isEmpty) return '-';
      return items.map((item) => "ID: ${item.id?.toString() ?? '-'}").join(", ");
    }

    String formatAddOns(List<CartModel>? items) {
      if (items == null || items.isEmpty) return '-';
      return items.map((item) {
        if (item.addOns == null || item.addOns!.isEmpty) return '-';
        return item.addOns!.join(", ");
      }).join("\n");
    }

    for (var order in orderList) {
      sheet.appendRow([
        TextCellValue(order.id?.substring(0, 5) ?? '-'),
        TextCellValue(order.vendorAddress?.address ?? '-'),
        TextCellValue(order.customerAddress?.address ?? '-'),
        TextCellValue(order.totalAmount ?? '-'),
        TextCellValue(order.paymentType ?? '-'),
        TextCellValue(order.paymentStatus == true ? "Paid" : "Unpaid"),
        TextCellValue(order.deliveryCharge ?? '-'),
        TextCellValue(formatItems(order.items)),
        TextCellValue(formatCartIds(order.items)),
        TextCellValue(formatAddOns(order.items)),
        TextCellValue(order.createdAt != null ? DateFormat('dd MMM, yyyy  hh:mm a').format(order.createdAt!.toDate()) : "-"),
      ]);
    }
    List<int>? fileBytes = excel.encode();
    if (fileBytes != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/Order_Bookings_${formattedStartDate}_to_$formattedEndDate.xlsx';

      final File file = File(filePath);
      await file.writeAsBytes(fileBytes, flush: true);

      await OpenFile.open(filePath);
    }
  } catch (e) {
    ShowToastDialog.showToast("Failed to generate report. Please try again.".tr);
  }
}
