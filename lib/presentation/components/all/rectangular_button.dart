import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String text, fontFamily;
  final Color textColor, buttonColor, borderColor;
  final double? height, width;
  final bool keepBoxShadow;
  final Offset? offset;
  final double? blurRadius;
  final double fontSize, borderRadius;
  final EdgeInsets textPadding;

  const RectangularButton(
      {Key? key,
      required this.textPadding,
      required this.onPress,
      required this.text,
      required this.textColor,
      required this.buttonColor,
      this.height,
      this.width,
      required this.borderColor,
      required this.fontFamily,
      required this.keepBoxShadow,
      this.offset,
      this.blurRadius,
      required this.fontSize,
      required this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: keepBoxShadow
            ? [
                BoxShadow(
                  color: const Color(0x00000000).withOpacity(0.16),
                  spreadRadius: 0,
                  blurRadius: blurRadius!,
                  offset: offset!, // changes position of shadow
                ),
              ]
            : [],
      ),
      child: TextButton(
        onPressed: onPress,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: borderColor, width: 0.5)),
          backgroundColor: buttonColor,
        ),
        child: Padding(
          padding: textPadding,
          child: Text(
            text,
            style: TextStyle(
                // overflow: TextOverflow.ellipsis,
                color: textColor,
                fontSize: fontSize,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}
