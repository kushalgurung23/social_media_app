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

class ForgotPasswordVerifyCodeScreen extends StatefulWidget {
  final String recipientEmailAddress;
  const ForgotPasswordVerifyCodeScreen(
      {Key? key, required this.recipientEmailAddress})
      : super(key: key);

  @override
  State<ForgotPasswordVerifyCodeScreen> createState() =>
      _ForgotPasswordVerifyCodeScreenState();
}

class _ForgotPasswordVerifyCodeScreenState
    extends State<ForgotPasswordVerifyCodeScreen> {
  GlobalKey<FormState> forgotPasswordNewKey = GlobalKey<FormState>();
  TextEditingController sixDigitTextController = TextEditingController();

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
                Navigator.of(context).pop();
              },
            ),
            title: "Forgot Password",
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: Form(
                key: forgotPasswordNewKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
                      child: CustomTextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        textInputType: TextInputType.text,
                        textEditingController: sixDigitTextController,
                        maxLines: 1,
                        onSaved: (value) {},
                        labelText: AppLocalizations.of(context).sixDigitCode,
                        obscureText: false,
                        validator: (value) {
                          return data.validateSixDigitCode(
                              context: context, value: value);
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
                              forgotPasswordNewKey.currentState!.validate();
                          if (isValid) {
                            data.verifyFPResetCode(
                                context: context,
                                emailAddress: widget.recipientEmailAddress,
                                sixDigitTextController: sixDigitTextController);
                          }
                        },
                        // translate
                        text: 'VERIFY',
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
    sixDigitTextController.dispose();
    super.dispose();
  }
}
