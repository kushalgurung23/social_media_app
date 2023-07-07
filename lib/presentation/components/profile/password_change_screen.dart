import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/custom_text_form_field.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordChangeScreen extends StatelessWidget {
  static const String id = '/password_change_screen';
  const PasswordChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: topAppBar(
            leadingWidget: IconButton(
              splashRadius: SizeConfig.defaultSize * 2.5,
              icon: Icon(CupertinoIcons.back,
                  color: const Color(0xFF8897A7),
                  size: SizeConfig.defaultSize * 2.7),
              onPressed: () {
                data.goBackFromPasswordChange(context: context);
              },
            ),
            title: AppLocalizations.of(context).changePassword,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: Form(
                key: data.formKey,
                child: Column(
                  children: [
                    // Old password
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputType: TextInputType.text,
                        textEditingController: data.oldPasswordTextController,
                        maxLines: 1,
                        onSaved: (value) {},
                        labelText: AppLocalizations.of(context).oldPassword,
                        obscureText: data.oldPasswordVisibility,
                        iconButton: IconButton(
                          padding:
                              EdgeInsets.only(right: SizeConfig.defaultSize),
                          splashRadius: SizeConfig.defaultSize * 1.5,
                          icon: data.oldPasswordVisibility
                              ? Icon(CupertinoIcons.eye_slash,
                                  color: Colors.grey,
                                  size: SizeConfig.defaultSize * 1.5)
                              : Icon(CupertinoIcons.eye,
                                  color: Colors.grey,
                                  size: SizeConfig.defaultSize * 1.5),
                          onPressed: () {
                            data.toggleOldPasswordVisibility();
                          },
                        ),
                        validator: (value) {
                          return data.validateOldPassword(
                              value: value, context: context);
                        },
                        isEnabled: true,
                        isReadOnly: false,
                      ),
                    ),
                    // New password
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputType: TextInputType.text,
                        textEditingController: data.newPasswordTextController,
                        maxLines: 1,
                        onSaved: (value) {},
                        labelText: AppLocalizations.of(context).newPassword,
                        obscureText: data.newPasswordVisibility,
                        iconButton: IconButton(
                          padding:
                              EdgeInsets.only(right: SizeConfig.defaultSize),
                          splashRadius: SizeConfig.defaultSize * 1.5,
                          icon: data.newPasswordVisibility
                              ? Icon(CupertinoIcons.eye_slash,
                                  color: Colors.grey,
                                  size: SizeConfig.defaultSize * 1.5)
                              : Icon(CupertinoIcons.eye,
                                  color: Colors.grey,
                                  size: SizeConfig.defaultSize * 1.5),
                          onPressed: () {
                            data.toggleNewPasswordVisibility();
                          },
                        ),
                        validator: (value) {
                          return data.validateNewPassword(
                              value: value, context: context);
                        },
                        isEnabled: true,
                        isReadOnly: false,
                      ),
                    ),
                    // Confirm new password
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputType: TextInputType.text,
                        textEditingController:
                            data.confirmNewPasswordTextController,
                        maxLines: 1,
                        onSaved: (value) {},
                        labelText:
                            AppLocalizations.of(context).confirmNewPassword,
                        obscureText: data.confirmNewPasswordVisibility,
                        iconButton: IconButton(
                          padding:
                              EdgeInsets.only(right: SizeConfig.defaultSize),
                          splashRadius: SizeConfig.defaultSize * 1.5,
                          icon: data.confirmNewPasswordVisibility
                              ? Icon(CupertinoIcons.eye_slash,
                                  color: Colors.grey,
                                  size: SizeConfig.defaultSize * 1.5)
                              : Icon(CupertinoIcons.eye,
                                  color: Colors.grey,
                                  size: SizeConfig.defaultSize * 1.5),
                          onPressed: () {
                            data.toggleConfirmNewPasswordVisibility();
                          },
                        ),
                        validator: (value) {
                          return data.validateConfirmNewPassword(
                              value: value, context: context);
                        },
                        isEnabled: true,
                        isReadOnly: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 4),
                      child: data.isPasswordChangeButtonClick
                          ? Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.defaultSize * 2),
                              child: const CircularProgressIndicator(
                                  color: Color(0xFF5545CF)),
                            )
                          : RectangularButton(
                              textPadding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize * 1.5),
                              height: SizeConfig.defaultSize * 5,
                              width: SizeConfig.defaultSize * 22,
                              onPress: () async {
                                final isValid =
                                    data.formKey.currentState!.validate();
                                if (isValid) {
                                  if (data.validateForDifferentPassword(
                                          context: context) ==
                                      true) {
                                    data.updatePassword(context: context);
                                  }
                                }
                              },
                              text: AppLocalizations.of(context).changePassword,
                              textColor: Colors.white,
                              buttonColor: const Color(0xFF5545CF),
                              borderColor: const Color(0xFFFFFFFF),
                              fontFamily: kHelveticaMedium,
                              keepBoxShadow: true,
                              offset: const Offset(0, 3),
                              borderRadius: 6,
                              blurRadius: 6,
                              fontSize: SizeConfig.defaultSize * 1.5,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
