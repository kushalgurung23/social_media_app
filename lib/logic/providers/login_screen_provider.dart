import 'dart:convert';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/login_success.dart';
import 'package:c_talent/data/repositories/auth/login_repo.dart';
import 'package:c_talent/data/service/user_secure_storage.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/auth/email_verification_screen.dart';
import 'package:c_talent/presentation/views/auth/forgot_password_email_screen.dart';
import 'package:c_talent/presentation/views/auth/registration_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class LoginScreenProvider extends ChangeNotifier {
  late TextEditingController userNameController, passwordController;
  late final MainScreenProvider mainScreenProvider;

  LoginScreenProvider({required this.mainScreenProvider}) {
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }
  bool hidePasswordVisibility = true;

  void togglePasswordVisibility() {
    if (hidePasswordVisibility == false) {
      hidePasswordVisibility = true;
    } else if (hidePasswordVisibility == true) {
      hidePasswordVisibility = false;
    }
    notifyListeners();
  }

  String? validateUserName(
      {required BuildContext context, required String value}) {
    if (RegExp(r"\s").hasMatch(value)) {
      // translate
      return 'White space is not allowed.';
    } else if (value.trim().isEmpty) {
      // translate
      return 'Enter username / Email';
    } else {
      return null;
    }
  }

  String? validatePassword(
      {required BuildContext context, required String value}) {
    if (RegExp(r"\s").hasMatch(value)) {
      return AppLocalizations.of(context).whiteSpacesNotAllowedPassword;
    } else if (value.trim().isEmpty) {
      return AppLocalizations.of(context).enterPassword;
    } else if (value.trim().length < 6) {
      return AppLocalizations.of(context).enter6Characters;
    } else if (value.trim().length >= 51) {
      return AppLocalizations.of(context).passowrdCannotMore50Characters;
    } else {
      return null;
    }
  }

  // when user clicks on login or register, make password field obscure
  void hidePassword() {
    hidePasswordVisibility = true;
    notifyListeners();
  }

  bool isKeepUserLoggedIn = false;
  void toggleKeepUserLoggedIn({required bool newValue}) {
    isKeepUserLoggedIn = newValue;
    notifyListeners();
  }

  Future<void> userLogin(
      {required BuildContext context,
      required String identifier,
      required String password}) async {
    try {
      EasyLoading.show(
          status: AppLocalizations.of(context).loggingIn, dismissOnTap: false);
      String? currentDeviceToken = await FirebaseMessaging.instance.getToken();
      String body = jsonEncode({
        "identifier": identifier,
        "password": password,
        "device_token": currentDeviceToken
      });
      Response loginResponse = await NewLoginRepo.loginUser(bodyData: body);

      if (loginResponse.statusCode == 200 &&
          jsonDecode(loginResponse.body)['status'] == 'Success') {
        LoginSuccess loginSuccess = loginSuccessFromJson(loginResponse.body);
        if (loginSuccess.user == null) {
          EasyLoading.showInfo("Please try again later.",
              duration: const Duration(seconds: 3), dismissOnTap: true);
          return;
        }

        if (context.mounted) {
          await saveUserCredentials(
              loginSuccess: loginSuccess, context: context);
        }
        EasyLoading.dismiss();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.id, (route) => false);
        }
      } else if (loginResponse.statusCode == 401 &&
          jsonDecode(loginResponse.body)['msg'] ==
              'User is not verified yet. Please verify your email.') {
        // translate
        EasyLoading.showInfo(
            'User is not verified yet. Please verify your email.',
            duration: const Duration(seconds: 4),
            dismissOnTap: true);
        if (context.mounted) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmailVerificationScreen(
                    emailAddress:
                        jsonDecode(loginResponse.body)['email'].toString(),
                    password: password,
                  )));
        }
      } else if (jsonDecode(loginResponse.body)['status'] == 'Error') {
        EasyLoading.showInfo(jsonDecode(loginResponse.body)['msg'],
            duration: const Duration(seconds: 3), dismissOnTap: true);
        return;
      } else {
        EasyLoading.showInfo("Please try again later.",
            duration: const Duration(seconds: 3), dismissOnTap: true);
        return;
      }
    } on Exception {
      EasyLoading.showInfo("Please try again later.",
          duration: const Duration(seconds: 3), dismissOnTap: true);
      return;
    }
  }

  Future<void> saveUserCredentials(
      {required LoginSuccess loginSuccess,
      required BuildContext context}) async {
    mainScreenProvider.saveUserLoginDetails(
        loginSuccess: loginSuccess, isKeepUserLoggedIn: isKeepUserLoggedIn);
    clearLoginInput();
    hidePassword();
    // THIS WILL ALLOW USER TO REFRESH ACCESS TOKEN WHEN THEY RE-LOGIN
    Provider.of<AuthProvider>(context, listen: false)
        .setCanRefreshToken(canRefreshingToken: true);
    if (isKeepUserLoggedIn && loginSuccess.user != null) {
      await UserSecureStorage.secureAndSaveUserDetails(
          userId: loginSuccess.user!.id.toString(),
          refreshToken: loginSuccess.refreshToken.toString(),
          accessToken: loginSuccess.accessToken.toString(),
          isKeepUserLoggedIn: isKeepUserLoggedIn);
    } else {
      await UserSecureStorage.removeSecuredUserDetails();
      toggleKeepUserLoggedIn(newValue: false);
    }

    notifyListeners();
  }

  void clearLoginInput() {
    userNameController.clear();
    passwordController.clear();
  }

  void goToRegisterScreen({required BuildContext context}) {
    hidePassword();
    clearLoginInput();
    Navigator.pushNamed(context, RegistrationScreen.id);
  }

  void goToForgotPasswordScreen({required BuildContext context}) {
    hidePassword();
    clearLoginInput();
    Navigator.pushNamed(context, ForgotPasswordEmailScreen.id);
  }

  void showSnackBar(
      {required BuildContext context,
      required String content,
      required Color backgroundColor,
      required Color contentColor}) {
    final snackBar = SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: backgroundColor,
        onVisible: () {},
        behavior: SnackBarBehavior.fixed,
        content: Text(
          content,
          style: TextStyle(
            color: contentColor,
            fontFamily: kHelveticaMedium,
            fontSize: SizeConfig.defaultSize * 1.6,
          ),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    notifyListeners();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
