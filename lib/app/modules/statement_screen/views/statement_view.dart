// ignore_for_file: depend_on_referenced_packages

import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../controllers/statement_controller.dart';

class StatementView extends StatelessWidget {
  const StatementView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: StatementController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: paddingEdgeInsets(horizontal: 0, vertical: 34),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    ),
                    height: 34.h,
                    width: 34.w,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Statement Download".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 32),
                    // const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        "assets/animation/gif_statement.gif",
                        height: 100,
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextCustom(
                        title: "Download Order Statement".tr,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextCustom(
                        title: "Select your preferred order type, choose a date range and download your order statement".tr,
                        textAlign: TextAlign.center,
                        maxLine: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey100,
                      ),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextCustom(
                            title: "Select Time".tr,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            return DropdownButtonFormField(
                              borderRadius: BorderRadius.circular(15),
                              isExpanded: true,
                              style: TextStyle(
                                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                fontSize: 16,
                              ),
                              onChanged: (String? statusType) {
                                final now = DateTime.now();
                                controller.selectedDateOption.value = statusType ?? "All";

                                switch (statusType) {
                                  case 'Last Month':
                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                      start: now.subtract(const Duration(days: 30)),
                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                    );
                                    break;
                                  case 'Last 6 Months':
                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                      start: DateTime(now.year, now.month - 6, now.day),
                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                    );
                                    break;
                                  case 'Last Year':
                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                      start: DateTime(now.year - 1, now.month, now.day),
                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                    );
                                    break;
                                  case 'Custom':
                                    controller.isCustomVisible.value = true;
                                    break;
                                  case 'All':
                                  default:
                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                      start: DateTime(now.year, 1, 1),
                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                    );
                                    break;
                                }

                                controller.isCustomVisible.value = statusType == 'Custom';

                              },
                              initialValue: controller.selectedDateOption.value,
                              items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: TextCustom(
                                    title: value,
                                    fontSize: 16,
                                  ),
                                );
                              }).toList(),
                              decoration: Constant.DefaultInputDecoration(context),
                            );
                          }),
                          const SizedBox(height: 20),
                          Obx(
                            () => Visibility(
                              visible: controller.isCustomVisible.value,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                    title: "Select Star date to End Date".tr,
                                    fontSize: 16,
                                    fontFamily: FontFamily.medium,
                                  ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () {
                                      showDateRangePickerForPdf(context, controller);
                                    },
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width * 0.9,
                                      padding: const EdgeInsets.all(12),
                                      height: 56,
                                      margin: const EdgeInsets.only(top: 4),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(
                                            () => TextCustom(
                                              title: controller.selectedDateRangeForPdf.value.start == DateTime(DateTime.now().year, DateTime.january, 1) &&
                                                      controller.selectedDateRangeForPdf.value.end == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0)
                                                  ? "Select Date".tr
                                                  : "${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.start)} to ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.end)}",
                                              fontSize: 16,
                                              fontFamily: FontFamily.medium,

                                            ),
                                          ),
                                          Icon(
                                            Icons.calendar_month_outlined,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            size: 24,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Center(
                            child: RoundShapeButton(
                                size: Size(Responsive.width(100, context), 54),
                                title: "Download".tr,
                                buttonColor: AppThemeData.primary300,
                                buttonTextColor: AppThemeData.primaryWhite,
                                onTap: () {
                                  controller.dataGetForPdf();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> showDateRangePickerForPdf(BuildContext context, StatementController controller) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Order Booking Date'.tr),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              maxDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                if (args.value is PickerDateRange) {
                  controller.startDateForPdf = (args.value as PickerDateRange).startDate;
                  controller.endDateForPdf = (args.value as PickerDateRange).endDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  Navigator.of(context).pop();
                },
                child: Text('clear'.tr)),
            TextButton(
              onPressed: () async {
                if (controller.startDateForPdf != null && controller.endDateForPdf != null) {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(start: controller.startDateForPdf!, end: DateTime(controller.endDateForPdf!.year, controller.endDateForPdf!.month, controller.endDateForPdf!.day, 23, 59, 0, 0));
                }
                Navigator.of(context).pop();
              },
              child: Text('OK'.tr),
            ),
          ],
        );
      },
    );
  }
}
