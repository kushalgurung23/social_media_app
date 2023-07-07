import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/profile/password_change_screen.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPrivacy extends StatelessWidget {
  const EditPrivacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, data, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.defaultSize * 10,
                    child: Text('${AppLocalizations.of(context).email} :',
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.6,
                            fontFamily: kHelveticaRegular,
                            color: Colors.black)),
                  ),
                  Expanded(
                    child: RoundedTextFormField(
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          return data.validateEmail(
                              value: value, context: context);
                        },
                        textEditingController: data.emailTextController,
                        isEnable: false,
                        isReadOnly: true,
                        usePrefix: false,
                        useSuffix: false,
                        hintText:
                            '${AppLocalizations.of(context).example}: kushal@gmail.com',
                        suffixOnPress: () {},
                        borderRadius: 10),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.defaultSize * 10,
                    child: Text('${AppLocalizations.of(context).password} :',
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.6,
                            fontFamily: kHelveticaRegular,
                            color: Colors.black)),
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      RoundedTextFormField(
                          textInputType: TextInputType.text,
                          isEnable: false,
                          isReadOnly: true,
                          usePrefix: false,
                          useSuffix: false,
                          hintText: '',
                          suffixOnPress: () {},
                          borderRadius: 10),
                      Positioned(
                        left: 0,
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PasswordChangeScreen.id);
                            },
                            child: Text(
                                AppLocalizations.of(context).changePassword,
                                style: TextStyle(
                                    fontSize: SizeConfig.defaultSize * 1.6,
                                    fontFamily: kHelveticaRegular,
                                    color: const Color(0xFF5545CF),
                                    decoration: TextDecoration.underline)),
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
