import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/logic/providers/bottom_nav_provider.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              color: const Color(0xFF5545CF),
            ),
            showUnselectedLabels: true,
            selectedItemColor: const Color(0xFF5545CF),
            unselectedItemColor: const Color(0xFF454545),
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/news.svg',
                      color: navData.selectedIndex == 0
                          ? const Color(0xFF5545CF)
                          : const Color(0xFF454545)),
                  label: AppLocalizations.of(context).newsBottomTab),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/paper_share.svg',
                      color: navData.selectedIndex == 1
                          ? const Color(0xFF5545CF)
                          : const Color(0xFF454545)),
                  label: AppLocalizations.of(context).paperShareBottomTab),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/further_studies.svg',
                      color: navData.selectedIndex == 2
                          ? const Color(0xFF5545CF)
                          : const Color(0xFF454545)),
                  label: AppLocalizations.of(context).furtherStudiesBottomTab),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/interest_class.svg',
                      color: navData.selectedIndex == 3
                          ? const Color(0xFF5545CF)
                          : const Color(0xFF454545)),
                  label: AppLocalizations.of(context).interestClassBottomTab),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/svg/profile.svg',
                      color: navData.selectedIndex == 4
                          ? const Color(0xFF5545CF)
                          : const Color(0xFF454545)),
                  label: AppLocalizations.of(context).profileBottomTab),
            ],
          ),
        );
      },
    );
  }
}
