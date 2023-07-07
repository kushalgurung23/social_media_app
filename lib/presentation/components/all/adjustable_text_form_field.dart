import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/components/all/outline_border_color.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';

class AdjustableTextFormField extends StatelessWidget {
  final String hintText;
  final Widget? suffixIcon, prefixIcon;
  final VoidCallback iconOnPress;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool usePrefix, useSuffix, isEnable, isReadOnly;
  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final TextInputType textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final int minLines;
  final int? maxLines, maxLength;
  final FocusNode? focusNode;
  final double? hintTextFontSize;
  final AutovalidateMode? autovalidateMode;
  final bool? isReset;

  const AdjustableTextFormField(
      {Key? key,
      this.maxLength,
      this.focusNode,
      required this.minLines,
      this.maxLines,
      required this.textInputType,
      this.textInputFormatter,
      this.validator,
      this.textEditingController,
      required this.useSuffix,
      required this.usePrefix,
      this.prefixIcon,
      required this.hintText,
      this.suffixIcon,
      required this.iconOnPress,
      this.onTap,
      required this.borderRadius,
      required this.isEnable,
      required this.isReadOnly,
      this.autovalidateMode,
      this.isReset = false,
      this.hintTextFontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: textInputType,
      focusNode: focusNode,
      inputFormatters:
          textInputType == TextInputType.number ? textInputFormatter! : null,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      validator: validator,
      enabled: isEnable,
      readOnly: isReadOnly,
      controller: textEditingController,
      onTap: onTap,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.defaultSize * 2,
          fontFamily: kHelveticaRegular),
      decoration: InputDecoration(
        filled: true,
        fillColor:
            isEnable == false ? const Color(0xFFF9F9F9) : Colors.transparent,
        errorStyle: TextStyle(
            fontSize: SizeConfig.defaultSize * 1.6, color: Colors.red),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Color(0xFFD0E0F0)),
            borderRadius: BorderRadius.circular(borderRadius)),
        errorBorder: isReset == false
            ? OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(borderRadius))
            : OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 1, color: Color(0xFFD0E0F0)),
                borderRadius: BorderRadius.circular(borderRadius)),
        focusedErrorBorder: isReset == false
            ? OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(borderRadius))
            : OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2.5, color: Color(0xFFD0E0F0)),
                borderRadius: BorderRadius.circular(borderRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2.5, color: Color(0xFFD0E0F0)),
            borderRadius: BorderRadius.circular(borderRadius)),
        contentPadding: EdgeInsets.only(
          left: SizeConfig.defaultSize * 1.5,
          top: SizeConfig.defaultSize * 1.5,
        ),
        disabledBorder: outlineInputBorder(
            color: Colors.grey[400]!, borderRadius: borderRadius),
        suffixIcon: useSuffix == true
            ? Align(
                widthFactor: 1,
                heightFactor: 1,
                child: IconButton(
                  icon: suffixIcon!,
                  onPressed: iconOnPress,
                  splashRadius: SizeConfig.defaultSize * 3,
                ),
              )
            : null,
        prefixIcon: usePrefix == true
            ? IconButton(
                icon: prefixIcon!,
                onPressed: iconOnPress,
                splashRadius: SizeConfig.defaultSize * 3,
              )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: hintTextFontSize ?? SizeConfig.defaultSize * 1.4,
            color: const Color(0xFFA8A8A8),
            fontFamily: kHelveticaRegular),
      ),
      textAlignVertical: TextAlignVertical.center,
    );
  }
}
