import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/logic/providers/bottom_nav_provider.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badges;

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, navData, child) {
        return Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white,
                blurRadius: 3,
                offset: Offset(0, -1),
              ),
            ],
          ),
          child: BottomNavigationBar(
            unselectedLabelStyle: TextStyle(
              fontSize: SizeConfig.defaultSize * 1.3,
              fontFamily: kHelveticaRegular,
              color: const Color(0xFF454545),
            ),
            currentIndex: navData.selectedIndex,
            onTap: (index) {
              navData.setBottomIndex(index: index, context: context);
            },
            selectedLabelStyle: TextStyle(
              fontSize: SizeConfig.defaultSize * 1.5,
              fontFamily: kHelveticaRegular,
              color: const Color(0xFFA08875),
            ),
            showUnselectedLabels: true,
            selectedItemColor: const Color(0xFFA08875),
            unselectedItemColor: const Color(0xFF454545),
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg/news.svg',
                    color: navData.selectedIndex == 0
                        ? const Color(0xFFA08875)
                        : const Color(0xFF454545),
                    height: SizeConfig.defaultSize * 2.5,
                    width: SizeConfig.defaultSize * 2.5,
                  ),
                  label: AppLocalizations.of(context).newsBottomTab),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg/interest_class.svg',
                    color: navData.selectedIndex == 1
                        ? const Color(0xFFA08875)
                        : const Color(0xFF454545),
                    height: SizeConfig.defaultSize * 2.5,
                    width: SizeConfig.defaultSize * 2.5,
                  ),
                  label: AppLocalizations.of(context).serviceBottomTab),
              BottomNavigationBarItem(
                  icon: Consumer<NewsAdProvider>(
                    builder: (context, data, child) {
                      return badges.Badge(
                        showBadge: false,
                        badgeContent: const Text(''),
                        badgeColor: Colors.red,
                        position: badges.BadgePosition.topEnd(
                            top: SizeConfig.defaultSize * -0.8, end: 0),
                        child: SvgPicture.asset(
                            "assets/svg/notification-bell.svg",
                            color: navData.selectedIndex == 2
                                ? const Color(0xFFA08875)
                                : const Color(0xFF454545),
                            height: SizeConfig.defaultSize * 2.8,
                            width: SizeConfig.defaultSize * 2.8),
                      );
                    },
                  ),
                  label: AppLocalizations.of(context).notificationBottomTab),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/svg/profile.svg',
                    color: navData.selectedIndex == 3
                        ? const Color(0xFFA08875)
                        : const Color(0xFF454545),
                    height: SizeConfig.defaultSize * 2.5,
                    width: SizeConfig.defaultSize * 2.5,
                  ),
                  label: AppLocalizations.of(context).profileBottomTab),
            ],
          ),
        );
      },
    );
  }
}
// \   Container(
//           margin: EdgeInsets.only(right: SizeConfig.defaultSize),
//           color: Colors.transparent,
//           height: SizeConfig.defaultSize * 5.3,
//           width: SizeConfig.defaultSize * 4.8,
//           child: Consumer<NewsAdProvider>(
//             builder: (context, data, child) {
//               return badges.Badge(
//                 showBadge: data.followNotificationBadge == true ||
//                         data.sharedPreferences
//                                 .getBool("follow_push_notification") ==
//                             true
//                     ? true
//                     : false,
//                 badgeContent: const Text(''),
//                 badgeColor: Colors.red,
//                 position: badges.BadgePosition.topEnd(
//                     top: 0, end: SizeConfig.defaultSize * 0.8),
//                 child: IconButton(
//                   splashRadius: SizeConfig.defaultSize * 2.5,
//                   icon: SvgPicture.asset("assets/svg/notification-bell.svg",
//                       color: const Color(0xFF8897A7),
//                       height: SizeConfig.defaultSize * 2.1,
//                       width: SizeConfig.defaultSize * 2.6),
//                   onPressed: () async {
//                     await Navigator.pushNamed(context, NotificationScreen.id);
//                     data.setUnreadNotificationBadge(context: context);
//                   },
//                 ),
//               );
//             },
//           ),
//         ),