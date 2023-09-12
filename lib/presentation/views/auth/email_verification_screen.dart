import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/registration_provider.dart';
import 'package:c_talent/presentation/components/all/custom_text_form_field.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String? emailAddress;
  final String? password;

  const EmailVerificationScreen(
      {Key? key, required this.emailAddress, required this.password})
      : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  GlobalKey<FormState> emailVerificationFormKey = GlobalKey<FormState>();
  TextEditingController sixDigitCodeTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: topAppBar(
            leadingWidget: IconButton(
              splashRadius: SizeConfig.defaultSize * 2.5,
              icon: Icon(CupertinoIcons.back,
                  color: const Color(0xFF8897A7),
                  size: SizeConfig.defaultSize * 2.7),
              onPressed: () {
                data.goBackFromEmailVerificationScreen(
                    context: context,
                    sixDigitCodeTextController: sixDigitCodeTextController);
              },
            ),
            title: AppLocalizations.of(context).emailVerification,
          ),
          body: Form(
            key: emailVerificationFormKey,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.defaultSize,
                          right: SizeConfig.defaultSize,
                          top: SizeConfig.defaultSize,
                          bottom: SizeConfig.defaultSize * 2),
                      child: Text(
                          '${AppLocalizations.of(context).enter6DigitCodeEmail}: ${widget.emailAddress ?? ''}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.defaultSize * 1.5,
                              fontFamily: kHelveticaRegular)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.defaultSize,
                          horizontal: SizeConfig.defaultSize),
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputType: TextInputType.text,
                        textEditingController: sixDigitCodeTextController,
                        maxLines: 1,
                        onSaved: (value) {},
                        labelText: AppLocalizations.of(context).sixDigitCode,
                        obscureText: false,
                        validator: (value) {
                          return data.validateSixDigitCode(
                            value: value,
                          );
                        },
                        isEnabled: true,
                        isReadOnly: false,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.defaultSize * 3,
                            bottom: SizeConfig.defaultSize * 2),
                        child: RectangularButton(
                            textPadding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.defaultSize * 1.5),
                            offset: const Offset(0, 3),
                            borderRadius: 6,
                            blurRadius: 6,
                            fontSize: SizeConfig.defaultSize * 1.5,
                            keepBoxShadow: true,
                            height: SizeConfig.defaultSize * 4.2,
                            width: SizeConfig.defaultSize * 21.4,
                            onPress: () async {
                              final isValid = emailVerificationFormKey
                                  .currentState!
                                  .validate();
                              if (isValid) {
                                await data.verifyEmailAddress(
                                    context: context,
                                    sixDigitTextController:
                                        sixDigitCodeTextController,
                                    password: widget.password.toString(),
                                    emailAddress:
                                        widget.emailAddress.toString());
                              }
                            },
                            text: AppLocalizations.of(context).verifyButton,
                            textColor: Colors.white,
                            buttonColor: const Color(0xFFA08875),
                            borderColor: const Color(0xFFC5966F),
                            fontFamily: kHelveticaRegular),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.defaultSize * 3),
                        child: InkWell(
                          child: Text(
                            // translate
                            'Resend verification code',
                            style: TextStyle(
                                color: const Color(0xFFA08875),
                                fontFamily: kHelveticaMedium,
                                decoration: TextDecoration.underline,
                                fontSize: SizeConfig.defaultSize * 1.5),
                          ),
                          onTap: () {
                            data.resendVerificationToken(
                                context: context,
                                emailAddress: widget.emailAddress.toString());
                          },
                        ),
                      ),
                    )
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
    sixDigitCodeTextController.dispose();
    super.dispose();
  }
}
