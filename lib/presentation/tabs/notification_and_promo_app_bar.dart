import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/constant/font_constant.dart';
import '../components/all/top_app_bar.dart';
import '../helper/size_configuration.dart';

AppBar notificationAndPromoAppBar(BuildContext context) => (topAppBar(
    title: AppLocalizations.of(context).notification,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(
        SizeConfig.defaultSize * 5,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.5),
        child: TabBar(
          tabs: [
            // translate
            const Tab(text: 'Notifications'),
            Tab(text: AppLocalizations.of(context).promotions),
          ],
          labelColor: const Color(0xFFA08875),
          indicatorColor: const Color(0xFFA08875),
          unselectedLabelColor: const Color(0xFF707070),
          labelStyle: TextStyle(
              fontFamily: kHelveticaMedium,
              fontSize: SizeConfig.defaultSize * 1.4),
          unselectedLabelStyle: TextStyle(
              fontFamily: kHelveticaMedium,
              fontSize: SizeConfig.defaultSize * 1.4),
        ),
      ),
    )));
