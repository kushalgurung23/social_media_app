import 'package:c_talent/presentation/components/notification_and_promotion/notification_body.dart';
import 'package:c_talent/presentation/components/notification_and_promotion/promotion_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/constant/font_constant.dart';
import '../components/all/top_app_bar.dart';
import '../helper/size_configuration.dart';

class NotificationAndPromotionTab extends StatefulWidget {
  const NotificationAndPromotionTab({Key? key}) : super(key: key);

  @override
  State<NotificationAndPromotionTab> createState() =>
      _NotificationAndPromotionTabState();
}

class _NotificationAndPromotionTabState
    extends State<NotificationAndPromotionTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: topAppBar(
            title: AppLocalizations.of(context).notification,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                SizeConfig.defaultSize * 5,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 1.5),
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
            )),
        body: const TabBarView(
          children: [NotificationBody(), PromotionBody()],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
