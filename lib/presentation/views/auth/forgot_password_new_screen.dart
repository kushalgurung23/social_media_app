import 'package:c_talent/data/constant/color_constant.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/presentation/components/all/custom_text_form_field.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ForgotPasswordNewScreen extends StatefulWidget {
  final String emailAddress;
  const ForgotPasswordNewScreen({Key? key, required this.emailAddress})
      : super(key: key);

  @override
  State<ForgotPasswordNewScreen> createState() =>
      _ForgotPasswordNewScreenState();
}

class _ForgotPasswordNewScreenState extends State<ForgotPasswordNewScreen> {
  GlobalKey<FormState> resetPasswordNewKey = GlobalKey<FormState>();

  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: topAppBar(
            leadingWidget: IconButton(
              splashRadius: SizeConfig.defaultSize * 2.5,
              icon: Icon(CupertinoIcons.back,
                  color: const Color(0xFF8897A7),
                  size: SizeConfig.defaultSize * 2.7),
              onPressed: () {
                data.goBackFromFPNewScreen(
                    newPasswordTextController: newPasswordTextController,
                    confirmPasswordTextController:
                        confirmPasswordTextController,
                    context: context);
              },
            ),
            title: "Forgot Password",
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: Form(
                key: resetPasswordNewKey,
                child: Column(
                  children: [
                    // New password
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputType: TextInputType.text,
                        textEditingController: newPasswordTextController,
                        maxLines: 1,
                        onSaved: (value) {},
                        labelText: AppLocalizations.of(context).newPassword,
                        obscureText: data.isHideNewPassword,
                        suffixIcon: Padding(
                          padding:
                              EdgeInsets.only(right: SizeConfig.defaultSize),
                          child: IconButton(
                            splashRadius: SizeConfig.defaultSize * 1.5,
                            icon: data.isHideNewPassword
                                ? Icon(CupertinoIcons.eye_slash,
                                    color: Colors.grey,
                                    size: SizeConfig.defaultSize * 2)
                                : Icon(CupertinoIcons.eye,
                                    color: Colors.grey,
                                    size: SizeConfig.defaultSize * 2),
                            onPressed: () {
                              data.toggleNewPasswordVisibility();
                            },
                          ),
                        ),
                        validator: (value) {
                          return data.validateNewPassword(
                              newPasswordTextController:
                                  newPasswordTextController,
                              confirmPasswordTextController:
                                  confirmPasswordTextController,
                              value: value,
                              context: context);
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
                        textEditingController: confirmPasswordTextController,
                        maxLines: 1,
                        onSaved: (value) {},
                        labelText:
                            AppLocalizations.of(context).confirmNewPassword,
                        obscureText: data.isHideConfirmNewPassword,
                        suffixIcon: Padding(
                          padding:
                              EdgeInsets.only(right: SizeConfig.defaultSize),
                          child: IconButton(
                            splashRadius: SizeConfig.defaultSize * 1.5,
                            icon: data.isHideConfirmNewPassword
                                ? Icon(CupertinoIcons.eye_slash,
                                    color: Colors.grey,
                                    size: SizeConfig.defaultSize * 2)
                                : Icon(CupertinoIcons.eye,
                                    color: Colors.grey,
                                    size: SizeConfig.defaultSize * 2),
                            onPressed: () {
                              data.toggleConfirmNewPasswordVisibility();
                            },
                          ),
                        ),
                        validator: (value) {
                          return data.validateConfirmNewPassword(
                              newPasswordTextController:
                                  newPasswordTextController,
                              confirmPasswordTextController:
                                  confirmPasswordTextController,
                              value: value,
                              context: context);
                        },
                        isEnabled: true,
                        isReadOnly: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 4),
                      child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        height: SizeConfig.defaultSize * 5,
                        width: SizeConfig.defaultSize * 22,
                        onPress: () async {
                          final isValid =
                              resetPasswordNewKey.currentState!.validate();
                          if (isValid) {
                            data.resetNewPasswordfromFPScreen(
                                context: context,
                                emailAddress: widget.emailAddress,
                                confirmPasswordTextController:
                                    confirmPasswordTextController);
                          }
                        },
                        text: AppLocalizations.of(context).changePassword,
                        textColor: Colors.white,
                        buttonColor: kPrimaryColor,
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

  @override
  void dispose() {
    newPasswordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }
}
