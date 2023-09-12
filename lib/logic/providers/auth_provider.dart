import 'dart:convert';
import 'package:c_talent/data/repositories/auth/forgot_password_repo.dart';
import 'package:c_talent/presentation/views/auth/forgot_password_new_screen.dart';
import 'package:c_talent/presentation/views/auth/forgot_password_verify_code_screen.dart';
import 'package:c_talent/presentation/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

class AuthProvider extends ChangeNotifier {
  // FP = ForgotPassword
  void goBackFromFPEmailScreen(
      {required BuildContext context,
      required TextEditingController emailTextController}) {
    emailTextController.clear();
    makeFPNewScreenFieldsObscure();
    Navigator.of(context).pop();
  }

  String? validateEmail(
      {required BuildContext context, required String value}) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value)) {
      return AppLocalizations.of(context).enterValidEmail;
    } else {
      return null;
    }
  }

  // FP = ForgotPassword
  Future<void> sendFPResetCode(
      {required BuildContext context,
      required TextEditingController emailTextController}) async {
    try {
      // translate
      EasyLoading.show(
          status: AppLocalizations.of(context).pleaseWait, dismissOnTap: false);
      String body = jsonEncode({"email": emailTextController.text});
      Response resendCodeResponse =
          await ForgotPasswordRepo.sendForgotPasswordCode(bodyData: body);
      if (resendCodeResponse.statusCode == 200 &&
          jsonDecode(resendCodeResponse.body)['status'] == 'Success') {
        // translate
        EasyLoading.showSuccess(
            "Please check your email for reset password code.",
            dismissOnTap: true,
            duration: const Duration(seconds: 4));
        if (context.mounted) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ForgotPasswordVerifyCodeScreen(
                  recipientEmailAddress: emailTextController.text)));
        }
      } else if (jsonDecode(resendCodeResponse.body)['status'] == 'Error') {
        EasyLoading.showInfo(jsonDecode(resendCodeResponse.body)['msg'],
            duration: const Duration(seconds: 4), dismissOnTap: true);
        return;
      } else {
        EasyLoading.showInfo("Please try again later.",
            duration: const Duration(seconds: 3), dismissOnTap: true);
        return;
      }
    } on Exception {
      // translate
      EasyLoading.showInfo("Please try again later.",
          duration: const Duration(seconds: 3), dismissOnTap: true);
      return;
    }
  }

  Future<void> verifyFPResetCode(
      {required BuildContext context,
      required String emailAddress,
      required TextEditingController sixDigitTextController}) async {
    try {
      // translate
      EasyLoading.show(status: 'Verifying..', dismissOnTap: false);
      String body = jsonEncode(
          {"email": emailAddress, "token": sixDigitTextController.text});
      Response verifyCodeResponse =
          await ForgotPasswordRepo.verifyForgotPasswordCode(bodyData: body);
      if (verifyCodeResponse.statusCode == 200 &&
          jsonDecode(verifyCodeResponse.body)['status'] == 'Success') {
        // translate
        EasyLoading.showSuccess("Please provide your new password.",
            dismissOnTap: true, duration: const Duration(seconds: 3));
        if (context.mounted) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ForgotPasswordNewScreen(emailAddress: emailAddress)));
        }
      } else if (jsonDecode(verifyCodeResponse.body)['status'] == 'Error') {
        EasyLoading.showInfo(jsonDecode(verifyCodeResponse.body)['msg'],
            duration: const Duration(seconds: 4), dismissOnTap: true);
        return;
      } else {
        EasyLoading.showInfo("Please try again later.",
            duration: const Duration(seconds: 3), dismissOnTap: true);
        return;
      }
    } on Exception {
      // translate
      EasyLoading.showInfo("Please try again later.",
          duration: const Duration(seconds: 3), dismissOnTap: true);
      return;
    }
  }

  bool isHideNewPassword = true;
  bool isHideConfirmNewPassword = true;

  void toggleNewPasswordVisibility() {
    if (isHideNewPassword == false) {
      isHideNewPassword = true;
    } else if (isHideNewPassword == true) {
      isHideNewPassword = false;
    }
    notifyListeners();
  }

  void toggleConfirmNewPasswordVisibility() {
    if (isHideConfirmNewPassword == false) {
      isHideConfirmNewPassword = true;
    } else if (isHideConfirmNewPassword == true) {
      isHideConfirmNewPassword = false;
    }
    notifyListeners();
  }

  String? validateSixDigitCode(
      {required String value, required BuildContext context}) {
    if (RegExp(r"\s").hasMatch(value)) {
      // translate
      return 'White space is not allowed.';
    } else if (value.trim().isEmpty) {
      return 'Please enter the code';
    } else {
      return null;
    }
  }

  String? validateNewPassword(
      {required String value,
      required BuildContext context,
      required TextEditingController confirmPasswordTextController,
      required TextEditingController newPasswordTextController}) {
    if (RegExp(r"\s").hasMatch(value)) {
      return AppLocalizations.of(context).whiteSpacesNotAllowedPassword;
    } else if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterNewPassword;
    } else if (value.trim().length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (value.trim().length >= 51) {
      return AppLocalizations.of(context).passowrdCannotMore50Characters;
    } else if (confirmPasswordTextController.text.trim().isNotEmpty &&
        newPasswordTextController.text.trim() !=
            confirmPasswordTextController.text.trim()) {
      return AppLocalizations.of(context).passwordDonotMatchWithEachOther;
    } else {
      return null;
    }
  }

  String? validateConfirmNewPassword(
      {required String value,
      required BuildContext context,
      required TextEditingController confirmPasswordTextController,
      required TextEditingController newPasswordTextController}) {
    if (RegExp(r"\s").hasMatch(value)) {
      return AppLocalizations.of(context).whiteSpacesNotAllowedPassword;
    } else if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterPassword;
    } else if (value.trim().length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (value.trim().length >= 51) {
      return AppLocalizations.of(context).passowrdCannotMore50Characters;
    } else if (newPasswordTextController.text.trim() !=
        confirmPasswordTextController.text.trim()) {
      return AppLocalizations.of(context).passwordDonotMatchWithEachOther;
    } else {
      return null;
    }
  }

  Future<void> resetNewPassword(
      {required BuildContext context,
      required String emailAddress,
      required TextEditingController confirmPasswordTextController}) async {
    try {
      // translate
      EasyLoading.show(status: 'Verifying..', dismissOnTap: false);
      String body = jsonEncode({
        "email": emailAddress,
        "password": confirmPasswordTextController.text
      });
      Response verifyCodeResponse =
          await ForgotPasswordRepo.resetNewPassword(bodyData: body);
      if (verifyCodeResponse.statusCode == 200 &&
          jsonDecode(verifyCodeResponse.body)['status'] == 'Success') {
        // translate
        EasyLoading.showSuccess("New password is reset successfully.",
            dismissOnTap: true, duration: const Duration(seconds: 3));
        makeFPNewScreenFieldsObscure();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.id, (route) => false);
        }
      } else if (jsonDecode(verifyCodeResponse.body)['status'] == 'Error') {
        EasyLoading.showInfo(jsonDecode(verifyCodeResponse.body)['msg'],
            duration: const Duration(seconds: 4), dismissOnTap: true);
        return;
      } else {
        EasyLoading.showInfo("Please try again later.",
            duration: const Duration(seconds: 3), dismissOnTap: true);
        return;
      }
    } on Exception {
      // translate
      EasyLoading.showInfo("Please try again later.",
          duration: const Duration(seconds: 3), dismissOnTap: true);
      return;
    }
  }

  void makeFPNewScreenFieldsObscure() {
    isHideNewPassword = true;
    isHideConfirmNewPassword = true;
    notifyListeners();
  }

  void goBackFromFPNewScreen(
      {required TextEditingController newPasswordTextController,
      required TextEditingController confirmPasswordTextController,
      required BuildContext context}) {
    makeFPNewScreenFieldsObscure();
    newPasswordTextController.clear();
    confirmPasswordTextController.clear();
    Navigator.of(context).pop();
  }
}
