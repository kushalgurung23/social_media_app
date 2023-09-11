import 'dart:convert';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/login_success.dart';
import 'package:c_talent/data/repositories/auth/login_repo.dart';
import 'package:c_talent/data/service/user_secure_storage.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

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
    if (value.isEmpty) {
      // translate
      return 'Enter username / Email';
    } else {
      return null;
    }
  }

  String? validatePassword(
      {required BuildContext context, required String value}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterPassword;
    } else if (value.length < 6) {
      return AppLocalizations.of(context).enter6Characters;
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
      required String email,
      required String password}) async {
    try {
      EasyLoading.show(status: AppLocalizations.of(context).loggingIn);
      String? currentDeviceToken = await FirebaseMessaging.instance.getToken();
      String body = jsonEncode({
        "identifier": email,
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
        await saveUserCredentials(
            profilePicture: loginSuccess.user?.profilePicture,
            userId: loginSuccess.user!.id.toString(),
            username: loginSuccess.user!.username.toString(),
            refreshToken: loginSuccess.refreshToken.toString(),
            accessToken: loginSuccess.accessToken.toString());
        EasyLoading.dismiss();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.id, (route) => false);
        }
      } else if (loginResponse.statusCode == 401 &&
          jsonDecode(loginResponse.body)['status'] == 'Error') {
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
      {required String userId,
      required String username,
      required String refreshToken,
      required String accessToken,
      required String? profilePicture}) async {
    mainScreenProvider.saveUserLoginDetails(
        currentProfilePicture: profilePicture,
        currentUserId: userId,
        username: username,
        currentAccessToken: accessToken,
        isKeepUserLoggedIn: isKeepUserLoggedIn);
    clearLoginInput();
    if (isKeepUserLoggedIn) {
      await UserSecureStorage.secureAndSaveUserDetails(
          profilePicture: profilePicture,
          userId: userId,
          currentUsername: username,
          refreshToken: refreshToken,
          accessToken: accessToken,
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
    // hidePassword();
    // clearLoginInput();
    // Navigator.pushNamed(context, RegistrationScreen.id);
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
