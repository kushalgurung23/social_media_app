import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditImage extends StatelessWidget {
  final VoidCallback onTap;

  const EditImage({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: SizeConfig.defaultSize * 2.5,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xFF000000).withOpacity(0.53),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Center(
                    child: Text(AppLocalizations.of(context).editPhoto,
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 1.15,
                            fontFamily: kHelveticaMedium,
                            color: const Color(0xFFFFFFFF)))),
              ),
            ))
      ],
    );
  }
}
