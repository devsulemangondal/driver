// ignore_for_file: unnecessary_overrides, invalid_use_of_protected_member, depend_on_referenced_packages, non_constant_identifier_names, unused_catch_stack

import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math' as maths;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/app/models/bank_details_model.dart';
import 'package:driver/app/models/driver_user_model.dart';

import 'package:driver/app/models/payment_method_model.dart';
import 'package:driver/app/models/payment_model/stripe_failed_model.dart';
import 'package:driver/app/models/transaction_log_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/my_wallet/views/widgets/complete_add_money.dart';
import 'package:driver/app/modules/payments/marcado_pago/mercado_pago_screen.dart';
import 'package:driver/app/modules/payments/pay_fast/pay_fast_screen.dart';
import 'package:driver/app/modules/payments/pay_stack/pay_stack_screen.dart';
import 'package:driver/app/modules/payments/pay_stack/pay_stack_url_model.dart';
import 'package:driver/app/modules/payments/pay_stack/paystack_url_generator.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/payments/flutter_wave/flutter_wave.dart';
import 'package:driver/payments/paypal/PaypalPayment.dart';
import 'package:driver/services/email_template_service.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart' as razor_pay_flutter;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../payments/midtrans/midtrans_payment_screen.dart';
import '../../../../payments/xendit/xendit_model.dart';
import '../../../../payments/xendit/xendit_payment_screen.dart';

class MyWalletController extends GetxController {
  TextEditingController amountController = TextEditingController(text: Constant.minimumAmountToDeposit);
  TextEditingController withdrawalAmountController = TextEditingController(text: Constant.minimumAmountToWithdrawal);
  TextEditingController withdrawalNoteController = TextEditingController();
  Rx<PaymentModel> paymentModel = PaymentModel().obs;
  RxString selectedPaymentMethod = "".obs;
  razor_pay_flutter.Razorpay _razorpay = razor_pay_flutter.Razorpay();
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<BankDetailsModel> selectedBankMethod = BankDetailsModel().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
  RxList<BankDetailsModel> bankDetailsList = <BankDetailsModel>[].obs;
  RxInt selectedTabIndex = 0.obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxList<String> addMoneyTagList = <String>[].obs;
  RxList<String> withdrawMoneyTagList = <String>[].obs;

  RxString selectedAddAmountTags = Constant.minimumAmountToDeposit.obs;
  RxString selectedWithDrawTags = Constant.minimumAmountToWithdrawal.obs;
  Rx<TransactionLogModel> transactionLogModel = TransactionLogModel().obs;

  @override
  void onInit() {
    getPayments();
    generateDefaultAmounts();
    generateDefaultAmountsForWithdraw();
    amountController.addListener(onAmountChanged);
    withdrawalAmountController.addListener(_onWithdrawalAmountChanged);
    super.onInit();
  }

  void generateDefaultAmounts() {
    try {
      int baseAmount = int.tryParse(Constant.minimumAmountToDeposit) ?? 10; // fallback value
      if (baseAmount <= 0) baseAmount = 10;

      addMoneyTagList.value = [1, 2, 3, 5, 10].map((multiplier) => (baseAmount * multiplier).toString()).toList();
    } catch (e, stack) {
      developer.log("Error generating deposit amounts", error: e, stackTrace: stack);
      addMoneyTagList.value = [];
    }
  }

  void generateDefaultAmountsForWithdraw() {
    try {
      int baseAmount = int.tryParse(Constant.minimumAmountToWithdrawal) ?? 10;
      if (baseAmount <= 0) baseAmount = 10;
      withdrawMoneyTagList.value = [1, 2, 3, 5, 10].map((multiplier) => (baseAmount * multiplier).toString()).toList();
    } catch (e, stack) {
      developer.log("Error to generate withdrawal amounts", error: e, stackTrace: stack);

      withdrawMoneyTagList.value = [];
    }
  }

  void onAmountChanged() {
    try {
      if (addMoneyTagList.contains(amountController.text)) {
        selectedAddAmountTags.value = amountController.text;
      } else {
        selectedAddAmountTags.value = "";
      }
    } catch (e, stack) {
      developer.log("Error amount change", error: e, stackTrace: stack);
      selectedAddAmountTags.value = "";
    }
  }

