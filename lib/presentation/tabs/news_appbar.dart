import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

AppBar newsAppBar(BuildContext context) {
  SizeConfig.init(context);
  return topAppBar(
      leadingWidget: Padding(
        padding: EdgeInsets.only(left: SizeConfig.defaultSize),
        child: Builder(builder: (leadingContext) {
          return Consumer<DrawerProvider>(
            builder: (context, data, child) {
              return IconButton(
                constraints: const BoxConstraints(),
                splashRadius: SizeConfig.defaultSize * 2.5,
                onPressed: () {
                  if (data.navigationItem != NavigationItems.home) {
                    data.setNavigationOnly(
                        navigationItems: NavigationItems.home);
                  }

                  Scaffold.of(leadingContext).openDrawer();
                },
                icon: SvgPicture.asset("assets/svg/menu.svg",
                    color: const Color(0xFF8897A7),
                    height: SizeConfig.defaultSize * 1.5,
                    width: SizeConfig.defaultSize * 2),
              );
            },
          );
        }),
      ),
      title: AppLocalizations.of(context).news,
      widgetList: [
        SizedBox(
          width: SizeConfig.defaultSize,
        )
      ]);
}
