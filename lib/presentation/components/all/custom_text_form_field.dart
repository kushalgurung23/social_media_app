import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/presentation/components/all/outline_border_color.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final Widget? iconButton;
  final bool obscureText, isEnabled, isReadOnly;
  final FormFieldValidator validator;
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String>? onChanged;
  final TextEditingController? textEditingController;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final int? minLines, maxLines;
  final TextInputType textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFormField(
      {Key? key,
      this.textInputFormatter,
      this.onChanged,
      required this.textInputType,
      required this.labelText,
      required this.obscureText,
      this.iconButton,
      required this.validator,
      required this.isEnabled,
      required this.onSaved,
      this.textEditingController,
      required this.isReadOnly,
      this.floatingLabelBehavior,
      this.minLines,
      this.maxLines,
      this.autovalidateMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      keyboardType: textInputType,
      inputFormatters:
          textInputType == TextInputType.number ? textInputFormatter : null,
      readOnly: isReadOnly,
      controller: textEditingController,
      enabled: isEnabled,
      onChanged: onChanged,
      onSaved: onSaved,
      style: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.defaultSize * 2.1,
          fontFamily: kHelveticaRegular),
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: SizeConfig.defaultSize * 2.5,
            horizontal: SizeConfig.defaultSize),
        filled: true,
        fillColor:
            isEnabled == false ? const Color(0xFFF9F9F9) : Colors.transparent,
        floatingLabelBehavior: floatingLabelBehavior,
        errorStyle: TextStyle(
            color: Colors.red, fontSize: SizeConfig.defaultSize * 1.6),
        enabledBorder: outlineInputBorder(color: Colors.grey, borderRadius: 6),
        errorBorder: outlineInputBorder(color: Colors.red, borderRadius: 6),
        focusedBorder: outlineInputBorder(color: Colors.grey, borderRadius: 6),
        focusedErrorBorder:
            outlineInputBorder(color: Colors.red, borderRadius: 6),
        disabledBorder:
            outlineInputBorder(color: Colors.grey[400]!, borderRadius: 6),
        labelText: labelText,
        labelStyle: TextStyle(
            color: const Color(0xFF707070),
            fontFamily: kHelveticaRegular,
            fontSize: SizeConfig.defaultSize * 1.8),
        suffixIcon: iconButton,
      ),
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
    );
  }
}