  void _onWithdrawalAmountChanged() {
    try {
      if (withdrawMoneyTagList.contains(withdrawalAmountController.text)) {
        selectedWithDrawTags.value = withdrawalAmountController.text;
      } else {
        selectedWithDrawTags.value = "";
      }
    } catch (e, stack) {
      developer.log("Error to withdrawal amount change", error: e, stackTrace: stack);
      selectedWithDrawTags.value = "";
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _razorpay.clear();
    amountController.removeListener(onAmountChanged);
    withdrawalAmountController.removeListener(_onWithdrawalAmountChanged);
    amountController.dispose();
    withdrawalAmountController.dispose();

    super.onClose();
  }

  Future<void> getPayments() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    await FireStoreUtils().getPayment().then((value) {
      if (value != null) {
        paymentModel.value = value;
        if (paymentModel.value.strip!.isActive == true) {
          Stripe.publishableKey = paymentModel.value.strip!.clientPublishableKey.toString();
          Stripe.merchantIdentifier = 'Go4Food';
          Stripe.instance.applySettings();
        }
        if (paymentModel.value.flutterWave!.isActive == true) {
          setRef();
        }
      }
    });
    await getWalletTransactions();
    await getProfileData();
    await getBankDetails();
    ShowToastDialog.closeLoader();
  }

  Future<void> getBankDetails() async {
    try {
      bankDetailsList.clear();
      final value = await FireStoreUtils.getBankDetailList(FireStoreUtils.getCurrentUid());
      if (value != null) {
        bankDetailsList.addAll(value);
        if (bankDetailsList.isNotEmpty) {
          selectedBankMethod.value = bankDetailsList[0];
        }
      }
    } catch (e, stack) {
      developer.log("Error Failed to fetch bank details", error: e, stackTrace: stack);
    }
  }

  Future<void> getWalletTransactions() async {
    try {
      final value = await FireStoreUtils.getWalletTransaction();
      walletTransactionList.value = value ?? [];
    } catch (e, stack) {
      developer.log("Error to Failed to fetch wallet transactions", error: e, stackTrace: stack);
    }
  }

  Future<void> getProfileData() async {
    try {
      final value = await FireStoreUtils.getDriverProfile(FireStoreUtils.getCurrentUid());
      if (value != null) {
        driverModel.value = value;
      }
    } catch (e, stack) {
      developer.log("Error to Failed to fetch profile data", error: e, stackTrace: stack);
    }
  }

  Future<void> setTransactionLog({
    required String transactionId,
    dynamic transactionLog,
    required bool isCredit,
  }) async {
    try {
      transactionLogModel.value.amount = amountController.text;
      transactionLogModel.value.transactionId = transactionId;
      transactionLogModel.value.id = transactionId;
      transactionLogModel.value.transactionLog = transactionLog.toString();
      transactionLogModel.value.isCredit = isCredit;
      transactionLogModel.value.createdAt = Timestamp.now();
      transactionLogModel.value.userId = FireStoreUtils.getCurrentUid();
      transactionLogModel.value.paymentType = selectedPaymentMethod.value;
      transactionLogModel.value.type = 'wallet';

      await FireStoreUtils.setTransactionLog(transactionLogModel.value);
    } catch (e, stack) {
      developer.log("Error to Failed to set transaction log", error: e, stackTrace: stack);
    }
  }

