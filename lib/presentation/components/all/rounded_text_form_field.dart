import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/presentation/components/all/outline_border_color.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';

class RoundedTextFormField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon, prefixIcon;
  final VoidCallback suffixOnPress;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool usePrefix, useSuffix, isEnable, isReadOnly;
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final TextInputType textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final bool? donotFocus;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const RoundedTextFormField(
      {Key? key,
      this.donotFocus,
      required this.textInputType,
      this.textInputFormatter,
      this.validator,
      this.textEditingController,
      required this.useSuffix,
      required this.usePrefix,
      this.prefixIcon,
      required this.hintText,
      this.suffixIcon,
      required this.suffixOnPress,
      this.onTap,
      required this.borderRadius,
      required this.isEnable,
      required this.isReadOnly,
      this.focusNode,
      this.contentPadding,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextFormField(
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: textInputType,
        inputFormatters:
            textInputType == TextInputType.number ? textInputFormatter! : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        enabled: isEnable,
        readOnly: isReadOnly,
        controller: textEditingController,
        onTap: onTap,
        minLines: 1,
        maxLines: 1,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.black,
            fontSize: SizeConfig.defaultSize * 2,
            fontFamily: kHelveticaRegular),
        decoration: InputDecoration(
          isCollapsed: true,
          filled: true,
          fillColor:
              isEnable == false ? const Color(0xFFF9F9F9) : Colors.transparent,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xFFD0E0F0)),
              borderRadius: BorderRadius.circular(borderRadius)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(borderRadius)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(borderRadius)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: donotFocus == true ? 1 : 2.5,
                  color: const Color(0xFFD0E0F0)),
              borderRadius: BorderRadius.circular(borderRadius)),
          contentPadding: EdgeInsets.only(
              top: SizeConfig.defaultSize * 1,
              left: SizeConfig.defaultSize * 1.5,
              bottom: SizeConfig.defaultSize * 1.5),
          disabledBorder: outlineInputBorder(
              color: Colors.grey[400]!, borderRadius: borderRadius),
          suffixIcon: useSuffix == true
              ? GestureDetector(
                  onTap: suffixOnPress,
                  child: suffixIcon,
                )
              : null,
          prefixIcon: usePrefix == true
              ? IconButton(
                  icon: prefixIcon!,
                  onPressed: suffixOnPress,
                  splashRadius: SizeConfig.defaultSize * 3,
                )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: SizeConfig.defaultSize * 1.4,
              color: const Color(0xFFA8A8A8),
              fontFamily: kHelveticaRegular),
        ),
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
