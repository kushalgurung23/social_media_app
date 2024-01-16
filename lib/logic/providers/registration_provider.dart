import 'dart:async';
import 'dart:convert';
import 'package:c_talent/data/repositories/auth/register_repo.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/login_screen_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/views/auth/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/models/all_services.dart';
import '../../data/repositories/services/services_repo.dart';

class RegistrationProvider extends ChangeNotifier {
  late MainScreenProvider mainScreenProvider;
  RegistrationProvider({required this.mainScreenProvider});

  List<String> getUserTypeList({required BuildContext context}) {
    return ['Parent', 'Student'];
  }

  String? userTypeValue;

  void setUserType({required BuildContext context, required String newValue}) {
    userTypeValue = newValue;
    toggleUserTypeValidation(context: context, value: newValue);
    notifyListeners();
  }

  String? userTypeErrorMessage;
  String? toggleUserTypeValidation(
      {required BuildContext context, required String value}) {
    try {
      if (value == 'null') {
        userTypeErrorMessage = AppLocalizations.of(context).selectUserType;
        return null;
      } else {
        userTypeErrorMessage = null;
        return null;
      }
    } finally {
      notifyListeners();
    }
  }

  bool passwordVisibility = true;
  bool secondPasswordVisibility = true;

  void togglePasswordVisibility() {
    if (passwordVisibility == false) {
      passwordVisibility = true;
    } else if (passwordVisibility == true) {
      passwordVisibility = false;
    }
    notifyListeners();
  }

  void toggleSecondPasswordVisibility() {
    if (secondPasswordVisibility == false) {
      secondPasswordVisibility = true;
    } else if (secondPasswordVisibility == true) {
      secondPasswordVisibility = false;
    }
    notifyListeners();
  }

  String? validateUserName(
      {required BuildContext context, required String value}) {
    if (RegExp(r"\s").hasMatch(value)) {
      return AppLocalizations.of(context).whiteSpacesNotAllowedUsername;
    } else if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterUsername;
    } else if (value.trim().length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (value.length >= 51) {
      return AppLocalizations.of(context).usernameCannotMore50Characters;
    } else {
      return null;
    }
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

  String? validatePassword(
      {required BuildContext context,
      required String value,
      required TextEditingController confirmPasswordTextController,
      required TextEditingController passwordTextController}) {
    if (RegExp(r"\s").hasMatch(value)) {
      return AppLocalizations.of(context).whiteSpacesNotAllowedPassword;
    } else if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterPassword;
    } else if (value.trim().length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (value.trim().length >= 51) {
      return AppLocalizations.of(context).passowrdCannotMore50Characters;
    } else if (confirmPasswordTextController.text.isNotEmpty &&
        passwordTextController.text.trim() !=
            confirmPasswordTextController.text.trim()) {
      return AppLocalizations.of(context).passwordsNotMatch;
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(
      {required BuildContext context,
      required String value,
      required TextEditingController confirmPasswordTextController,
      required TextEditingController passwordTextController}) {
    if (RegExp(r"\s").hasMatch(value)) {
      return AppLocalizations.of(context).whiteSpacesNotAllowedPassword;
    } else if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterPassword;
    } else if (value.trim().length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (value.trim().length >= 51) {
      return AppLocalizations.of(context).passowrdCannotMore50Characters;
    } else if (passwordTextController.text.trim() !=
        confirmPasswordTextController.text.trim()) {
      return AppLocalizations.of(context).passwordsNotMatch;
    } else {
      return null;
    }
  }

  Future<void> registerUser(
      {required BuildContext context,
      required TextEditingController usernameTextController,
      required TextEditingController emailTextController,
      required TextEditingController passwordTextController,
      required TextEditingController confirmPasswordTextController}) async {
    try {
      EasyLoading.show(
          status: AppLocalizations.of(context).pleaseWait, dismissOnTap: false);
      String body = jsonEncode({
        "username": usernameTextController.text,
        "email": emailTextController.text,
        "password": passwordTextController.text,
        "user_type": userTypeValue
      });

      Response registerResponse =
          await RegisterRepo.registerUser(bodyData: body);
      if (registerResponse.statusCode == 201 &&
          jsonDecode(registerResponse.body)['status'] == 'Success') {
        EasyLoading.dismiss();
        if (context.mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => EmailVerificationScreen(
                    emailAddress: emailTextController.text,
                    password: passwordTextController.text,
                  )));
        }
      } else if (jsonDecode(registerResponse.body)['status'] == 'Error') {
        EasyLoading.showInfo(jsonDecode(registerResponse.body)['msg'],
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

  void clearRegistrationData({
    required TextEditingController usernameTextController,
    required TextEditingController emailTextController,
    required TextEditingController passwordTextController,
    required TextEditingController confirmPasswordTextController,
  }) {
    usernameTextController.clear();
    emailTextController.clear();
    passwordTextController.clear();
    confirmPasswordTextController.clear();
    userTypeValue = null;
    notifyListeners();
  }

  // EMAIL VERIFICATION //
  String? validateSixDigitCode({required String value}) {
    // translate
    if (value.isEmpty) {
      return 'Please enter the code';
    } else if (value.length != 6) {
      return 'Incorrect code';
    } else {
      return null;
    }
  }

  void goBackFromEmailVerificationScreen(
      {required BuildContext context,
      required TextEditingController sixDigitCodeTextController}) {
    clearDataFromEmailVerificationScreen(
        context: context,
        sixDigitCodeTextController: sixDigitCodeTextController);
    Navigator.of(context).pop();
  }

  void clearDataFromEmailVerificationScreen(
      {required BuildContext context,
      required TextEditingController sixDigitCodeTextController}) {
    userTypeValue = null;
    toggleUserTypeValidation(context: context, value: 'prev');
    sixDigitCodeTextController.clear();
    notifyListeners();
  }

  Future<void> verifyEmailAddress(
      {required BuildContext context,
      required String emailAddress,
      required String password,
      required TextEditingController sixDigitTextController}) async {
    try {
      // translate
      EasyLoading.show(status: 'Verifying..', dismissOnTap: false);
      String userEmail = emailAddress;
      String userPassword = password;
      String body = jsonEncode({
        "verificationToken": sixDigitTextController.text,
        "email": userEmail
      });
      Response verificationResponse =
          await RegisterRepo.verifyEmail(bodyData: body);
      if (verificationResponse.statusCode == 200) {
        if (context.mounted) {
          clearDataFromEmailVerificationScreen(
              context: context,
              sixDigitCodeTextController: sixDigitTextController);
          final loginProvider =
              Provider.of<LoginScreenProvider>(context, listen: false);
          loginProvider.toggleKeepUserLoggedIn(newValue: false);
          loginProvider.userLogin(
              context: context, identifier: userEmail, password: userPassword);
        }
      } else if (jsonDecode(verificationResponse.body)['status'] == 'Error') {
        EasyLoading.showInfo(jsonDecode(verificationResponse.body)['msg'],
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

  Future<void> resendVerificationToken(
      {required BuildContext context, required String emailAddress}) async {
    try {
      // translate
      EasyLoading.show(status: 'Resending..', dismissOnTap: false);
      String body = jsonEncode({"email": emailAddress});
      Response resendCodeResponse =
          await RegisterRepo.resendVerificationCode(bodyData: body);
      if (resendCodeResponse.statusCode == 200) {
        EasyLoading.showSuccess("Verification code is resent successfully.",
            dismissOnTap: true, duration: const Duration(seconds: 3));
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
}
