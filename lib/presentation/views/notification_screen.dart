import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/logic/providers/notification_provider.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/chat/promotion_tab.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/components/chat/follow_notification_tab.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  static const String id = '/notification_screen';

  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, data, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: topAppBar(
                leadingWidget: IconButton(
                  splashRadius: SizeConfig.defaultSize * 2.5,
                  icon: Icon(CupertinoIcons.back,
                      color: const Color(0xFF8897A7),
                      size: SizeConfig.defaultSize * 2.7),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: AppLocalizations.of(context).notification,
                bottom: TabBar(
                  tabs: [
                    Tab(
                        text: data.getMessageTabHeading(
                            index: 0, context: context)),
                    Tab(
                        text: data.getMessageTabHeading(
                            index: 1, context: context)),
                  ],
                  labelColor: const Color(0xFF5545CF),
                  indicatorColor: const Color(0xFF5545CF),
                  unselectedLabelColor: const Color(0xFF707070),
                  labelStyle: TextStyle(
                      fontFamily: kHelveticaMedium,
                      fontSize: SizeConfig.defaultSize * 1.4),
                  unselectedLabelStyle: TextStyle(
                      fontFamily: kHelveticaMedium,
                      fontSize: SizeConfig.defaultSize * 1.4),
                )),
            body: const TabBarView(
              children: [FollowNotificationTab(), PromotionTab()],
            ),
          ),
        );
      },
    );
  }
}
