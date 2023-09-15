import 'package:flutter/material.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';

class PostOptions extends StatelessWidget {
  final Widget child;

  const PostOptions({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xFFF9F9F9),
            border: Border.all(color: const Color(0xFFE6E6E6), width: 0.3)),
        height: SizeConfig.defaultSize * 5.5,
        width: SizeConfig.defaultSize * 5.5,
        child: child);
  }
}
