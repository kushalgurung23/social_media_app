import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/repositories/register_repo.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/login_screen_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/register_terms_and_conditions_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationProvider extends ChangeNotifier {
  GlobalKey<FormState> userRegistrationKey = GlobalKey<FormState>();

  late TextEditingController userNameTextController,
      emailTextController,
      passwordTextController,
      confirmPasswordTextController;

  // Constructor
  RegistrationProvider() {
    userNameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
  }

  Map<String, String> getUserTypeList({required BuildContext context}) {
    return <String, String>{
      AppLocalizations.of(context).member: "Member",
      AppLocalizations.of(context).therapist: "Therapist"
    };
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
      {required BuildContext context, required String value}) {
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
      {required BuildContext context, required String value}) {
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

  Future<void> goToTermsAndConditionScreen(
      {required BuildContext context,
      required String username,
      required String emailAddress}) async {
    Response response = await RegisterRepo.searchDuplicateIdentifier(
        username: username, emailAddress: emailAddress);
    if (response.statusCode == 200) {
      List resultList = jsonDecode(response.body);

      // if username and email address are unique
      if (resultList.isEmpty && context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterTermsAndConditionsScreen(
                      isTutor: false,
                      isCenter: false,
                      isParent: true,
                      isStudent: false,
                      emailAddress: emailTextController.text,
                    )));
      }
      // If username or email address is not unique
      else {
        for (int i = 0; i < resultList.length; i++) {
          if (resultList[i]['username'] == username) {
            showSnackBar(
                context: context,
                content: AppLocalizations.of(context).usernameTaken,
                contentColor: Colors.white,
                backgroundColor: Colors.red);
            return;
          } else if (resultList[i]['email'] == emailAddress) {
            showSnackBar(
                context: context,
                content: AppLocalizations.of(context).accountEmailRegistered,
                contentColor: Colors.white,
                backgroundColor: Colors.red);
            return;
          }
        }
      }
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      if (context.mounted) {
        EasyLoading.showInfo(AppLocalizations.of(context).pleaseLogin,
            dismissOnTap: false, duration: const Duration(seconds: 4));
        Provider.of<DrawerProvider>(context, listen: false)
            .removeCredentials(context: context);
        return;
      }
    } else {
      if (context.mounted) {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).unsuccessfulTryAgainLater,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
    }
  }

  Future<void> registerUser({required BuildContext context}) async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      String body = jsonEncode({
        "username": userNameTextController.text.trim(),
        "email": emailTextController.text,
        "password": confirmPasswordTextController.text,
        "user_type": userTypeValue,
        "device_token": deviceToken,
      });
      Response registrationResponse =
          await RegisterRepo.registerUser(bodyData: body);
      if (registrationResponse.statusCode == 200 && context.mounted) {
        // toggling check box to false to remove previously saved login credentials in login screen
        Provider.of<MainScreenProvider>(context, listen: false)
            .rememberMeCheckBox = false;
        await Provider.of<LoginScreenProvider>(context, listen: false)
            .userLogin(
                context: context,
                email: userNameTextController.text,
                password: confirmPasswordTextController.text);
        clearData();
      } else if (registrationResponse.statusCode == 400 &&
          (jsonDecode(registrationResponse.body))["error"]["message"] ==
              "Email is already taken") {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).emailRegistered,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      } else if (registrationResponse.statusCode == 400 &&
          (jsonDecode(registrationResponse.body))["error"]["message"] ==
              "An error occurred during account creation") {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).usernameTaken,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      } else if (registrationResponse.statusCode == 400) {
        showSnackBar(
            context: context,
            content: ((jsonDecode(registrationResponse.body))["error"]
                    ["message"])
                .toString(),
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      } else {
        showSnackBar(
            context: context,
            content: AppLocalizations.of(context).usernameEmailRegistered,
            contentColor: Colors.white,
            backgroundColor: Colors.red);
      }
      return;
    } on Exception {
      return;
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

  void clearData() {
    userNameTextController.clear();
    emailTextController.clear();
    passwordTextController.clear();
    confirmPasswordTextController.clear();
    userTypeValue = null;
  }

  @override
  void dispose() {
    userNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }
}
