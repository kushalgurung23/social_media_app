import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/notification_provider.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/chat/follow_notification_tab.dart';
import 'package:c_talent/presentation/components/chat/promotion_tab.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<NotificationProvider>(
      builder: (context, data, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: topAppBar(
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
                  labelColor: const Color(0xFFA08875),
                  indicatorColor: const Color(0xFFA08875),
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

  @override
  bool get wantKeepAlive => true;
}
