import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';

import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/components/paper_share/bookmark_paper_share_listview.dart';
import 'package:spa_app/presentation/views/paper_share_new_post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppBar paperShareAppBar({required BuildContext context}) {
  return topAppBar(
      leadingWidget: null,
      title: AppLocalizations.of(context).paperShare,
      widgetList: [
        Builder(builder: (context) {
          return Container(
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
                Navigator.of(context).pushNamed(BookmarkPaperShareListview.id);
              },
            ),
          );
        }),
        Builder(builder: (context) {
          return Container(
              margin: EdgeInsets.only(right: SizeConfig.defaultSize),
              color: Colors.transparent,
              height: SizeConfig.defaultSize * 5.3,
              width: SizeConfig.defaultSize * 4.8,
              child: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: SvgPicture.asset("assets/svg/paper_share_add.svg",
                    color: const Color(0xFF8897A7),
                    height: SizeConfig.defaultSize * 2.1,
                    width: SizeConfig.defaultSize * 2.6),
                onPressed: () {
                  Navigator.pushNamed(context, PaperShareNewPost.id);
                },
              ));
        }),
      ]);
}
