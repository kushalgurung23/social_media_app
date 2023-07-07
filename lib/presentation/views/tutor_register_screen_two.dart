import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/logic/providers/tutor_register_provider.dart';
import 'package:spa_app/presentation/components/all/custom_dropdown_form_field.dart';
import 'package:spa_app/presentation/components/all/custom_text_form_field.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorRegisterScreenTwo extends StatelessWidget {
  static const String id = '/tutor_register_screen_two';

  const TutorRegisterScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TutorRegisterProvider>(
      builder: (context, data, child) {
        return Container(
            color: Colors.white,
            child: SafeArea(
                child: Scaffold(
              appBar: topAppBar(
                  leadingWidget: null,
                  title: AppLocalizations.of(context).register),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.defaultSize * 2),
                    child: SizedBox(
                      height: SizeConfig.defaultSize * 1.3,
                      width: SizeConfig.defaultSize * 9.5,
                      child: Image.asset("assets/images/tutor_reg_2.png"),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Form(
                        key: data.tutorRegisterTwoKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.defaultSize * 2),
                                child: Text(
                                  AppLocalizations.of(context).createAccount,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: kHelveticaMedium,
                                      fontSize: SizeConfig.defaultSize * 1.6),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.defaultSize * 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdownFormField(
                                      validator: (value) {
                                        return data.toggleRegionValidation(
                                            context: context,
                                            value: value.toString());
                                      },
                                      iconSize: SizeConfig.defaultSize * 3,
                                      boxDecoration: BoxDecoration(
                                          border: Border.all(
                                              color: data.regionErrorMessage !=
                                                      null
                                                  ? Colors.red
                                                  : const Color(0xFF707070),
                                              width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      hintText:
                                          (AppLocalizations.of(context).region +
                                              ' (' +
                                              AppLocalizations.of(context)
                                                  .optional +
                                              ')'),
                                      value: data.regionValue,
                                      listItems: data.regionList,
                                      onChanged: (value) {
                                        data.setRegion(
                                            context: context,
                                            newValue: value.toString());
                                      },
                                    ),
                                    data.regionErrorMessage == null
                                        ? const SizedBox()
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                top: SizeConfig.defaultSize,
                                                left: SizeConfig.defaultSize *
                                                    1.5),
                                            child: Text(
                                              data.regionErrorMessage!,
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
                                      data.userNameTextController,
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
                                      data.emailTextController,
                                  maxLines: 1,
                                  onSaved: (value) {},
                                  labelText: AppLocalizations.of(context).email,
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
                                      data.passwordTextController,
                                  maxLines: 1,
                                  onSaved: (value) {},
                                  labelText:
                                      AppLocalizations.of(context).password,
                                  obscureText: data.passwordVisibility,
                                  iconButton: IconButton(
                                    padding: EdgeInsets.only(
                                        right: SizeConfig.defaultSize),
                                    splashRadius: SizeConfig.defaultSize * 1.5,
                                    icon: data.passwordVisibility
                                        ? Icon(CupertinoIcons.eye_slash,
                                            color: Colors.grey,
                                            size: SizeConfig.defaultSize * 1.5)
                                        : Icon(CupertinoIcons.eye,
                                            color: Colors.grey,
                                            size: SizeConfig.defaultSize * 1.5),
                                    onPressed: () {
                                      data.togglePasswordVisibility();
                                    },
                                  ),
                                  validator: (value) {
                                    return data.validatePassword(
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
                                      data.confirmPasswordTextController,
                                  maxLines: 1,
                                  onSaved: (value) {},
                                  labelText: AppLocalizations.of(context)
                                      .enterPasswordAgain,
                                  obscureText: data.secondPasswordVisibility,
                                  iconButton: IconButton(
                                    padding: EdgeInsets.only(
                                        right: SizeConfig.defaultSize),
                                    splashRadius: SizeConfig.defaultSize * 1.5,
                                    icon: data.secondPasswordVisibility
                                        ? Icon(CupertinoIcons.eye_slash,
                                            color: Colors.grey,
                                            size: SizeConfig.defaultSize * 1.5)
                                        : Icon(CupertinoIcons.eye,
                                            color: Colors.grey,
                                            size: SizeConfig.defaultSize * 1.5),
                                    onPressed: () {
                                      data.toggleSecondPasswordVisibility();
                                    },
                                  ),
                                  validator: (value) {
                                    return data.validateConfirmPassword(
                                        context: context, value: value);
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
                                                SizeConfig.defaultSize * 1.5,
                                            keepBoxShadow: true,
                                            height:
                                                SizeConfig.defaultSize * 4.4,
                                            onPress: () {
                                              data.toggleRegionValidation(
                                                  context: context,
                                                  value: 'prev');
                                              Navigator.pop(context);
                                            },
                                            text: AppLocalizations.of(context)
                                                .prevButton,
                                            textColor: Colors.white,
                                            buttonColor:
                                                const Color(0xFFA0A0A0),
                                            borderColor:
                                                const Color(0xFFC5966F),
                                            fontFamily: kHelveticaRegular)),
                                    SizedBox(
                                        width: SizeConfig.defaultSize * 1.5),
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
                                                SizeConfig.defaultSize * 1.5,
                                            keepBoxShadow: true,
                                            height:
                                                SizeConfig.defaultSize * 4.4,
                                            onPress: () async {
                                              final isValid = data
                                                  .tutorRegisterTwoKey
                                                  .currentState!
                                                  .validate();
                                              if (isValid &&
                                                  data.regionErrorMessage ==
                                                      null) {
                                                await data
                                                    .goToTermsAndConditionScreen(
                                                        context: context,
                                                        username: data
                                                            .userNameTextController
                                                            .text,
                                                        emailAddress: data
                                                            .emailTextController
                                                            .text);
                                              }
                                            },
                                            text: AppLocalizations.of(context)
                                                .nextButton,
                                            textColor: Colors.white,
                                            buttonColor:
                                                const Color(0xFF5545CF),
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
            )));
      },
    );
  }
}