  Future<void> completeTransaction(String transactionId) async {
    try {
      WalletTransactionModel transactionModel = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: amountController.value.text,
        createdDate: Timestamp.now(),
        paymentType: selectedPaymentMethod.value,
        transactionId: transactionId,
        userId: FireStoreUtils.getCurrentUid(),
        isCredit: true,
        type: Constant.driver,
        note: "Added to wallet",
      );

      ShowToastDialog.showLoader("Please Wait..".tr);

      bool? isSet = await FireStoreUtils.setWalletTransaction(transactionModel);
      if (isSet == true) {
        await FireStoreUtils.updateDriverWallet(amount: amountController.value.text);
        await getProfileData();
        await getWalletTransactions();
        ShowToastDialog.showToast("Amount added to your wallet.".tr);
        await EmailTemplateService.sendEmail(
          type: 'wallet_topup',
          toEmail: driverModel.value.email.toString(),
          variables: {
            'name': "${driverModel.value.firstName} ${driverModel.value.lastName}",
            'amount': Constant.amountShow(amount: amountController.value.text),
            'balance': Constant.amountShow(amount: driverModel.value.walletAmount.toString()),
          },
        );
      } else {
        ShowToastDialog.showToast("Failed to add amount to wallet.".tr);
      }
    } catch (e, stack) {
      developer.log("Error to Something went wrong", error: e, stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> stripeMakePayment({required String amount}) async {
    try {
      Map<String, dynamic>? paymentIntentData = await createStripeIntent(amount: amount);
      if (paymentIntentData == null || paymentIntentData.containsKey("error")) {
        Get.back();
        ShowToastDialog.showToast("Something went wrong. Please contact support.".tr);
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          allowsDelayedPaymentMethods: false,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
            currencyCode: "USD",
          ),
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: AppThemeData.primary300,
            ),
          ),
          merchantDisplayName: 'Go4Food',
        ),
      );

