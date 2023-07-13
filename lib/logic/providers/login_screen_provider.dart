import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/data/repositories/login_repo.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreenProvider extends ChangeNotifier {
  late SharedPreferences sharedPreferences;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController userNameController, passwordController;
  late final MainScreenProvider mainScreenProvider;

  LoginScreenProvider({required this.mainScreenProvider}) {
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    initial();
  }

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userNameController.text =
        sharedPreferences.getString('login_identifier') ?? '';
    passwordController.text =
        sharedPreferences.getString('login_password') ?? '';
  }

  bool passwordVisibility = true;

  void setCheckBoxValue({required bool checkBoxValue}) {
    sharedPreferences.setBool('rememberMe', checkBoxValue);
    mainScreenProvider.rememberMeCheckBox =
        sharedPreferences.getBool('rememberMe') ?? false;
    notifyListeners();
  }

  void clearAll() {
    if (mainScreenProvider.loginIdentifier == '' &&
        mainScreenProvider.loginPassword == '') {
      userNameController.text = '';
      passwordController.text = '';
      sharedPreferences.setBool('rememberMe', false);
      mainScreenProvider.rememberMeCheckBox =
          sharedPreferences.getBool('rememberMe') ?? false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    if (passwordVisibility == false) {
      passwordVisibility = true;
    } else if (passwordVisibility == true) {
      passwordVisibility = false;
    }
    notifyListeners();
  }

  String? validateUserName(
      {required BuildContext context, required String value}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterUsernameId;
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

  bool isLoginClick = false;

  void makeLoginFalse() {
    if (isLoginClick == true) {
      isLoginClick = false;
      notifyListeners();
    }
  }

  void makeLoginTrue() {
    if (isLoginClick == false) {
      isLoginClick = true;
      notifyListeners();
    }
  }

  // when user clicks on login or register, make password field obscure
  void hidePassword() {
    passwordVisibility = true;
    notifyListeners();
  }

  User? user;

  Future<void> userLogin(
      {required BuildContext context,
      required String identifier,
      required String password}) async {
    try {
      makeLoginTrue();
      EasyLoading.show(status: AppLocalizations.of(context).loggingIn);
      String body =
          jsonEncode({"identifier": identifier, "password": password});
      Response loginResponse = await LoginRepo.loginUser(bodyData: body);
      if (isLoginClick == true) {
        // If login credentials matches
        if (loginResponse.statusCode == 200 && context.mounted) {
          user = userFromJson(loginResponse.body);
          saveLoginCredentials(password: password);
          mainScreenProvider.currentUserController.sink.add(user!);
          mainScreenProvider.setUserInfo(user: user!, context: context);
          String? currentDeviceToken =
              await FirebaseMessaging.instance.getToken();
          // Checking if the device token stored in user table matches the current device token
          // if it doesnot match
          if (user!.deviceToken.toString() != currentDeviceToken) {
            bool isUpdate = await mainScreenProvider.updateUserDeviceToken(
                userId: user!.id.toString(),
                newDeviceToken: currentDeviceToken!);
            if (isUpdate && context.mounted) {
              EasyLoading.showSuccess(
                  "${AppLocalizations.of(context).welcome} ${user!.username}",
                  dismissOnTap: true,
                  duration: const Duration(seconds: 2));
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.id, (route) => false);
              makeLoginFalse();
              hidePassword();
            }
          } else if (user!.deviceToken.toString() == currentDeviceToken &&
              context.mounted) {
            EasyLoading.showSuccess(
                "${AppLocalizations.of(context).welcome} ${user!.username}",
                dismissOnTap: true,
                duration: const Duration(seconds: 2));
            Navigator.pushNamedAndRemoveUntil(
                context, HomeScreen.id, (route) => false);
            hidePassword();
          }
        }
        // If login credentials do not match
        else if (loginResponse.statusCode == 400 &&
            (jsonDecode(loginResponse.body))["error"]["message"] ==
                "Invalid identifier or password") {
          EasyLoading.dismiss();
          showSnackBar(
              context: context,
              content:
                  AppLocalizations.of(context).usernameEmailPasswordNotMatch,
              contentColor: Colors.white,
              backgroundColor: Colors.red);
        } else if (loginResponse.statusCode == 400) {
          EasyLoading.dismiss();
          showSnackBar(
              context: context,
              content: ((jsonDecode(loginResponse.body))["error"]["message"])
                  .toString(),
              contentColor: Colors.white,
              backgroundColor: Colors.red);
        } else {
          EasyLoading.dismiss();
          showSnackBar(
              context: context,
              content: AppLocalizations.of(context).unsuccessfulTryAgainLater,
              contentColor: Colors.white,
              backgroundColor: Colors.red);
        }
      }
      EasyLoading.dismiss();
      makeLoginFalse();
    } on Exception {
      EasyLoading.dismiss();
      makeLoginFalse();
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).unsuccessfulTryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
      throw (Exception);
    }
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

  void saveLoginCredentials({required String password}) {
    sharedPreferences.setString('jwt', LoginRepo.jwt!);
    sharedPreferences.setBool('isLogin', true);
    sharedPreferences.setString('device_token', user!.deviceToken.toString());
    mainScreenProvider.setJwToken(newJwt: LoginRepo.jwt!);
    mainScreenProvider.isLogin = sharedPreferences.getBool('isLogin') ?? true;
    sharedPreferences.setString('id', user!.id.toString());
    sharedPreferences.setString('user_name', user!.username!);
    sharedPreferences.setString('user_type', user!.userType!);
    sharedPreferences.setString('current_password', password);
    if (mainScreenProvider.rememberMeCheckBox == true) {
      sharedPreferences.setString('login_identifier', userNameController.text);
      sharedPreferences.setString('login_password', passwordController.text);
      mainScreenProvider.loginIdentifier =
          sharedPreferences.getString('login_identifier');
      mainScreenProvider.loginPassword =
          sharedPreferences.getString('login_password');
    } else {
      sharedPreferences.remove('rememberMe');
      sharedPreferences.remove('login_identifier');
      sharedPreferences.remove('login_password');
      mainScreenProvider.loginIdentifier = '';
      mainScreenProvider.loginPassword = '';
      userNameController.text = '';
      passwordController.text = '';
    }

    notifyListeners();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
