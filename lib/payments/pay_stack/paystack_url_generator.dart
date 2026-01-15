// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:driver/app/models/payment_method_model.dart';
import 'package:driver/app/models/provider_model.dart';
import 'package:driver/app/modules/payments/pay_stack/pay_stack_url_model.dart';
import 'package:http/http.dart' as http;

class PayStackURLGen {
  static Future payStackURLGen({required String amount, required String secretKey, required String currency, required ProviderModel providerModel}) async {
    const url = "https://api.pay_stack.co/transaction/initialize";
    final response = await http.post(Uri.parse(url), body: {
      "email": providerModel.email,
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

    final url = "https://api.pay_stack.co/transaction/verify/$reference";

    var response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $secretKey",
    });

    final data = jsonDecode(response.body);
    if (data["status"] == true) {
      if (data["message"] == "Verification successful") {}
    }

    return data["status"];

    //PayPalClientSettleModel.fromJson(data);
  }

  static Future<String> getPayHTML({required String amount, required PayFast payFastSettingData, required ProviderModel providerModel}) async {
    String newUrl = 'https://${payFastSettingData.isSandbox == false ? "www" : "sandbox"}.payfast.co.za/eng/process';
    Map body = {
      'merchant_id': payFastSettingData.merchantId,
      'merchant_key': payFastSettingData.merchantKey,
      'amount': amount,
      'item_name': "goRide online payment",
      'return_url': payFastSettingData.returnUrl,
      'cancel_url': payFastSettingData.cancelUrl,
      'notify_url': payFastSettingData.notifyUrl,
      'name_first': providerModel.firstName,
      'name_last': providerModel.firstName,
      'email_address': providerModel.email,
    };

    final response = await http.post(
      Uri.parse(newUrl),
      body: body,
    );

    return response.body;
  }
}
