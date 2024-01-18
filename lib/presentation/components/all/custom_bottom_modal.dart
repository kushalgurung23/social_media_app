import 'package:c_talent/presentation/components/all/custom_dropdown_button.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

Future<dynamic> showCustomModalBottom(
    {required BuildContext context,
    required List<String> listItems,
    required String? value,
    required void Function(BuildContext) onReset,
    required void Function(BuildContext) onPress,
    required void Function(BuildContext, String?) onChanged}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
        bottom: Radius.circular(0),
      )),
      builder: (BuildContext modalContext) => Container(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text(
                    AppLocalizations.of(modalContext).filter,
                    style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 2,
                        fontFamily: kHelveticaMedium,
                        color: Colors.black),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(modalContext);
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
                        child: Text(
                            '${AppLocalizations.of(modalContext).category}:',
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
                            hintText: AppLocalizations.of(modalContext)
                                .selectACategory,
                            value: value,
                            listItems: listItems,
                            onChanged: (value) =>
                                onChanged(modalContext, value),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.defaultSize * 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: RectangularButton(
                          textPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 1.5),
                          height: SizeConfig.defaultSize * 4.2,
                          onPress: () => onReset(modalContext),
                          text: AppLocalizations.of(modalContext).reset,
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
                          onPress: () => onPress(modalContext),
                          text: AppLocalizations.of(modalContext)
                              .filter
                              .toUpperCase(),
                          textColor: Colors.white,
                          buttonColor: const Color(0xFFA08875),
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
          ));
}
