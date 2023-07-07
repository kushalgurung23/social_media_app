import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/repositories/register_repo.dart';
import 'package:spa_app/logic/providers/login_screen_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/register_terms_and_conditions_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentRegisterProvider extends ChangeNotifier {
  GlobalKey<FormState> studentRegisterFormKey = GlobalKey<FormState>();

  late TextEditingController gradeTextController,
      userNameTextController,
      emailTextController,
      passwordTextController,
      confirmPasswordTextController;

  StudentRegisterProvider() {
    gradeTextController = TextEditingController();
    userNameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
  }

  List<String> regionList = [
    "Islands	離島區	New Territories (NT)",
    "Kwai Tsing	葵青區",
    "North	北區",
    "Sai Kung	西貢區",
    "Sha Tin	沙田區",
    "Tai Po	大埔區",
    "Tsuen Wan	荃灣區",
    "Tuen Mun	屯門區",
    "Yuen Long	元朗區 New Territories",
    "Kowloon City	九龍城區",
    "Kwun Tong	觀塘區",
    "Sham Shui Po	深水埗區",
    "Wong Tai Sin	黃大仙區",
    "Yau Tsim Mong	油尖旺區 Kowloon",
    "Central and Western	中西區	Hong Kong Island (HK)",
    "Eastern	東區",
    "Southern	南區",
    "Wan Chai	灣仔區"
  ];

  String? regionValue;

  void setRegion({required BuildContext context, required String newValue}) {
    regionValue = newValue;
    toggleRegionValidation(context: context, value: newValue);
    notifyListeners();
  }

  String? regionErrorMessage;
  String? toggleRegionValidation(
      {required BuildContext context, required String value}) {
    try {
      //if (value == 'null') {
      //  regionErrorMessage = AppLocalizations.of(context).selectRegion;
      //  return null;
      //} else {
      regionErrorMessage = null;
      return null;
      //}
    } finally {
      notifyListeners();
    }
  }

  String? validateGrade(
      {required BuildContext context, required String value}) {
    if (value.isEmpty) {
      return AppLocalizations.of(context).enterGrade;
    } else {
      return null;
    }
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

  bool passwordVisibility = true;
  void togglePasswordVisibility() {
    if (passwordVisibility == false) {
      passwordVisibility = true;
    } else if (passwordVisibility == true) {
      passwordVisibility = false;
    }
    notifyListeners();
  }

  bool secondPasswordVisibility = true;
  void toggleSecondPasswordVisibility() {
    if (secondPasswordVisibility == false) {
      secondPasswordVisibility = true;
    } else if (secondPasswordVisibility == true) {
      secondPasswordVisibility = false;
    }
    notifyListeners();
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
      if (resultList.isEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterTermsAndConditionsScreen(
                      isTutor: false,
                      isCenter: false,
                      isParent: false,
                      isStudent: true,
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
    } else {
      showSnackBar(
          context: context,
          content: AppLocalizations.of(context).unsuccessfulTryAgainLater,
          contentColor: Colors.white,
          backgroundColor: Colors.red);
    }
  }

  Future<void> registerStudent({required BuildContext context}) async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      String body = jsonEncode({
        "grade": gradeTextController.text,
        "username": userNameTextController.text.trim(),
        "email": emailTextController.text,
        "password": confirmPasswordTextController.text,
        "user_type": "Student",
        "region": regionValue,
        "device_token": deviceToken,
      });
      Response registrationResponse =
          await RegisterRepo.registerUser(bodyData: body);
      if (registrationResponse.statusCode == 200) {
        // toggling check box to false to remove previously saved login credentials in login screen
        Provider.of<MainScreenProvider>(context, listen: false)
            .rememberMeCheckBox = false;
        await Provider.of<LoginScreenProvider>(context, listen: false)
            .userLogin(
                context: context,
                identifier: userNameTextController.text,
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
    gradeTextController.clear();
    userNameTextController.clear();
    emailTextController.clear();
    passwordTextController.clear();
    confirmPasswordTextController.clear();
    regionValue = null;
  }

  @override
  void dispose() {
    gradeTextController.dispose();
    userNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }
}
