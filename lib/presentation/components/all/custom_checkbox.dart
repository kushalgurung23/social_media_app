import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool checkboxValue, inCenter;
  final ValueChanged onChanged;
  final Widget title;

  const CustomCheckbox(
      {Key? key,
      required this.checkboxValue,
      required this.onChanged,
      required this.title,
      required this.inCenter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          inCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Checkbox(
            activeColor: const Color(0xFFC1024F),
            value: checkboxValue,
            onChanged: onChanged,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
        Expanded(child: title)
      ],
    );
  }
}
