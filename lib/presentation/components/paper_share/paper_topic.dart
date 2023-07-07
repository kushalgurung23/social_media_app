import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';

class PaperTopic extends StatelessWidget {
  final String category, categoryValue;
  final double categoryFontSize, categoryValueFontSize;
  const PaperTopic(
      {Key? key,
      required this.category,
      required this.categoryValue,
      required this.categoryFontSize,
      required this.categoryValueFontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            color: const Color(0xFF8897A7),
            fontFamily: kHelveticaMedium,
            fontSize: categoryFontSize,
          ),
        ),
        SizedBox(
          height: SizeConfig.defaultSize * 0.3,
        ),
        Text(
          categoryValue,
          style: TextStyle(
            color: Colors.black,
            fontFamily: kHelveticaMedium,
            fontSize: categoryValueFontSize,
          ),
        )
      ],
    );
  }
}
