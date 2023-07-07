import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/tutor_register_provider.dart';
import 'package:spa_app/presentation/components/all/custom_dropdown_form_field.dart';
import 'package:spa_app/presentation/components/all/custom_text_form_field.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorRegisterScreenOne extends StatelessWidget {
  static const String id = '/tutor_register_screen_one';

  const TutorRegisterScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TutorRegisterProvider>(
      builder: (context, data, child) {
        return WillPopScope(
            onWillPop: () async {
              data.goBackFromScreenOne(context: context);
              return false;
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.defaultSize * 2),
                        child: SizedBox(
                          height: SizeConfig.defaultSize * 1.3,
                          width: SizeConfig.defaultSize * 9.5,
                          child: Image.asset("assets/images/tutor_reg_1.png"),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: Form(
                            key: data.tutorRegisterOneKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2,
                                        bottom: SizeConfig.defaultSize * 1.3),
                                    child: Text(
                                      AppLocalizations.of(context).registerType,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kHelveticaMedium,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.6),
                                    ),
                                  ),
                                  CustomTextFormField(
                                    textInputType: TextInputType.text,
                                    onSaved: (value) {},
                                    labelText:
                                        AppLocalizations.of(context).tutor,
                                    obscureText: false,
                                    validator: (value) {
                                      return null;
                                    },
                                    isEnabled: false,
                                    isReadOnly: true,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 6,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).basicInfo,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.6),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomDropdownFormField(
                                          iconSize: SizeConfig.defaultSize * 3,
                                          boxDecoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      data.teachingAreaErrorMessage !=
                                                              null
                                                          ? Colors.red
                                                          : const Color(
                                                              0xFF707070),
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          hintText: AppLocalizations.of(context)
                                              .teachingArea,
                                          validator: (value) {
                                            return data
                                                .toggleTeachingAreaValidation(
                                                    context: context,
                                                    value: value.toString());
                                          },
                                          value: data.teachingAreaValue,
                                          listItems: data.regionList,
                                          onChanged: (value) {
                                            data.setTeachingArea(
                                                context: context,
                                                newValue: value.toString());
                                          },
                                        ),
                                        data.teachingAreaErrorMessage == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    top: SizeConfig.defaultSize,
                                                    left:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                                child: Text(
                                                  data.teachingAreaErrorMessage!,
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomDropdownFormField(
                                          validator: (value) {
                                            return data
                                                .toggleCollegeTypeValidation(
                                                    context: context,
                                                    value: value.toString());
                                          },
                                          iconSize: SizeConfig.defaultSize * 3,
                                          boxDecoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      data.collegeTypeErrorMessage !=
                                                              null
                                                          ? Colors.red
                                                          : const Color(
                                                              0xFF707070),
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          hintText: AppLocalizations.of(context)
                                              .collegeType,
                                          value: data.collegeTypeValue,
                                          listItems: data.collegeTypeList,
                                          onChanged: (value) {
                                            data.setCollegeType(
                                                context: context,
                                                newValue: value.toString());
                                          },
                                        ),
                                        data.collegeTypeErrorMessage == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    top: SizeConfig.defaultSize,
                                                    left:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                                child: Text(
                                                  data.collegeTypeErrorMessage!,
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomDropdownFormField(
                                          // When we select multiple times, we use hint text as selected items. So when items are selected we change the text style of hint text.
                                          hintTextStyle: data
                                                      .selectedTeachingType ==
                                                  ''
                                              ? TextStyle(
                                                  color:
                                                      const Color(0xFF707070),
                                                  fontFamily: kHelveticaRegular,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.7)
                                              : TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          2.1,
                                                  fontFamily:
                                                      kHelveticaRegular),
                                          onTap: () {
                                            data.showMultiSelect(
                                                context: context);
                                          },
                                          validator: (value) {
                                            return data
                                                .toggleTeachingTypeValidation(
                                                    context: context);
                                          },
                                          iconSize: SizeConfig.defaultSize * 3,
                                          boxDecoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      data.teachingTypeErrorMessage !=
                                                              null
                                                          ? Colors.red
                                                          : const Color(
                                                              0xFF707070),
                                                  width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          // When we select multiple times, we use hint text as selected items. So, we change the hintText's value to the items that user has selected
                                          hintText:
                                              data.selectedTeachingType == ''
                                                  ? AppLocalizations.of(context)
                                                      .teachingType
                                                  : data.selectedTeachingType,
                                          value: null,
                                          listItems: data.teachingTypeList,
                                        ),
                                        data.teachingTypeErrorMessage == null
                                            ? const SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    top: SizeConfig.defaultSize,
                                                    left:
                                                        SizeConfig.defaultSize *
                                                            1.5),
                                                child: Text(
                                                  data.teachingTypeErrorMessage!,
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
                                                  data.goBackFromScreenOne(
                                                      context: context);
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
                                                onPress: () {
                                                  final isValid = data
                                                      .tutorRegisterOneKey
                                                      .currentState!
                                                      .validate();

                                                  if (isValid) {
                                                    data.goToSecondScreen(
                                                        context: context);
                                                  }
                                                },
                                                text:
                                                    AppLocalizations.of(context)
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
                ))));
      },
    );
  }

  Widget customDropDownAddress(BuildContext context,
      List<String> _addressFilteredName, String valueItem) {
    return DropdownMenuItem(
        value: valueItem,
        child: Text(
          valueItem,
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.defaultSize * 2.1,
              fontFamily: kHelveticaRegular),
        ));
  }
}
