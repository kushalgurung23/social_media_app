import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/presentation/components/all/custom_navigation_drawer.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  static const String id = '/language_screen';

  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomNavigationDrawer(),
      appBar: topAppBar(
        leadingWidget: IconButton(
          splashRadius: SizeConfig.defaultSize * 2.5,
          icon: Icon(CupertinoIcons.back,
              color: const Color(0xFF8897A7),
              size: SizeConfig.defaultSize * 2.7),
          onPressed: () {
            final drawerProvider =
                Provider.of<DrawerProvider>(context, listen: false);
            if (drawerProvider.navigationItem != NavigationItems.home) {
              drawerProvider.setNavigationOnly(
                  navigationItems: NavigationItems.home);
            }
            Navigator.of(context).pop();
          },
        ),
        title: AppLocalizations.of(context).language,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(SizeConfig.defaultSize * 7,
            SizeConfig.defaultSize * 2, SizeConfig.defaultSize * 7, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
              child: Center(
                child: RectangularButton(
                  textPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 1.5),
                  height: SizeConfig.defaultSize * 5,
                  width: double.infinity,
                  onPress: () {},
                  text: "English",
                  textColor: Colors.white,
                  buttonColor: const Color(0xFFA08875),
                  borderColor: const Color(0xFFFFFFFF),
                  fontFamily: kHelveticaRegular,
                  keepBoxShadow: true,
                  offset: const Offset(0, 3),
                  borderRadius: 6,
                  blurRadius: 6,
                  fontSize: SizeConfig.defaultSize * 1.5,
                ),
              ),
            ),
            // Chinese traditional
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
                child: RectangularButton(
                  textPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 1.5),
                  height: SizeConfig.defaultSize * 5,
                  width: double.infinity,
                  onPress: () {
                    // data.setLocale(const Locale.fromSubtags(
                    //     languageCode: 'zh', scriptCode: 'Hant'));
                  },
                  text: "繁體中文",
                  textColor: Colors.white,
                  buttonColor: const Color(0xFFA08875),
                  borderColor: const Color(0xFFFFFFFF),
                  fontFamily: kHelveticaRegular,
                  keepBoxShadow: true,
                  offset: const Offset(0, 3),
                  borderRadius: 6,
                  blurRadius: 6,
                  fontSize: SizeConfig.defaultSize * 1.5,
                ),
              ),
            ),
            // Chinese simplified
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
                child: RectangularButton(
                  textPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 1.5),
                  height: SizeConfig.defaultSize * 5,
                  width: double.infinity,
                  onPress: () {
                    // data.setLocale(const Locale.fromSubtags(
                    //     languageCode: 'zh', scriptCode: 'Hans'));
                  },
                  text: "简体中文",
                  textColor: Colors.white,
                  buttonColor: const Color(0xFFA08875),
                  borderColor: const Color(0xFFFFFFFF),
                  fontFamily: kHelveticaRegular,
                  keepBoxShadow: true,
                  offset: const Offset(0, 3),
                  borderRadius: 6,
                  blurRadius: 6,
                  fontSize: SizeConfig.defaultSize * 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
