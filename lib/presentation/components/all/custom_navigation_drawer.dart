import 'package:flutter/material.dart';
import 'package:spa_app/data/enum/navigation_items.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/components/all/drawer_item.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(builder: (context, data, child) {
      return Drawer(
        width: SizeConfig.defaultSize * 30,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: SizeConfig.defaultSize * 4),
                        Divider(
                          thickness: SizeConfig.defaultSize * 0.6,
                          color: const Color(0xFF5545CF),
                        ),
                        SizedBox(height: SizeConfig.defaultSize * 4),
                        DrawerItem(
                          selected: NavigationItems.home == data.navigationItem,
                          text: AppLocalizations.of(context).home,
                          onTap: () {
                            data.setAndNavigateToDrawerItem(
                                navigationItem: NavigationItems.home,
                                context: context);
                          },
                          isLogOut: false,
                        ),
                        SizedBox(height: SizeConfig.defaultSize),
                        DrawerItem(
                          isLogOut: false,
                          text: AppLocalizations.of(context).termsAndConditions,
                          selected: NavigationItems.termsAndConditions ==
                              data.navigationItem,
                          onTap: () {
                            data.setAndNavigateToDrawerItem(
                                navigationItem:
                                    NavigationItems.termsAndConditions,
                                context: context);
                          },
                        ),
                        SizedBox(height: SizeConfig.defaultSize),
                        DrawerItem(
                          isLogOut: false,
                          text: AppLocalizations.of(context).privacyPolicy,
                          selected: NavigationItems.privacyPolicy ==
                              data.navigationItem,
                          onTap: () {
                            data.setAndNavigateToDrawerItem(
                                navigationItem: NavigationItems.privacyPolicy,
                                context: context);
                          },
                        ),
                        SizedBox(height: SizeConfig.defaultSize),
                        DrawerItem(
                          isLogOut: false,
                          text: AppLocalizations.of(context).language,
                          selected:
                              NavigationItems.language == data.navigationItem,
                          onTap: () {
                            data.setAndNavigateToDrawerItem(
                                navigationItem: NavigationItems.language,
                                context: context);
                          },
                        ),
                        SizedBox(height: SizeConfig.defaultSize),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize / 2,
              ),
              DrawerItem(
                isLogOut: true,
                text: AppLocalizations.of(context).logOut,
                selected: NavigationItems.logOut == data.navigationItem,
                onTap: () {
                  Provider.of<MainScreenProvider>(context, listen: false)
                      .socket
                      .close();
                  Provider.of<MainScreenProvider>(context, listen: false)
                      .socket
                      .dispose();
                  data.setNavigationOnly(navigationItems: NavigationItems.home);
                  data.removeCredentials(context: context);
                },
              ),
              SizedBox(
                height: SizeConfig.defaultSize / 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 3.5),
                child: Text(
                  '${AppLocalizations.of(context).version} ${data.mainScreenProvider.version}',
                  style: TextStyle(
                    fontSize: SizeConfig.defaultSize * 1.2,
                    fontFamily: kHelveticaMedium,
                    color: const Color(0xFFBABABA),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize * 2.5,
              )
            ],
          ),
        ),
      );
    });
  }
}
