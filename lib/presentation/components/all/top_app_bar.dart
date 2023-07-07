import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';

AppBar topAppBar({
  Widget? leadingWidget,
  String? title,
  List<Widget>? widgetList,
  PreferredSizeWidget? bottom,
  VoidCallback? titleOnTap,
}) {
  return AppBar(
    toolbarHeight: SizeConfig.defaultSize * 5,
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Colors.white,
    centerTitle: true,
    leading: leadingWidget,
    leadingWidth: SizeConfig.defaultSize * 5,
    title: GestureDetector(
      onTap: titleOnTap,
      child: Text(
        title ?? '',
        style: TextStyle(
            color: Colors.black,
            fontSize: SizeConfig.defaultSize * 1.9,
            fontFamily: kHelveticaRegular),
      ),
    ),
    actions: widgetList,
    bottom: bottom,
  );
}
