import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> listItems;
  final FormFieldSetter<String?>? onChanged;
  final BoxDecoration boxDecoration;
  final double iconSize;
  final FormFieldValidator validator;
  final double? textSize;
  final VoidCallback? onTap;
  final TextStyle? hintTextStyle;

  const CustomDropdownFormField(
      {Key? key,
      required this.validator,
      required this.iconSize,
      required this.boxDecoration,
      required this.hintText,
      required this.value,
      required this.listItems,
      this.onChanged,
      this.onTap,
      this.hintTextStyle,
      this.textSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: SizeConfig.defaultSize),
        height: SizeConfig.defaultSize * 7.5,
        decoration: boxDecoration,
        child: Center(
          child: DropdownButtonFormField(
              alignment: Alignment.center,
              isDense: false,
              itemHeight: SizeConfig.defaultSize * 7.5,
              hint: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  hintText,
                  style: hintTextStyle ??
                      TextStyle(
                          color: const Color(0xFF707070),
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.7),
                ),
              ),
              icon: const SizedBox(),
              iconSize: iconSize,
              isExpanded: true,
              validator: validator,
              decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  suffixIcon: Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.defaultSize * 0.5),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: const Color(0xFF8897A7),
                      size: SizeConfig.defaultSize * 2.5,
                    ),
                  ),
                  border: InputBorder.none),
              style: TextStyle(
                  color: const Color(0xFF707070),
                  fontFamily: kHelveticaRegular,
                  fontSize: SizeConfig.defaultSize * 1.7),
              value: value,
              items: listItems.map((valueItem) {
                return DropdownMenuItem(
                    value: valueItem,
                    child: Text(
                      valueItem,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: textSize ?? SizeConfig.defaultSize * 2.1,
                          fontFamily: kHelveticaRegular),
                    ));
              }).toList(),
              onChanged: onChanged),
        ),
      ),
    );
  }
}
