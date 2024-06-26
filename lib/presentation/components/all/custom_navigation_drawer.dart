import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/presentation/components/all/drawer_item.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
                          color: const Color(0xFFA08875),
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
                  data.logOut(context: context, isShowLoggingOut: true);
                },
              ),
              SizedBox(
                height: SizeConfig.defaultSize / 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2.5),
                child: Text(
                  'Copyright © 2023 Fame Standard Limited All Rights Reserved',
                  style: TextStyle(
                    fontSize: SizeConfig.defaultSize * 1.2,
                    fontFamily: kHelveticaMedium,
                    color: const Color(0xFFBABABA),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.defaultSize / 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2.5),
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
