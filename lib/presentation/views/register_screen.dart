import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/center_register_screen_one.dart';
import 'package:spa_app/presentation/views/login_screen.dart';
import 'package:spa_app/presentation/views/parent_register_screen.dart';
import 'package:spa_app/presentation/views/student_register_screen.dart';
import 'package:spa_app/presentation/views/tutor_register_screen_one.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = '/register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            appBar: topAppBar(
                leadingWidget: IconButton(
                  splashRadius: SizeConfig.defaultSize * 2.5,
                  icon: Icon(CupertinoIcons.back,
                      color: const Color(0xFF8897A7),
                      size: SizeConfig.defaultSize * 2.7),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                ),
                title: AppLocalizations.of(context).register),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.defaultSize * 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.defaultSize),
                      child: Text(
                        AppLocalizations.of(context).registerType + ' :',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: kHelveticaMedium,
                            fontSize: SizeConfig.defaultSize * 1.6),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        borderRadius: 6,
                        fontSize: SizeConfig.defaultSize * 1.5,
                        keepBoxShadow: false,
                        onPress: () {
                          Navigator.pushNamed(
                              context, ParentRegistrationScreen.id);
                        },
                        text: AppLocalizations.of(context).parent,
                        textColor: Colors.black,
                        buttonColor: Colors.white,
                        borderColor: const Color(0xFF8897A7),
                        height: SizeConfig.defaultSize * 7.6,
                        width: double.infinity,
                        fontFamily: kHelveticaRegular,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        borderRadius: 6,
                        fontSize: SizeConfig.defaultSize * 1.5,
                        keepBoxShadow: false,
                        onPress: () {
                          Navigator.pushNamed(
                              context, StudentRegistrationScreen.id);
                        },
                        text: AppLocalizations.of(context).student,
                        textColor: Colors.black,
                        buttonColor: Colors.white,
                        borderColor: const Color(0xFF8897A7),
                        height: SizeConfig.defaultSize * 7.6,
                        width: double.infinity,
                        fontFamily: kHelveticaRegular,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        borderRadius: 6,
                        fontSize: SizeConfig.defaultSize * 1.5,
                        keepBoxShadow: false,
                        onPress: () {
                          Navigator.pushNamed(
                              context, TutorRegisterScreenOne.id);
                        },
                        text: AppLocalizations.of(context).tutor,
                        textColor: Colors.black,
                        buttonColor: Colors.white,
                        borderColor: const Color(0xFF8897A7),
                        height: SizeConfig.defaultSize * 7.6,
                        width: double.infinity,
                        fontFamily: kHelveticaRegular,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        borderRadius: 6,
                        fontSize: SizeConfig.defaultSize * 1.5,
                        keepBoxShadow: false,
                        onPress: () {
                          Navigator.pushNamed(
                              context, CenterRegisterScreenOne.id);
                        },
                        text: AppLocalizations.of(context).center,
                        textColor: Colors.black,
                        buttonColor: Colors.white,
                        borderColor: const Color(0xFF8897A7),
                        height: SizeConfig.defaultSize * 7.6,
                        width: double.infinity,
                        fontFamily: kHelveticaRegular,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize * 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
