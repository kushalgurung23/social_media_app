import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/registration_provider.dart';
import 'package:c_talent/presentation/components/all/custom_dropdown_form_field.dart';
import 'package:c_talent/presentation/components/all/custom_text_form_field.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/register_screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> userRegistrationKey = GlobalKey<FormState>();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationProvider>(
      builder: (context, data, child) {
        return WillPopScope(
            onWillPop: () async {
              data.clearRegistrationData(
                  usernameTextController: userNameTextController,
                  emailTextController: emailTextController,
                  passwordTextController: passwordTextController,
                  confirmPasswordTextController: confirmPasswordTextController);
              data.toggleUserTypeValidation(context: context, value: 'prev');
              return true;
            },
            child: Container(
                color: Colors.white,
                child: SafeArea(
                    child: Scaffold(
                  appBar: topAppBar(
                      leadingWidget: null,
                      title: AppLocalizations.of(context).register),
                  body: Column(
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: Form(
                            key: userRegistrationKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .createAccount,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kHelveticaMedium,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.6),
                                    ),
                                  ),
                                  // USER TYPE
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomDropdownFormField(
                                          validator: (value) {
                                            return data
                                                .toggleUserTypeValidation(
                                                    context: context,
                                                    value: value.toString());
                                          },
                                          iconSize: SizeConfig.defaultSize * 3,
                                          boxDecoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      data.userTypeErrorMessage !=
                                                              null
                                                          ? Colors.red
                                                          : const Color(
                                                              0xFF707070),
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          hintText: AppLocalizations.of(context)
                                              .userType,
                                          value: data.userTypeValue,
                                          onChanged: (value) {
                                            data.setUserType(
                                                context: context,
                                                newValue: value.toString());
                                          },
                                          listItems: data.getUserTypeList(
                                              context: context),
                                        ),
                                        data.userTypeErrorMessage == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    top: SizeConfig.defaultSize,
                                                    left:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                                child: Text(
                                                  data.userTypeErrorMessage!,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.6,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2),
                                    child: CustomTextFormField(
                                      textInputType: TextInputType.text,
                                      textEditingController:
                                          userNameTextController,
                                      maxLines: 1,
                                      onSaved: (value) {},
                                      labelText:
                                          AppLocalizations.of(context).username,
                                      obscureText: false,
                                      validator: (value) {
                                        return data.validateUserName(
                                            context: context, value: value);
                                      },
                                      isEnabled: true,
                                      isReadOnly: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2),
                                    child: CustomTextFormField(
                                      textInputType: TextInputType.emailAddress,
                                      textEditingController:
                                          emailTextController,
                                      maxLines: 1,
                                      onSaved: (value) {},
                                      labelText:
                                          AppLocalizations.of(context).email,
                                      obscureText: false,
                                      validator: (value) {
                                        return data.validateEmail(
                                            context: context, value: value);
                                      },
                                      isEnabled: true,
                                      isReadOnly: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2),
                                    child: CustomTextFormField(
                                      textInputType: TextInputType.text,
                                      textEditingController:
                                          passwordTextController,
                                      maxLines: 1,
                                      onSaved: (value) {},
                                      labelText:
                                          AppLocalizations.of(context).password,
                                      obscureText: data.passwordVisibility,
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            right: SizeConfig.defaultSize * .5),
                                        child: IconButton(
                                          splashRadius:
                                              SizeConfig.defaultSize * 1.5,
                                          icon: data.passwordVisibility
                                              ? Icon(CupertinoIcons.eye_slash,
                                                  color: Colors.grey,
                                                  size: SizeConfig.defaultSize *
                                                      2)
                                              : Icon(CupertinoIcons.eye,
                                                  color: Colors.grey,
                                                  size: SizeConfig.defaultSize *
                                                      2),
                                          onPressed: () {
                                            data.togglePasswordVisibility();
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        return data.validatePassword(
                                            passwordTextController:
                                                passwordTextController,
                                            confirmPasswordTextController:
                                                confirmPasswordTextController,
                                            context: context,
                                            value: value);
                                      },
                                      isEnabled: true,
                                      isReadOnly: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2),
                                    child: CustomTextFormField(
                                      textInputType: TextInputType.text,
                                      textEditingController:
                                          confirmPasswordTextController,
                                      maxLines: 1,
                                      onSaved: (value) {},
                                      labelText: AppLocalizations.of(context)
                                          .enterPasswordAgain,
                                      obscureText:
                                          data.secondPasswordVisibility,
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            right: SizeConfig.defaultSize * .5),
                                        child: IconButton(
                                          splashRadius:
                                              SizeConfig.defaultSize * 1.5,
                                          icon: data.secondPasswordVisibility
                                              ? Icon(CupertinoIcons.eye_slash,
                                                  color: Colors.grey,
                                                  size: SizeConfig.defaultSize *
                                                      2)
                                              : Icon(CupertinoIcons.eye,
                                                  color: Colors.grey,
                                                  size: SizeConfig.defaultSize *
                                                      2),
                                          onPressed: () {
                                            data.toggleSecondPasswordVisibility();
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        return data.validateConfirmPassword(
                                            passwordTextController:
                                                passwordTextController,
                                            confirmPasswordTextController:
                                                confirmPasswordTextController,
                                            context: context,
                                            value: value);
                                      },
                                      isEnabled: true,
                                      isReadOnly: false,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 3,
                                        bottom: SizeConfig.defaultSize * 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: RectangularButton(
                                                textPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                                offset: const Offset(0, 3),
                                                borderRadius: 6,
                                                blurRadius: 6,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.5,
                                                keepBoxShadow: true,
                                                height: SizeConfig.defaultSize *
                                                    4.4,
                                                onPress: () {
                                                  data.clearRegistrationData(
                                                      usernameTextController:
                                                          userNameTextController,
                                                      emailTextController:
                                                          emailTextController,
                                                      passwordTextController:
                                                          passwordTextController,
                                                      confirmPasswordTextController:
                                                          confirmPasswordTextController);
                                                  data.toggleUserTypeValidation(
                                                      context: context,
                                                      value: 'prev');
                                                  Navigator.pop(context);
                                                },
                                                text:
                                                    AppLocalizations.of(context)
                                                        .prevButton,
                                                textColor: Colors.white,
                                                buttonColor:
                                                    const Color(0xFFA0A0A0),
                                                borderColor:
                                                    const Color(0xFFC5966F),
                                                fontFamily: kHelveticaRegular)),
                                        SizedBox(
                                            width:
                                                SizeConfig.defaultSize * 1.5),
                                        Expanded(
                                            child: RectangularButton(
                                                textPadding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                                offset: const Offset(0, 3),
                                                borderRadius: 6,
                                                blurRadius: 6,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.5,
                                                keepBoxShadow: true,
                                                height: SizeConfig.defaultSize *
                                                    4.4,
                                                onPress: () async {
                                                  final isValid =
                                                      userRegistrationKey
                                                          .currentState!
                                                          .validate();
                                                  if (isValid &&
                                                      data.userTypeErrorMessage ==
                                                          null) {
                                                    data.registerUser(
                                                        context: context,
                                                        usernameTextController:
                                                            userNameTextController,
                                                        emailTextController:
                                                            emailTextController,
                                                        passwordTextController:
                                                            passwordTextController,
                                                        confirmPasswordTextController:
                                                            confirmPasswordTextController);
                                                  }
                                                },
                                                text:
                                                    AppLocalizations.of(context)
                                                        .nextButton,
                                                textColor: Colors.white,
                                                buttonColor:
                                                    const Color(0xFFA08875),
                                                borderColor:
                                                    const Color(0xFFC5966F),
                                                fontFamily: kHelveticaRegular)),
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                        )),
                      ),
                    ],
                  ),
                ))));
      },
    );
  }

  @override
  void dispose() {
    userNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }
}