      await displayStripePaymentSheet(amount: amount, client_secret: paymentIntentData['client_secret']);
    } catch (e, stack) {
      developer.log("Error:Exception ", error: e, stackTrace: stack);
      ShowToastDialog.showToast("Exception: $e\n$stack");
    }
  }

  Future<void> displayStripePaymentSheet({required String amount, required String client_secret}) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        ShowToastDialog.showToast("Payment completed successfully.".tr);
        await Stripe.instance.retrievePaymentIntent(client_secret).then(
          (value) {
            completeTransaction(value.id);
            setTransactionLog(isCredit: true, transactionId: value.id, transactionLog: value);
          },
        );
        Get.offAll(() => CompleteAddMoneyView());
      });
    } on StripeException catch (e, stack) {
      developer.log("Error:Failed to display payment sheet", error: e, stackTrace: stack);
      var lo1 = jsonEncode(e);
      var lo2 = jsonDecode(lo1);
      StripePayFailedModel lom = StripePayFailedModel.fromJson(lo2);
      ShowToastDialog.showToast(lom.error.message);
    } catch (e, stack) {
      developer.log("Error:Failed to display payment sheet", error: e, stackTrace: stack);
    }
  }

  Future createStripeIntent({required String amount}) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': "USD",
        'payment_method_types[]': 'card',
        "description": "Strip Payment",
        "shipping[name]": driverModel.value.firstName,
        "shipping[address][line1]": "510 Townsend St",
        "shipping[address][postal_code]": "98140",
        "shipping[address][city]": "San Francisco",
        "shipping[address][state]": "CA",
        "shipping[address][country]": "US",
      };
      var stripeSecret = paymentModel.value.strip!.stripeSecret;
      var response =
          await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'), body: body, headers: {'Authorization': 'Bearer $stripeSecret', 'Content-Type': 'application/x-www-form-urlencoded'});

      return jsonDecode(response.body);
    } catch (e, stack) {
      developer.log("Error:Failed to create Stripe intent", error: e, stackTrace: stack);
    }
  }

  // ::::::::::::::::::::::::::::::::::::::::::::PayPal::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> payPalPayment({required String amount}) async {
    try {
      ShowToastDialog.closeLoader();
      await Get.to(() => PaypalPayment(
            onFinish: (result) async {
              if (result != null) {
                Get.back();
                ShowToastDialog.showToast("Payment processed successfully.".tr);
                await completeTransaction(result['orderId']);
                await setTransactionLog(
                  isCredit: true,
                  transactionId: result['orderId'],
                  transactionLog: result,
                );
                Get.offAll(() => CompleteAddMoneyView());
              } else {
                ShowToastDialog.showToast("Payment failed or was canceled.".tr);
              }
            },
            price: amount,
            currencyCode: "USD",
            title: "Add Money",
            description: "Add Balance in Wallet",
          ));
    } catch (e, stack) {
      developer.log("Error:Failed to process PayPal payment", error: e, stackTrace: stack);
    }
  }

  Future<void> razorpayMakePayment({required String amount}) async {
    try {
      var options = {
        'key': paymentModel.value.razorpay!.razorpayKey,
        "razorPaySecret": paymentModel.value.razorpay!.razorpaySecret,
        'amount': (double.parse(amount) * 100).toInt(), // safer to send int amount
        "currency": "INR",
        'name': driverModel.value.firstName,
        "isSandBoxEnabled": paymentModel.value.razorpay!.isSandbox,
        'external': {
          'wallets': ['paytm']
        },
        'send_sms_hash': true,
        'prefill': {'contact': driverModel.value.phoneNumber, 'email': driverModel.value.email},
      };

      _razorpay.open(options);

      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
        try {
          _handlePaymentSuccess(response);
        } catch (e, stack) {
          developer.log("Error:Failed to handle payment success", error: e, stackTrace: stack);
        }
      });

      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_PAYMENT_ERROR, (response) {
        try {
          _handlePaymentError(response);
        } catch (e, stack) {
          developer.log("Error:Failed to handle payment error", error: e, stackTrace: stack);
        }
      });

      _razorpay.on(razor_pay_flutter.Razorpay.EVENT_EXTERNAL_WALLET, (response) {
        try {
          _handleExternalWallet(response);
        } catch (e, stack) {
          developer.log("Error:Failed to handle external wallet", error: e, stackTrace: stack);
        }
      });
    } catch (e, stack) {
      developer.log("Error:Failed to initiate Razorpay payment", error: e, stackTrace: stack);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      ShowToastDialog.showToast("Payment completed successfully.".tr);

      String transactionId = response.paymentId ?? DateTime.now().millisecondsSinceEpoch.toString();
      completeTransaction(transactionId);

      setTransactionLog(
        isCredit: true,
        transactionId: transactionId,
        transactionLog: {response.paymentId, response.paymentId, response.data, response.orderId, response.signature},
      );

      Get.offAll(() => CompleteAddMoneyView());
      _razorpay.clear();
      _razorpay = razor_pay_flutter.Razorpay();

      ShowToastDialog.closeLoader();
    } catch (e, stack) {
      developer.log("Error:Failed to handle payment success", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      ShowToastDialog.showToast("Transaction failed. Please try again.".tr);
    } catch (e, stack) {
      developer.log("Error:Failed to handle payment error", error: e, stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    try {
      ShowToastDialog.closeLoader();
    } catch (e, stack) {
      developer.log("Error:Failed to handle external wallet", error: e, stackTrace: stack);
    }
  }

  Future<void> flutterWaveInitiatePayment({
    required BuildContext context,
    required String amount,
  }) async {
    try {
      final url = Uri.parse('https://api.flutterwave.com/v3/payments');
      final headers = {
        'Authorization': 'Bearer ${paymentModel.value.flutterWave!.secretKey}',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        "tx_ref": _ref,
        "amount": amount,
        "currency": "USD",
        "redirect_url": '${Constant.paymentCallbackURL}/success',
        "payment_options": "ussd, card, barter, payattitude",
        "customer": {
          "email": Constant.driverUserModel!.email,
          "phonenumber": Constant.driverUserModel!.phoneNumber!,
          "name": (Constant.driverUserModel!.firstName ?? '') + (Constant.driverUserModel!.lastName ?? ''),
        },
        "customizations": {
          "title": "Payment for Services",
          "description": "Payment for XYZ services",
        }
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        ShowToastDialog.closeLoader();
        final result = await Get.to(() => FlutterWaveScreen(initialURl: data['data']['link']));

        if (result != null && result is Map<String, dynamic>) {
          if (result["status"] == true) {
            ShowToastDialog.showToast("Payment processed successfully.".tr);
            await completeTransaction(result['transaction_id'] ?? '');
            await setTransactionLog(
              isCredit: true,
              transactionId: result['transaction_id'],
              transactionLog: result,
            );
          } else {
            ShowToastDialog.showToast("Payment unsuccessful!".tr);
          }
        } else {
          ShowToastDialog.showToast("Payment unsuccessful!".tr);
        }
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Failed to initiate payment. Please try again.".tr);
        if (kDebugMode) {}
      }
    } catch (e, stack) {
      developer.log("Error:Failed to initiate FlutterWave payment", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("An error occurred. Please try again.".tr);
      if (kDebugMode) {}
    }
  }

  String? _ref;

  void setRef() {
    try {
      final maths.Random numRef = maths.Random();
      final int year = DateTime.now().year;
      final int refNumber = numRef.nextInt(20000);
      if (Platform.isAndroid) {
        _ref = "AndroidRef$year$refNumber";
      } else if (Platform.isIOS) {
        _ref = "IOSRef$year$refNumber";
      }
    } catch (e, stack) {
      developer.log("Error:Failed to set reference", error: e, stackTrace: stack);
      if (kDebugMode) {}
      _ref = "DefaultRef${DateTime.now().millisecondsSinceEpoch}";
    }
  }

  Future<void> payStackPayment(String totalAmount) async {
    try {
      final value = await PayStackURLGen.payStackURLGen(
        amount: (double.parse(totalAmount) * 100).toString(),
        currency: "NGN",
        secretKey: paymentModel.value.payStack!.payStackSecret.toString(),
        ownerModel: driverModel.value,
      );

      if (value != null) {
        PayStackUrlModel payStackModel = value;
        final result = await Get.to(PayStackScreen(
          secretKey: paymentModel.value.payStack!.payStackSecret.toString(),
          callBackUrl: Constant.paymentCallbackURL.toString(),
          initialURl: payStackModel.data.authorizationUrl,
          amount: totalAmount,
          reference: payStackModel.data.reference,
        ));

        if (result == true) {
          ShowToastDialog.showToast("Payment processed successfully.".tr);
          await completeTransaction(DateTime.now().millisecondsSinceEpoch.toString());
          Get.offAll(() => CompleteAddMoneyView());
        } else {
          ShowToastDialog.showToast("Payment unsuccessful!".tr);
        }
      } else {
        ShowToastDialog.showToast("Something went wrong. Please contact support.".tr);
      }
    } catch (e, stack) {
      developer.log("Error:Failed to process PayStack payment", error: e, stackTrace: stack);
      if (kDebugMode) {}
      ShowToastDialog.showToast("Something went wrong. Please contact support.".tr);
    }
  }

  void mercadoPagoMakePayment({required BuildContext context, required String amount}) {
    makePreference(amount).then((result) async {
      try {
        if (result != null && result.isNotEmpty) {
          log(result.toString());
          if (result['status'] == 200) {
            var preferenceId = result['response']['id'];
            log(preferenceId.toString());

            var value = await Get.to(() => MercadoPagoScreen(initialURl: result['response']['init_point']));
            log(value.toString());

            if (value == true) {
              ShowToastDialog.showToast("Payment processed successfully.".tr);
              await completeTransaction(DateTime.now().millisecondsSinceEpoch.toString());
              Get.offAll(() => CompleteAddMoneyView());
            } else {
              ShowToastDialog.showToast("Payment failed!".tr);
            }
          } else {
            ShowToastDialog.showToast("Transaction error occurred.".tr);
          }
        } else {
          ShowToastDialog.showToast("Transaction error occurred.".tr);
        }
      } catch (e, stack) {
        developer.log("Error:Failed to process Mercado Pago payment", error: e, stackTrace: stack);
        ShowToastDialog.showToast("Unable to process the request. Please try again.".tr);
      }
    });
  }

  Future<Map<String, dynamic>?> makePreference(String amount) async {
    try {
      final mp = MP.fromAccessToken(paymentModel.value.mercadoPago!.mercadoPagoAccessToken);
      var pref = {
        "items": [
          {"title": "Wallet TopUp", "quantity": 1, "unit_price": double.parse(amount)}
        ],
        "auto_return": "all",
        "back_urls": {"failure": "${Constant.paymentCallbackURL}/failure", "pending": "${Constant.paymentCallbackURL}/pending", "success": "${Constant.paymentCallbackURL}/success"},
      };

      var result = await mp.createPreference(pref);
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<void> payFastPayment({required BuildContext context, required String amount}) async {
    try {
      String? htmlData = await PayStackURLGen.getPayHTML(
        payFastSettingData: paymentModel.value.payFast!,
        amount: amount.toString(),
        ownerModel: driverModel.value,
      );

      bool isDone = await Get.to(() => PayFastScreen(htmlData: htmlData, payFastSettingData: paymentModel.value.payFast!)) ?? false;

      if (isDone) {
        Get.back();
        ShowToastDialog.showToast("Payment completed successfully.".tr);
        await completeTransaction(DateTime.now().millisecondsSinceEpoch.toString());
        Get.offAll(() => CompleteAddMoneyView());
      } else {
        Get.back();
        ShowToastDialog.showToast("Payment failed!".tr);
      }
    } catch (e, stack) {
      developer.log("Error:Failed to process PayFast payment", error: e, stackTrace: stack);
    }
  }

// :::::::::::::::::::::::::::::::::::::::::::: Xendit ::::::::::::::::::::::::::::::::::::::::::::::::::::
  Future<void> xenditPayment({required BuildContext context, required String amount}) async {
    await createXenditInvoice(amount: double.parse(amount)).then((value) {
      if (value != null) {
        Get.to(
          () => XenditPaymentScreen(
            apiKey: Constant.paymentModel!.xendit!.xenditSecretKey.toString(),
            transId: value.id,
            invoiceUrl: value.invoiceUrl,
          ),
        )!
            .then((value) async {
          if (value == true) {
            Get.back();
            ShowToastDialog.showToast("Payment completed successfully.".tr);
            await completeTransaction(DateTime.now().millisecondsSinceEpoch.toString());
            Get.offAll(() => CompleteAddMoneyView());
          } else {
            log("====>Payment Faild");
          }
        });
      }
    });
  }

  Future<XenditModel?> createXenditInvoice({required num amount}) async {
    const url = 'https://api.xendit.co/v2/invoices';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(Constant.paymentModel!.xendit!.xenditSecretKey.toString()),
    };

    final body = jsonEncode({
      'external_id': const Uuid().v1(),
      'amount': amount,
      'payer_email': driverModel.value.email.toString(),
      'description': 'Wallet Topup',
      'currency': 'IDR',
    });

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return XenditModel.fromJson(jsonDecode(response.body));
      } else {
        log("❌ Xendit Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("⚠️ Exception: $e");
      return null;
    }
  }

  String generateBasicAuthHeader(String apiKey) {
    String credentials = '$apiKey:';
    String base64Encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $base64Encoded';
  }

// :::::::::::::::::::::::::::::::::::::::::::: MidTrans ::::::::::::::::::::::::::::::::::::::::::::::::::::

  Future<void> midtransPayment({required BuildContext context, required String amount}) async {
    final url = await createMidtransPaymentLink(
      orderId: 'order-${DateTime.now().millisecondsSinceEpoch}',
      amount: double.parse(amount),
      customerEmail: driverModel.value.email.toString(),
    );

    if (url != null) {
      final result = await Get.to(() => MidtransPaymentScreen(paymentUrl: url));
      if (result == true) {
        Get.back();
        ShowToastDialog.showToast("Payment completed successfully.".tr);
        await completeTransaction(DateTime.now().millisecondsSinceEpoch.toString());
        Get.offAll(() => CompleteAddMoneyView());
      } else {
        if (kDebugMode) {
          print("Payment Failed or Cancelled");
        }
      }
    }
  }

  Future<String?> createMidtransPaymentLink({required String orderId, required double amount, required String customerEmail}) async {
    final String ordersId = orderId.isNotEmpty ? orderId : const Uuid().v1();

    final Uri url = Uri.parse('https://api.sandbox.midtrans.com/v1/payment-links'); // Use production URL for live

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(Constant.paymentModel!.midtrans!.midtransSecretKey.toString()),
    };

    final Map<String, dynamic> body = {
      'transaction_details': {'order_id': ordersId, 'gross_amount': amount.toInt()},
      'item_details': [
        {'id': 'item-1', 'name': 'Sample Product', 'price': amount.toInt(), 'quantity': 1},
      ],
      'customer_details': {'first_name': 'John', 'last_name': 'Doe', 'email': customerEmail, 'phone': '081234567890'},
      'redirect_url': 'https://www.google.com?merchant_order_id=$ordersId',
      'usage_limit': 2,
    };

    final response = await http.post(url, headers: headers, body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['payment_url'];
    } else {
      if (kDebugMode) {
        print('Error creating payment link: ${response.body}');
      }
      return null;
    }
  }
}
