import 'package:c_talent/presentation/views/services/bookmark_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppBar interestAppBar({required BuildContext context}) {
  return topAppBar(
      title: AppLocalizations.of(context).serviceBottomTab,
      widgetList: [
        Builder(builder: (context) {
          return Container(
              margin: EdgeInsets.only(right: SizeConfig.defaultSize),
              color: Colors.transparent,
              height: SizeConfig.defaultSize * 5.3,
              width: SizeConfig.defaultSize * 4.8,
              child: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: SvgPicture.asset("assets/svg/appbar_save.svg",
                    color: const Color(0xFF8897A7),
                    height: SizeConfig.defaultSize * 2.1,
                    width: SizeConfig.defaultSize * 2.6),
                onPressed: () {
                  Navigator.pushNamed(context, BookmarkServicesScreen.id);
                },
              ));
        }),
      ]);
}
