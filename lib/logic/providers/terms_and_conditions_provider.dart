import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/repositories/register_repo.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/email_verification_screen.dart';
import 'package:http/http.dart' as http;

class TermsAndConditionsProvider extends ChangeNotifier {
  bool parentCheckBoxValue = false;
  bool tutorCheckBoxValue = false;
  bool studentCheckBoxValue = false;
  bool centerCheckBoxValue = false;

  bool returnCheckBoxValue(
      {required bool isParent,
      required bool isTutor,
      required bool isStudent,
      required bool isCenter}) {
    if (isParent) {
      return parentCheckBoxValue;
    } else if (isTutor) {
      return tutorCheckBoxValue;
    } else if (isStudent) {
      return studentCheckBoxValue;
    } else if (isCenter) {
      return centerCheckBoxValue;
    } else {
      return false;
    }
  }

  void setCheckBoxValue(
      {required bool isParent,
      required bool isTutor,
      required bool isStudent,
      required bool isCenter,
      required bool newValue}) {
    if (isParent) {
      parentCheckBoxValue = newValue;
    } else if (isTutor) {
      tutorCheckBoxValue = newValue;
    } else if (isStudent) {
      studentCheckBoxValue = newValue;
    } else if (isCenter) {
      centerCheckBoxValue = newValue;
    } else {
      return;
    }
    notifyListeners();
  }

  void undoCheckBox(
      {required bool isParent,
      required bool isTutor,
      required bool isStudent,
      required bool isCenter}) {
    if (isParent) {
      if (parentCheckBoxValue) {
        parentCheckBoxValue = false;
      }
    } else if (isTutor) {
      if (tutorCheckBoxValue) {
        tutorCheckBoxValue = false;
      }
    } else if (isStudent) {
      if (studentCheckBoxValue) {
        studentCheckBoxValue = false;
      }
    } else if (isCenter) {
      if (centerCheckBoxValue) {
        centerCheckBoxValue = false;
      }
    } else {
      return;
    }
    notifyListeners();
  }

  bool isRegisterClick = false;

  void turnOffLoading() {
    if (isRegisterClick == true) {
      isRegisterClick = false;

      notifyListeners();
    }
  }

  void turnOnLoading() {
    if (isRegisterClick == false) {
      isRegisterClick = true;
      notifyListeners();
    }
  }

  Future<void> sendEmail(
      {required BuildContext context,
      required String recipientEmailAddress,
      bool? isParent,
      bool? isStudent,
      bool? isTutor,
      bool? isCenter}) async {
    if (parentCheckBoxValue == false &&
        studentCheckBoxValue == false &&
        tutorCheckBoxValue == false &&
        centerCheckBoxValue == false) {
      showSnackBar(
          context: context,
          content: 'Please agree terms and conditions.',
          backgroundColor: Colors.red,
          contentColor: Colors.white);
    } else {
      turnOnLoading();
      final random = Random();
      var sixDigitCode = random.nextInt(900000) + 100000;
      Map bodyData = {
        "memberId": "-",
        "sendTo": recipientEmailAddress,
        "subject": "P Daily Email Verification",
        "body": "<p>Dear Madam/Sir,</p>"
            "<p>Please enter the following 6 digit code in P Daily application to verify your email address:</p>"
            "<h1>$sixDigitCode</h1><br>"
            "<p>Yours Sincerely,</p>"
            "<p>Apex Solutions Limited</p>"
      };

      http.Response response = await RegisterRepo.sendEmailConfirmation(
          bodyData: jsonEncode(bodyData));
      turnOffLoading();
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["d"]["result"] == "Success") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(
                  recipientEmailAddress: recipientEmailAddress,
                  verificationSixCode: sixDigitCode.toString(),
                  isParent: isParent,
                  isStudent: isStudent,
                  isTutor: isTutor,
                  isCenter: isCenter,
                )));
      } else {
        showSnackBar(
            context: context,
            content: 'Sorry, the email was not sent. Please try again later.',
            backgroundColor: Colors.red,
            contentColor: Colors.white);
      }
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
}
