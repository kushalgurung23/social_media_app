import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  //MediaQueryData property contains width and height of a current window.
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  //Orientation helps to adjust all the widgets while in both portrait and landscape mode.
  static late Orientation orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    // On iphone 11, the default size is almost 10.
    // If the screen size varies, our default size also vary
    // 9.874 = defaultSize of Nexus 6 API 26
    defaultSize = orientation == Orientation.landscape
        ? screenHeight * 0.024
        : screenWidth * 0.024;
  }
}
