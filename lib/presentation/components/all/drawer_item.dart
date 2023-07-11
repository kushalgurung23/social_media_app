import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool selected, isLogOut;

  const DrawerItem(
      {Key? key,
      required this.text,
      required this.onTap,
      required this.selected,
      required this.isLogOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          selected: selected,
          selectedTileColor: const Color(0xFFA08875),
          onTap: onTap,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize),
            child: Text(
              text,
              style: isLogOut
                  ? TextStyle(
                      fontFamily: kHelveticaRegular,
                      color: const Color(0xFFC1024F),
                      fontSize: SizeConfig.defaultSize * 1.6)
                  : TextStyle(
                      fontFamily:
                          selected ? kHelveticaMedium : kHelveticaRegular,
                      color: selected ? Colors.white : Colors.black,
                      fontSize: selected
                          ? SizeConfig.defaultSize * 1.9
                          : SizeConfig.defaultSize * 1.6),
            ),
          ),
        ),
      ),
    );
  }
}
