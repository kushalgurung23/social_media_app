import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/data/enum/navigation_items.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/components/chat/chatroom_screen.dart';
import 'package:c_talent/presentation/views/discover_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppBar newsAppBar(BuildContext context) {
  SizeConfig.init(context);
  return topAppBar(
      leadingWidget: Padding(
        padding: EdgeInsets.only(left: SizeConfig.defaultSize),
        child: Builder(builder: (leadingContext) {
          return Consumer<DrawerProvider>(
            builder: (context, data, child) {
              return IconButton(
                constraints: const BoxConstraints(),
                splashRadius: SizeConfig.defaultSize * 2.5,
                onPressed: () {
                  if (data.navigationItem != NavigationItems.home) {
                    data.setNavigationOnly(
                        navigationItems: NavigationItems.home);
                  }

                  Scaffold.of(leadingContext).openDrawer();
                },
                icon: SvgPicture.asset("assets/svg/menu.svg",
                    color: const Color(0xFF8897A7),
                    height: SizeConfig.defaultSize * 1.5,
                    width: SizeConfig.defaultSize * 2),
              );
            },
          );
        }),
      ),
      title: AppLocalizations.of(context).news,
      widgetList: [
        Builder(builder: (context) {
          return Container(
            color: Colors.transparent,
            height: SizeConfig.defaultSize * 5.3,
            width: SizeConfig.defaultSize * 4.8,
            child: badges.Badge(
              showBadge: false,
              child: IconButton(
                splashRadius: SizeConfig.defaultSize * 2.5,
                icon: SvgPicture.asset("assets/svg/search.svg",
                    color: const Color(0xFF8897A7),
                    height: SizeConfig.defaultSize * 2.1,
                    width: SizeConfig.defaultSize * 2.6),
                onPressed: () {
                  Navigator.pushNamed(context, DiscoverScreen.id);
                },
              ),
            ),
          );
        }),
        Builder(builder: (context) {
          return Container(
              color: Colors.transparent,
              height: SizeConfig.defaultSize * 5.3,
              width: SizeConfig.defaultSize * 4.8,
              child: Consumer<ChatMessageProvider>(
                builder: ((context, data, child) {
                  return badges.Badge(
                    showBadge: data.messageNotificationBadge == true ||
                            data.sharedPreferences.getBool(
                                    "chat_message_push_notification") ==
                                true
                        ? true
                        : false,
                    badgeContent: const Text(''),
                    badgeColor: Colors.red,
                    position: badges.BadgePosition.topEnd(
                        top: 0, end: SizeConfig.defaultSize * 0.8),
                    child: IconButton(
                      splashRadius: SizeConfig.defaultSize * 2.5,
                      icon: SvgPicture.asset("assets/svg/message_box.svg",
                          color: const Color(0xFF8897A7),
                          height: SizeConfig.defaultSize * 2.1,
                          width: SizeConfig.defaultSize * 2.6),
                      onPressed: () {
                        // removing active chat username if any to allow to receive message notification from them
                        data.sharedPreferences.remove('active_chat_username');
                        Navigator.pushNamed(context, ChatroomScreen.id);
                        data.setCurrentlyOnChatroomScreen();
                        if (data.sharedPreferences.getBool(
                                    "chat_message_push_notification") ==
                                true ||
                            data.messageNotificationBadge == true) {
                          data.removeChatMessageNotificationBadge();
                        }
                      },
                    ),
                  );
                }),
              ));
        }),
        SizedBox(
          width: SizeConfig.defaultSize,
        )
      ]);
}
