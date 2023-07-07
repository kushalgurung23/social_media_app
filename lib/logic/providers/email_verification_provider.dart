import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/center_register_provider.dart';
import 'package:spa_app/logic/providers/parent_register_provider.dart';
import 'package:spa_app/logic/providers/student_register_provider.dart';
import 'package:spa_app/logic/providers/tutor_register_provider.dart';
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

  Future<void> parentRegister({required BuildContext context}) async {
    turnOnLoading();
    await Provider.of<ParentRegisterProvider>(context, listen: false)
        .registerParent(context: context);
    turnOffLoading();
  }

  Future<void> studentRegister({required BuildContext context}) async {
    turnOnLoading();
    await Provider.of<StudentRegisterProvider>(context, listen: false)
        .registerStudent(context: context);
    turnOffLoading();
  }

  Future<void> tutorRegister({required BuildContext context}) async {
    turnOnLoading();
    await Provider.of<TutorRegisterProvider>(context, listen: false)
        .registerTutor(context: context);
    turnOffLoading();
  }

  Future<void> centerRegister({required BuildContext context}) async {
    turnOnLoading();
    await Provider.of<CenterRegisterProvider>(context, listen: false)
        .registerCenter(context: context);
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
