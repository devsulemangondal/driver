// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:async';
import 'dart:developer' as developer;

import 'package:driver/app/modules/payments/pay_stack/paystack_url_generator.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PayStackScreen extends StatefulWidget {
  final String initialURl;
  final String reference;
  final String amount;
  final String secretKey;
  final String callBackUrl;

  const PayStackScreen({super.key, required this.initialURl, required this.reference, required this.amount, required this.secretKey, required this.callBackUrl});

  @override
  State<PayStackScreen> createState() => _PayStackScreenState();
}

class _PayStackScreenState extends State<PayStackScreen> {
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
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {
            },
            onNavigationRequest: (NavigationRequest navigation) async {
              try {
                String currentUrl = navigation.url;

                if (currentUrl ==
                    '${Constant.paymentCallbackURL}/success?trxref=${widget.reference}&reference=${widget.reference}' ||
                    currentUrl ==
                        '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}') {
                  final isDone = await PayStackURLGen.verifyTransaction(
                    secretKey: widget.secretKey,
                    reference: widget.reference,
                    amount: widget.amount,
                  );
                  Get.back(result: isDone);
                }

                if (currentUrl ==
                    '${widget.callBackUrl}?trxref=${widget.reference}&reference=${widget.reference}' ||
                    currentUrl == "https://hello.pstk.xyz/callback" ||
                    currentUrl == 'https://standard.pay_stack.co/close') {
                  final isDone = await PayStackURLGen.verifyTransaction(
                    secretKey: widget.secretKey,
                    reference: widget.reference,
                    amount: widget.amount,
                  );
                  Get.back(result: isDone);
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

      controller.loadRequest(Uri.parse(widget.initialURl));
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
            backgroundColor: AppThemeData.primary300,
            title: const Text("Payment"),
            centerTitle: false,
            leading: GestureDetector(
              onTap: () {
                _showMyDialog();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            )),
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
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  try {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(false);
                  } catch (e, stack) {
                    developer.log("Error in cancel payment dialog", error: e, stackTrace: stack);
                  }
                },
              ),
              TextButton(
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  try {
                    Navigator.of(context).pop();
                  } catch (e, stack) {
                    developer.log("Error in continue payment dialog", error: e, stackTrace: stack);
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
