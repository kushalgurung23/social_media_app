import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/locale_provider.dart';
import 'package:spa_app/logic/providers/login_screen_provider.dart';
import 'package:spa_app/presentation/components/all/custom_checkbox.dart';
import 'package:spa_app/presentation/components/all/custom_text_form_field.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/registration_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void setLanguageCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String languageLocale =
        sharedPreferences.getString("language_locale") ?? 'zh_Hant';
    if (languageLocale == 'zh_Hant') {
      Provider.of<LocaleProvider>(context, listen: false).setLocale(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
    } else if (languageLocale == 'zh_Hans') {
      Provider.of<LocaleProvider>(context, listen: false).setLocale(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'));
    } else if (languageLocale == 'en') {
      Provider.of<LocaleProvider>(context, listen: false)
          .setLocale(const Locale("en"));
    }
  }

  @override
  void initState() {
    Provider.of<LoginScreenProvider>(context, listen: false).initial();
    super.initState();
    setLanguageCode();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Consumer<LoginScreenProvider>(builder: (context, data, child) {
      return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: SizeConfig.defaultSize * 1),
                      Center(
                        child: Text(
                          AppLocalizations.of(context).welcome,
                          style: TextStyle(
                              fontFamily: kHelveticaMedium,
                              fontSize: SizeConfig.defaultSize * 1.9),
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize * 3),
                      Image.asset("assets/images/logo_transparent.png",
                          height: SizeConfig.defaultSize * 17,
                          width: SizeConfig.defaultSize * 17),
                      SizedBox(height: SizeConfig.defaultSize * 3.5),
                      Form(
                        key: data.formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize * 1),
                              child: CustomTextFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                textInputType: TextInputType.text,
                                textEditingController: data.userNameController,
                                maxLines: 1,
                                onSaved: (value) {},
                                isEnabled: true,
                                labelText:
                                    AppLocalizations.of(context).username +
                                        " / " +
                                        "ID",
                                obscureText: false,
                                validator: (value) {
                                  return data.validateUserName(
                                      context: context, value: value);
                                },
                                isReadOnly: false,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize * 1),
                              child: CustomTextFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                textInputType: TextInputType.text,
                                textEditingController: data.passwordController,
                                maxLines: 1,
                                isReadOnly: false,
                                onSaved: (value) {},
                                isEnabled: true,
                                labelText:
                                    AppLocalizations.of(context).password,
                                obscureText: data.passwordVisibility,
                                iconButton: IconButton(
                                  splashRadius: 0.1,
                                  padding: EdgeInsets.only(
                                      right: SizeConfig.defaultSize),
                                  icon: data.passwordVisibility
                                      ? Icon(CupertinoIcons.eye_slash,
                                          color: Colors.grey,
                                          size: SizeConfig.defaultSize * 2)
                                      : Icon(CupertinoIcons.eye,
                                          color: Colors.grey,
                                          size: SizeConfig.defaultSize * 2),
                                  onPressed: () {
                                    data.togglePasswordVisibility();
                                  },
                                ),
                                validator: (value) {
                                  return data.validatePassword(
                                      context: context, value: value);
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize),
                              child: CustomCheckbox(
                                title: GestureDetector(
                                  onTap: () {
                                    data.setCheckBoxValue(
                                        checkBoxValue: !data.mainScreenProvider
                                            .rememberMeCheckBox);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).rememberMe,
                                    style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5,
                                    ),
                                  ),
                                ),
                                checkboxValue:
                                    data.mainScreenProvider.rememberMeCheckBox,
                                onChanged: (value) {
                                  data.setCheckBoxValue(checkBoxValue: value!);
                                },
                                inCenter: false,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            data.isLoginClick
                                ? const CircularProgressIndicator(
                                    color: Color(0xFFA08875))
                                : RectangularButton(
                                    textPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.defaultSize * 1.5),
                                    height: SizeConfig.defaultSize * 5,
                                    width: SizeConfig.defaultSize * 22,
                                    onPress: () async {
                                      final isValid =
                                          data.formKey.currentState!.validate();
                                      if (isValid) {
                                        await data.userLogin(
                                            context: context,
                                            identifier:
                                                data.userNameController.text,
                                            password:
                                                data.passwordController.text);
                                      }
                                    },
                                    text: AppLocalizations.of(context).login,
                                    textColor: Colors.white,
                                    buttonColor: const Color(0xFFA08875),
                                    borderColor: const Color(0xFFFFFFFF),
                                    fontFamily: kHelveticaMedium,
                                    keepBoxShadow: true,
                                    offset: const Offset(0, 3),
                                    borderRadius: 6,
                                    blurRadius: 6,
                                    fontSize: SizeConfig.defaultSize * 1.5,
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.defaultSize * 6.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).notHaveAccount,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.defaultSize / 2),
                            child: InkWell(
                              child: Text(
                                AppLocalizations.of(context).register,
                                style: TextStyle(
                                    color: const Color(0xFFA08875),
                                    fontFamily: kHelveticaMedium,
                                    decoration: TextDecoration.underline,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                              onTap: () {
                                if (data.isLoginClick == true) {
                                  data.makeLoginFalse();
                                }
                                data.clearAll();
                                data.hidePassword();
                                Navigator.pushNamed(
                                    context, RegistrationScreen.id);
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.defaultSize * 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }
}
