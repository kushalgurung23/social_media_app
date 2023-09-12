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

class ForgotPasswordEmailScreen extends StatefulWidget {
  static const String id = '/forgot_password_email_screen';
  const ForgotPasswordEmailScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen>
    with WidgetsBindingObserver {
  GlobalKey<FormState> forgotPasswordEmailScreenKey = GlobalKey<FormState>();
  TextEditingController emailTextController = TextEditingController();
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
                data.goBackFromFPEmailScreen(
                    context: context, emailTextController: emailTextController);
              },
            ),
            // translate
            title: 'Forgot Password',
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: Form(
                key: forgotPasswordEmailScreenKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.defaultSize * 2.5),
                      child: Text(
                        // translate
                        "Please provide your email address. We will send you a verification code:",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.6),
                      ),
                    ),
                    CustomTextFormField(
                      autovalidateMode: AutovalidateMode.disabled,
                      textInputType: TextInputType.emailAddress,
                      textEditingController: emailTextController,
                      maxLines: 1,
                      onSaved: (value) {},
                      isEnabled: true,
                      labelText: AppLocalizations.of(context).email,
                      obscureText: false,
                      validator: (value) {
                        return data.validateEmail(
                            context: context, value: value);
                      },
                      isReadOnly: false,
                    ),
                    Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.defaultSize * 4),
                        child: RectangularButton(
                          textPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 1.5),
                          height: SizeConfig.defaultSize * 5,
                          width: SizeConfig.defaultSize * 22,
                          onPress: () async {
                            final isValid = forgotPasswordEmailScreenKey
                                .currentState!
                                .validate();
                            if (isValid) {
                              data.sendFPResetCode(
                                  context: context,
                                  emailTextController: emailTextController);
                            }
                          },
                          // translate
                          text: 'SEND',
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
    emailTextController.dispose();
    super.dispose();
  }
}
