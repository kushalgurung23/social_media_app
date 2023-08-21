import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';

class CustomDropdownButton extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> listItems;
  final FormFieldSetter<String> onChanged;
  final double iconSize;

  const CustomDropdownButton(
      {Key? key,
      required this.iconSize,
      required this.hintText,
      required this.value,
      required this.listItems,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize, vertical: 0),
      child: Center(
        child: DropdownButton(
            underline: const SizedBox(),
            hint: Text(
              hintText,
              style: TextStyle(
                  color: const Color(0xFF707070),
                  fontFamily: kHelveticaRegular,
                  fontSize: SizeConfig.defaultSize * 1.7),
            ),
            icon:
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8897A7)),
            iconSize: iconSize,
            isExpanded: true,
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
                        fontSize: SizeConfig.defaultSize * 2.1,
                        fontFamily: kHelveticaRegular),
                  ));
            }).toList(),
            onChanged: onChanged),
      ),
    );
  }
}
