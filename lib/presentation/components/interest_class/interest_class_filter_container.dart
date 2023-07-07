import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/interest_class_provider.dart';
import 'package:spa_app/presentation/components/all/custom_dropdown_button.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<dynamic> showInterestClassFilerContainer(
    {required BuildContext context}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
      bottom: Radius.circular(0),
    )),
    builder: (context) => Consumer<InterestClassProvider>(
      builder: (context, data, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  AppLocalizations.of(context).filter,
                  style: TextStyle(
                      fontSize: SizeConfig.defaultSize * 2,
                      fontFamily: kHelveticaMedium,
                      color: Colors.black),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    splashRadius: SizeConfig.defaultSize * 2.5,
                    icon: Icon(
                      Icons.close,
                      color: const Color(0xFF8897A7),
                      size: SizeConfig.defaultSize * 3,
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.defaultSize * 2,
                  bottom: SizeConfig.defaultSize * 1.5),
              child: SizedBox(
                height: SizeConfig.defaultSize * 4.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: SizeConfig.defaultSize * 10,
                      child: Text('${AppLocalizations.of(context).category}:',
                          style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 1.7,
                              fontFamily: kHelveticaRegular,
                              color: Colors.black)),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFD0E0F0), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: CustomDropdownButton(
                          iconSize: SizeConfig.defaultSize * 4.5,
                          hintText:
                              AppLocalizations.of(context).selectACategory,
                          value: data
                                  .getCategoryTypeList(context: context)
                                  .map((key, value) => MapEntry(value, key))[
                              data.filterCategoryType],
                          listItems: data
                              .getCategoryTypeList(context: context)
                              .keys
                              .toList(),
                          onChanged: (newKey) {
                            data.setFilterCategoryType(
                                newValue: data
                                    .getCategoryTypeList(
                                        context: context)[newKey]
                                    .toString());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
              child: SizedBox(
                height: SizeConfig.defaultSize * 4.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: SizeConfig.defaultSize * 10,
                      child: Text('${AppLocalizations.of(context).target}:',
                          style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 1.7,
                              fontFamily: kHelveticaRegular,
                              color: Colors.black)),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFFD0E0F0), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: CustomDropdownButton(
                          iconSize: SizeConfig.defaultSize * 4.5,
                          hintText: AppLocalizations.of(context).selectATarget,
                          value: data.getTargetAgeList(context: context).map(
                              (key, value) =>
                                  MapEntry(value, key))[data.filterTargetAge],
                          listItems: data
                              .getTargetAgeList(context: context)
                              .keys
                              .toList(),
                          onChanged: (newKey) {
                            data.setFilterTargetAge(
                                newValue: data
                                    .getTargetAgeList(context: context)[newKey]
                                    .toString());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 4),
                child: Row(
                  children: [
                    Expanded(
                      child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        height: SizeConfig.defaultSize * 4.2,
                        onPress: () {
                          data.resetFilter(context: context);
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
                    SizedBox(width: SizeConfig.defaultSize * 2),
                    Expanded(
                      child: RectangularButton(
                        textPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 1.5),
                        height: SizeConfig.defaultSize * 4.2,
                        onPress: () async {
                          await data.filterAllInterestClass(context: context);
                        },
                        text: AppLocalizations.of(context).filter.toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: const Color(0xFF5545CF),
                        borderColor: const Color(0xFFFFFFFF),
                        fontFamily: kHelveticaMedium,
                        keepBoxShadow: true,
                        offset: const Offset(0, 3),
                        borderRadius: 4,
                        blurRadius: 6,
                        fontSize: SizeConfig.defaultSize * 1.5,
                      ),
                    ),
                  ],
                )),
          ]),
        );
      },
    ),
  );
}
