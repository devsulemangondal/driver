// ignore_for_file: body_might_complete_normally_catch_error, invalid_return_type_for_catch_error, depend_on_referenced_packages, strict_top_level_inference
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/modules/account_disabled_screen.dart';
import 'package:driver/app/modules/home_screen/views/home_screen_view.dart';
import 'package:driver/app/modules/login_screen/views/verify_otp_view.dart';
import 'package:driver/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> resetEmailController = TextEditingController().obs;

  Rx<String?> countryCode = "+91".obs;
  Rx<String> verificationId = "".obs;
  Rx<String> otpCode = "".obs;
  RxBool isPasswordVisible = true.obs;

  RxBool isLoginButtonEnabled = false.obs;
  RxBool isMobileNumberButtonEnabled = false.obs;
  RxBool isVerifyButtonEnabled = false.obs;

  RxInt secondsRemaining = 20.obs;
  RxBool enableResend = false.obs;
  Timer? timer;

  void checkFieldsFilled() {
    try {
      isLoginButtonEnabled.value = emailController.value.text.isNotEmpty && passwordController.value.text.isNotEmpty;

      isMobileNumberButtonEnabled.value = mobileNumberController.value.text.isNotEmpty;
    } catch (e, stack) {
      developer.log("Error in checkFieldsFilled", error: e, stackTrace: stack);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          // Optionally show a debug toast or dialog
        }
      } else {}
    } catch (e, stack) {
      developer.log("Error in resetPassword", error: e, stackTrace: stack);
    }
  }

  void startTimer() {
    try {
      enableResend.value = false;
      secondsRemaining.value = 20;
      timer?.cancel();

      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          enableResend.value = true;
          timer.cancel();
        }
      });
    } catch (e, stack) {
      developer.log("Error in startTimer", error: e, stackTrace: stack);
    }
  }

  Future<void> sendCode() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode.value! + mobileNumberController.value.text,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ShowToastDialog.closeLoader();
          if (e.code == 'invalid-phone-number') {
            ShowToastDialog.showToast("Invalid Phone Number".tr);
          } else {
            ShowToastDialog.showToast("Verification failed: ${e.message}".tr);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          ShowToastDialog.closeLoader();
          this.verificationId.value = verificationId;
          Get.to(() => VerifyOtpView());
          startTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e, stack) {
      developer.log("Error in sendCode", error: e, stackTrace: stack);
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  Future<void> initializeGoogleSignIn() async {
    await googleSignIn.initialize(
      serverClientId: '339012005849-mt8hkep8nt1s0l9djgfp4lbqgol4mrei.apps.googleusercontent.com',
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      initializeGoogleSignIn();
      if (!googleSignIn.supportsAuthenticate()) {
        if (kDebugMode) {
          print('This platform does not support authenticate().');
        }
        return null;
      }

      // Obtain the auth details from the request
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleSignInAccount.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stack) {
      developer.log("Error in signInWithGoogle", error: e, stackTrace: stack);
    }
    return null;
  }

  Future<void> loginWithGoogle() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      final value = await signInWithGoogle();

      ShowToastDialog.closeLoader();

      if (value != null) {
        String fcmToken = await NotificationService.getToken();

        if (value.additionalUserInfo!.isNewUser) {
          DriverUserModel driverModel = DriverUserModel(
            driverId: value.user!.uid,
            email: value.user!.email,
            loginType: Constant.googleLoginType,
            phoneNumber: value.user!.phoneNumber,
            firstName: value.user!.displayName,
            profileImage: value.user!.photoURL,
            fcmToken: fcmToken,
            status: 'free',
          );

          Get.to(() => SignupScreenView(), arguments: {"driverModel": driverModel});
        } else {
          bool userExist = await FireStoreUtils.userExistOrNot(value.user!.uid);

          if (userExist) {
            DriverUserModel? driverModel = await FireStoreUtils.getDriverProfile(value.user!.uid);

            if (driverModel != null) {
              driverModel.fcmToken = fcmToken;
              await FireStoreUtils.updateDriverUser(driverModel);
              if (driverModel.active == true) {
                Constant.isLogin = await FireStoreUtils.isLogin();
              } else {
                Get.offAll(() => AccountDisabledScreen());
              }
            } else {
              ShowToastDialog.showToast("This Account doesn't match with this app".tr);
            }
          } else {
            DriverUserModel driverModel = DriverUserModel(
              driverId: value.user!.uid,
              email: value.user!.email,
              loginType: Constant.googleLoginType,
              phoneNumber: value.user!.phoneNumber,
              firstName: value.user!.displayName,
              profileImage: value.user!.photoURL,
              fcmToken: fcmToken,
              status: 'free',
            );

            Get.to(() => SignupScreenView(), arguments: {"driverModel": driverModel});
          }
        }
      }
    } catch (e, stack) {
      developer.log("Error in loginWithGoogle", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Ensure identity token is present
      if (appleCredential.identityToken == null) {
        ShowToastDialog.showToast("Apple sign-in failed. Try again.".tr);
        return null;
      }

      // Create OAuth credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in with Firebase
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e, stack) {
      developer.log("Error in signInWithApple", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
      return null;
    }
  }

  String generateNonce([int length = 32]) {
    try {
      const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    } catch (e, stack) {
      developer.log("Error in generateNonce", error: e, stackTrace: stack);
      return '';
    }
  }

  String sha256ofString(String input) {
    try {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e, stack) {
      developer.log("Error in sha256ofString", error: e, stackTrace: stack);
      return '';
    }
  }

  Future<void> loginWithApple() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);
      final value = await signInWithApple();

      if (value != null) {
        String fcmToken = await NotificationService.getToken();
        if (value.additionalUserInfo!.isNewUser) {
          DriverUserModel driverModel = DriverUserModel();
          driverModel.driverId = value.user!.uid;
          driverModel.email = value.user!.email;
          driverModel.loginType = Constant.appleLoginType;
          driverModel.phoneNumber = value.user!.phoneNumber;
          driverModel.firstName = value.user!.displayName;
          driverModel.profileImage = value.user!.photoURL;
          driverModel.fcmToken = fcmToken;

          ShowToastDialog.closeLoader();
          Get.to(() => SignupScreenView(), arguments: {"driverModel": driverModel});
        } else {
          bool userExist = await FireStoreUtils.userExistOrNot(value.user!.uid);
          ShowToastDialog.closeLoader();

          if (userExist) {
            DriverUserModel? driverModel = await FireStoreUtils.getDriverProfile(value.user!.uid);
            if (driverModel != null) {
              driverModel.fcmToken = fcmToken;
              await FireStoreUtils.updateDriverUser(driverModel);
              if (driverModel.active == true) {
                Constant.isLogin = await FireStoreUtils.isLogin();
                ShowToastDialog.closeLoader();
              } else {
                Get.offAll(() => AccountDisabledScreen());
              }
            } else {
              ShowToastDialog.showToast("This Account doesn't match with this app".tr);
            }
          } else {
            DriverUserModel driverModel = DriverUserModel();
            driverModel.driverId = value.user!.uid;
            driverModel.email = value.user!.email;
            driverModel.loginType = Constant.appleLoginType;
            driverModel.phoneNumber = value.user!.phoneNumber;
            driverModel.firstName = value.user!.displayName;
            driverModel.profileImage = value.user!.photoURL;
            driverModel.fcmToken = fcmToken;

            ShowToastDialog.closeLoader();
            Get.to(() => SignupScreenView(), arguments: {"driverModel": driverModel});
          }
        }
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Apple Sign-in Failed".tr);
      }
    } catch (e, stack) {
      developer.log("Error in loginWithApple", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      developer.log("+++++++++++++++++> ${e.code}");
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'user-disabled':
          errorMessage = "This user account has been disabled.";
          break;
        case 'user-not-found':
          errorMessage = "No account found for this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Please try again.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many login attempts. Please try again later.";
          break;
        case 'invalid-credential':
          errorMessage = "Invalid credentials. Please try again.";
          break;
        default:
          errorMessage = "Login failed: ${e.message}";
      }

      developer.log("FirebaseAuthException in emailSignIn", error: e);
      ShowToastDialog.showToast(errorMessage.tr);
    } catch (e, stack) {
      developer.log("Error in signInWithEmailAndPassword", error: e, stackTrace: stack);
      if (kDebugMode) {}
    }
    return null;
  }

  Future<void> emailSignIn() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      String email = emailController.value.text.trim();
      String password = passwordController.value.text;
      final userCredential = await signInWithEmailAndPassword(email, password);

      if (userCredential != null) {
        String fcmToken = await NotificationService.getToken();
        DriverUserModel? driverModel = await FireStoreUtils.getDriverProfile(userCredential.user!.uid);

        if (driverModel != null) {
          driverModel.fcmToken = fcmToken;
          await FireStoreUtils.updateDriverUser(driverModel);
          if (driverModel.active == true) {
            ShowToastDialog.showToast("Login Successful!".tr);
            Constant.isLogin = await FireStoreUtils.isLogin();
            ShowToastDialog.closeLoader();
            Get.offAll(() => HomeScreenView());
          } else {
            ShowToastDialog.closeLoader();
            Get.offAll(() => AccountDisabledScreen());
          }
        } else {
          ShowToastDialog.closeLoader();
          ShowToastDialog.showToast("Email and Password is Invalid".tr);
        }
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Login Failed".tr);
      }
    } catch (e, stack) {
      developer.log("Error in emailSignIn", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }
}
