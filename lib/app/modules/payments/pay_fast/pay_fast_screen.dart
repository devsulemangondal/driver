// ignore_for_file: file_names, depend_on_referenced_packages, deprecated_member_use

import 'dart:developer' as developer;

import 'package:driver/app/models/payment_method_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayFastScreen extends StatefulWidget {
  final String htmlData;
  final PayFast payFastSettingData;

  const PayFastScreen({super.key, required this.htmlData, required this.payFastSettingData});

  @override
  State<PayFastScreen> createState() => _PayFastScreenState();
}

class _PayFastScreenState extends State<PayFastScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    initController();
    super.initState();
  }

  void initController() {
    try {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
            },
            onWebResourceError: (WebResourceError error) {
            },
            onNavigationRequest: (NavigationRequest navigation) async {
              try {
                if (kDebugMode) {
                }

                if (navigation.url == widget.payFastSettingData.returnUrl) {
                  Get.back(result: true);
                } else if (navigation.url == widget.payFastSettingData.notifyUrl) {
                  Get.back(result: false);
                } else if (navigation.url == widget.payFastSettingData.cancelUrl) {
                  _showMyDialog();
                }
              } catch (e, stack) {
                developer.log(
                  "Error in navigation request",
                  error: e,
                  stackTrace: stack,
                );
              }
              return NavigationDecision.navigate;
            },
          ),
        );

      controller.loadHtmlString(widget.htmlData);
    } catch (e, stack) {
      developer.log("Error in initController", error: e, stackTrace: stack);
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showMyDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _showMyDialog();
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    try {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cancel Payment'),
            content: const SingleChildScrollView(
              child: Text("cancelPayment?"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Exit',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  try {
                    Get.back();
                  } catch (e, stack) {
                    developer.log("Error in exit payment", error: e, stackTrace: stack);
                  }
                },
              ),
              TextButton(
                child: const Text(
                  'Continue Payment',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  try {
                    Get.back();
                  } catch (e, stack) {
                    developer.log("Error in continue payment", error: e, stackTrace: stack);
                  }
                },
              ),
            ],
          );
        },
      );
    } catch (e, stack) {
      developer.log("Error in _showMyDialog", error: e, stackTrace: stack);
    }
  }
}
