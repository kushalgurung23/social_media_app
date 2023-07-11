import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/registration_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

class EmailVerificationProvider extends ChangeNotifier {
  late TextEditingController sixDigitCodeTextController;
  GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();
  EmailVerificationProvider() {
    sixDigitCodeTextController = TextEditingController();
  }

  String? validatSixDigitCode(
      {required String value, required String verificationCode}) {
    if (value.isEmpty) {
      return 'Please enter the code';
    } else if (value != verificationCode) {
      return 'Incorrect code';
    } else {
      return null;
    }
  }

  bool isVerifyButtonClick = false;

  void turnOffLoading() {
    if (isVerifyButtonClick == true) {
      isVerifyButtonClick = false;

      notifyListeners();
    }
  }

  void turnOnLoading() {
    if (isVerifyButtonClick == false) {
      isVerifyButtonClick = true;
      notifyListeners();
    }
  }

  Future<void> registerUser({required BuildContext context}) async {
    turnOnLoading();
    await Provider.of<RegistrationProvider>(context, listen: false)
        .registerUser(context: context);
    turnOffLoading();
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
    sixDigitCodeTextController.clear();
    sixDigitCodeTextController.dispose();
    super.dispose();
  }
}
