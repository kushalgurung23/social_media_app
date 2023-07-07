import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/all/adjustable_text_form_field.dart';
import 'package:spa_app/presentation/components/all/custom_dropdown_form_field.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/selected_multiple_images.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaperShareNewPost extends StatelessWidget {
  static const String id = '/paper_share_new_post';

  const PaperShareNewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaperShareProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: topAppBar(
              leadingWidget: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: Icon(CupertinoIcons.back,
                    color: const Color(0xFF8897A7),
                    size: SizeConfig.defaultSize * 2.7),
                onPressed: () {
                  data.goBack(context: context);
                },
              ),
              title: AppLocalizations.of(context).paperShare,
              widgetList: []),
          body: SingleChildScrollView(
              child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
            child: Form(
              key: data.paperShareKey,
              child: Column(
                children: [
                  // Subject
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.defaultSize,
                        bottom: SizeConfig.defaultSize * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                              child: Text(
                                  '${AppLocalizations.of(context).subject}:',
                                  style: TextStyle(
                                      fontSize: SizeConfig.defaultSize * 1.7,
                                      fontFamily: kHelveticaRegular,
                                      color: Colors.black)),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: SizeConfig.defaultSize * 4.5,
                                child: CustomDropdownFormField(
                                  textSize: SizeConfig.defaultSize * 2,
                                  boxDecoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              data.subjectErrorMessage != null
                                                  ? Colors.red
                                                  : const Color(0xFFD0E0F0),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  validator: (value) {
                                    return data.toggleSubjectValidation(
                                        value: value.toString(),
                                        context: context);
                                  },
                                  iconSize: SizeConfig.defaultSize * 4.5,
                                  hintText:
                                      '-${AppLocalizations.of(context).pleaseSelect}-',
                                  value: data
                                      .getSubjectList(context: context)
                                      .map((key, value) => MapEntry(
                                          value, key))[data.newSubject],
                                  listItems: data
                                      .getSubjectList(context: context)
                                      .keys
                                      .toList(),
                                  onChanged: (newKey) {
                                    data.setNewSubject(
                                        newValue: data
                                            .getSubjectList(
                                                context: context)[newKey]
                                            .toString(),
                                        context: context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        data.subjectErrorMessage == null
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.defaultSize,
                                    left: SizeConfig.defaultSize * 11.5),
                                child: Text(
                                  data.subjectErrorMessage!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: SizeConfig.defaultSize * 1.6,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  // Level
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                              child: Text(
                                  '${AppLocalizations.of(context).level}:',
                                  style: TextStyle(
                                      fontSize: SizeConfig.defaultSize * 1.7,
                                      fontFamily: kHelveticaRegular,
                                      color: Colors.black)),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: SizeConfig.defaultSize * 4.5,
                                child: CustomDropdownFormField(
                                  textSize: SizeConfig.defaultSize * 2,
                                  boxDecoration: BoxDecoration(
                                      border: Border.all(
                                          color: data.levelErrorMessage != null
                                              ? Colors.red
                                              : const Color(0xFFD0E0F0),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  validator: (value) {
                                    return data.toggleLevelValidation(
                                        value: value.toString(),
                                        context: context);
                                  },
                                  iconSize: SizeConfig.defaultSize * 4.5,
                                  hintText:
                                      '-${AppLocalizations.of(context).pleaseSelect}-',
                                  value: data
                                      .getLevelList(context: context)
                                      .map((key, value) =>
                                          MapEntry(value, key))[data.newLevel],
                                  listItems: data
                                      .getLevelList(context: context)
                                      .keys
                                      .toList(),
                                  onChanged: (newKey) {
                                    data.setNewLevel(
                                        newValue: data
                                            .getLevelList(
                                                context: context)[newKey]
                                            .toString(),
                                        context: context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        data.levelErrorMessage == null
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.defaultSize,
                                    left: SizeConfig.defaultSize * 11.5),
                                child: Text(
                                  data.levelErrorMessage!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: SizeConfig.defaultSize * 1.6,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Semester
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                              child: Text(
                                  '${AppLocalizations.of(context).semester}:',
                                  style: TextStyle(
                                      fontSize: SizeConfig.defaultSize * 1.7,
                                      fontFamily: kHelveticaRegular,
                                      color: Colors.black)),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: SizeConfig.defaultSize * 4.5,
                                child: CustomDropdownFormField(
                                  textSize: SizeConfig.defaultSize * 2,
                                  boxDecoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              data.semesterErrorMessage != null
                                                  ? Colors.red
                                                  : const Color(0xFFD0E0F0),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  validator: (value) {
                                    return data.toggleSemesterValidation(
                                        value: value.toString(),
                                        context: context);
                                  },
                                  iconSize: SizeConfig.defaultSize * 4.5,
                                  hintText:
                                      '-${AppLocalizations.of(context).pleaseSelect}-',
                                  value: data
                                      .getSemesterList(context: context)
                                      .map((key, value) => MapEntry(
                                          value, key))[data.newSemester],
                                  listItems: data
                                      .getSemesterList(context: context)
                                      .keys
                                      .toList(),
                                  onChanged: (newKey) {
                                    data.setNewSemester(
                                        newValue: data
                                            .getSemesterList(
                                                context: context)[newKey]
                                            .toString(),
                                        context: context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        data.semesterErrorMessage == null
                            ? const SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.defaultSize,
                                    left: SizeConfig.defaultSize * 11.5),
                                child: Text(
                                  data.semesterErrorMessage!,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: SizeConfig.defaultSize * 1.6,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  // Image select button
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: SizeConfig.defaultSize * 10,
                          child: Text('${AppLocalizations.of(context).image}:',
                              style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.7,
                                  fontFamily: kHelveticaRegular,
                                  color: Colors.black)),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: SizeConfig.defaultSize * 4.5,
                            child: InkWell(
                              onTap: () {
                                data.selectMultiImages();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFD0E0F0),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                height: SizeConfig.defaultSize * 4.2,
                                width: SizeConfig.defaultSize * 4.2,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context).uploadHere,
                                    style: TextStyle(
                                        color: const Color(0xFF707070),
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Images display
                  data.imageFileList == null || data.imageFileList!.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.defaultSize * 2),
                          child: SelectedMultipleImages(
                              imageFileList: data.imageFileList,
                              type: 'paper_share'),
                        ),
                  // Content
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
                    child: AdjustableTextFormField(
                        autovalidateMode: AutovalidateMode.disabled,
                        hintTextFontSize: SizeConfig.defaultSize * 1.7,
                        minLines: 12,
                        maxLines: 12,
                        textInputType: TextInputType.text,
                        textEditingController: data.contentTextController,
                        isEnable: true,
                        isReadOnly: false,
                        usePrefix: false,
                        useSuffix: false,
                        hintText:
                            AppLocalizations.of(context).writeYourContentHere,
                        iconOnPress: () {},
                        borderRadius: 10),
                  ),
                  // Rule
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x00000000).withOpacity(0.16),
                              spreadRadius: 0,
                              blurRadius: 6,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              width: 3, color: const Color(0xFFFFFFFF)),
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 2),
                        child: Column(
                          children: [
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            Text(
                              AppLocalizations.of(context).rule,
                              style: TextStyle(
                                fontFamily: kHelveticaMedium,
                                fontSize: SizeConfig.defaultSize * 2.1,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig.defaultSize * 0.8),
                                      child: orderList(context, [
                                        AppLocalizations.of(context)
                                            .ruleContent1,
                                        AppLocalizations.of(context)
                                            .ruleContent2,
                                        AppLocalizations.of(context)
                                            .ruleContent3,
                                        AppLocalizations.of(context)
                                            .ruleContent4,
                                        AppLocalizations.of(context)
                                            .ruleContent5
                                      ])),
                                )
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //  Buttons
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.defaultSize * 2),
                      child: data.isPostClick
                          ? const CircularProgressIndicator(
                              color: Color(0xFF5545CF))
                          : Row(
                              children: [
                                Expanded(
                                  child: RectangularButton(
                                    textPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.defaultSize * 1.5),
                                    height: SizeConfig.defaultSize * 4.2,
                                    onPress: () {
                                      data.resetPaperShare(context: context);
                                    },
                                    text: AppLocalizations.of(context).reset,
                                    textColor: Colors.white,
                                    buttonColor: const Color(0xFFA0A0A0),
                                    borderColor: const Color(0xFFFFFFFF),
                                    fontFamily: kHelveticaMedium,
                                    keepBoxShadow: true,
                                    offset: const Offset(0, 3),
                                    borderRadius: 4,
                                    blurRadius: 6,
                                    fontSize: SizeConfig.defaultSize * 1.5,
                                  ),
                                ),
                                SizedBox(width: SizeConfig.defaultSize * 1.5),
                                Expanded(
                                  child: RectangularButton(
                                    textPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.defaultSize * 1.5),
                                    height: SizeConfig.defaultSize * 4.2,
                                    onPress: () async {
                                      data.removeReset();
                                      final isValid = data
                                          .paperShareKey.currentState!
                                          .validate();

                                      if (isValid &&
                                          data.subjectErrorMessage == null &&
                                          data.levelErrorMessage == null &&
                                          data.semesterErrorMessage == null) {
                                        if (data.imageFileList == null ||
                                            data.imageFileList!.isEmpty) {
                                          data.showPaperImageError(
                                              context: context);
                                        } else {
                                          await data.createNewPaperShare(
                                              buildContext: context,
                                              context: context);
                                        }
                                      }
                                    },
                                    text: AppLocalizations.of(context)
                                        .post
                                        .toUpperCase(),
                                    textColor: Colors.white,
                                    buttonColor: const Color(0xFF5545CF),
                                    borderColor: const Color(0xFFFFFFFF),
                                    fontFamily: kHelveticaMedium,
                                    keepBoxShadow: true,
                                    offset: const Offset(0, 3),
                                    borderRadius: 4,
                                    blurRadius: 6,
                                    fontSize: SizeConfig.defaultSize * 1.7,
                                  ),
                                ),
                              ],
                            )),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

  Widget orderList(BuildContext context, List<String> texts) {
    return Column(
        children: texts.map((text) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text((texts.indexOf(text) + 1).toString() + ". ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: kHelveticaRegular,
              fontSize: SizeConfig.defaultSize * 1.7,
            )),
        Expanded(
          child: Text(text,
              style: TextStyle(
                fontFamily: kHelveticaRegular,
                fontSize: SizeConfig.defaultSize * 1.7,
              )), //text
        )
      ]);
    }).toList());
  }
}
