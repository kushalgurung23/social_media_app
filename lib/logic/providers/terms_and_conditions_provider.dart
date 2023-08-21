import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/repositories/register_repo.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/email_verification_screen.dart';
import 'package:http/http.dart' as http;

class TermsAndConditionsProvider extends ChangeNotifier {
  bool tAndCCheckboxValue = false;

  bool returnCheckBoxValue() {
    return tAndCCheckboxValue;
  }

  void setCheckBoxValue({required bool newValue}) {
    tAndCCheckboxValue = newValue;
    notifyListeners();
  }

  void undoCheckBox() {
    if (tAndCCheckboxValue) {
      tAndCCheckboxValue = false;
    }
    notifyListeners();
  }

  Future<void> sendEmail(
      {required BuildContext context,
      required String recipientEmailAddress}) async {
    if (tAndCCheckboxValue == false) {
      showSnackBar(
          context: context,
          content: 'Please agree terms and conditions.',
          backgroundColor: Colors.red,
          contentColor: Colors.white);
    } else {
      EasyLoading.show(status: "Please wait", dismissOnTap: false);
      final random = Random();
      var sixDigitCode = random.nextInt(900000) + 100000;
      Map bodyData = {
        "sendTo": recipientEmailAddress,
        "subject": "C Talent Email Verification",
        "body": "<p>Dear Madam/Sir,</p>"
            "<p>Please enter the following 6 digit code in C Talent application to verify your email address:</p>"
            "<h1>$sixDigitCode</h1><br>"
            "<p>Yours Sincerely,</p>"
            "<p>C Talent</p>"
      };

      http.Response response = await RegisterRepo.sendEmailConfirmation(
          bodyData: jsonEncode(bodyData));
      EasyLoading.dismiss();
      if (response.statusCode == 200 &&
          jsonDecode(response.body)["status"] == "Success" &&
          context.mounted) {
        notifyListeners();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(
                  recipientEmailAddress: recipientEmailAddress,
                  verificationSixCode: sixDigitCode.toString(),
                )));
      } else {
        notifyListeners();
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
