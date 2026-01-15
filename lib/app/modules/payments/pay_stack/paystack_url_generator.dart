// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/payment_method_model.dart';
import 'package:http/http.dart' as http;

import 'pay_stack_url_model.dart';

class PayStackURLGen {
  static Future payStackURLGen({required String amount, required String secretKey, required String currency, required DriverUserModel ownerModel}) async {
    const url = "https://api.pay_stack.co/transaction/initialize";
    final response = await http.post(Uri.parse(url), body: {
      "email": ownerModel.email,
      "amount": amount,
      "currency": currency,
    }, headers: {
      "Authorization": "Bearer $secretKey",
    });
    final data = jsonDecode(response.body);
    if (!data["status"]) {
      return null;
    }
    return PayStackUrlModel.fromJson(data);
  }

  static Future<bool> verifyTransaction({
    required String reference,
    required String secretKey,
    required String amount,
  }) async {
    try {
      final url = "https://api.pay_stack.co/transaction/verify/$reference";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $secretKey",
        },
      );

      final data = jsonDecode(response.body);

      if (data["status"] == true) {
        if (data["message"] == "Verification successful") {

        }
      }
      return data["status"] ?? false;
    } catch (e, stack) {
      developer.log(
        "Error verifying transaction",
        error: e,
        stackTrace: stack,
      );
      return false;
    }
  }

  static Future<String> getPayHTML({required String amount, required PayFast payFastSettingData, required DriverUserModel ownerModel}) async {
    String newUrl = 'https://${payFastSettingData.isSandbox == false ? "www" : "sandbox"}.payfast.co.za/eng/process';
    Map body = {
      'merchant_id': payFastSettingData.merchantId,
      'merchant_key': payFastSettingData.merchantKey,
      'amount': amount,
      'item_name': "goRide online payment",
      'return_url': payFastSettingData.returnUrl,
      'cancel_url': payFastSettingData.cancelUrl,
      'notify_url': payFastSettingData.notifyUrl,
      'name_first': ownerModel.fullNameString(),
      'name_last': ownerModel.fullNameString(),
      'email_address': ownerModel.email,
    };

    final response = await http.post(
      Uri.parse(newUrl),
      body: body,
    );

    return response.body;
  }
}
