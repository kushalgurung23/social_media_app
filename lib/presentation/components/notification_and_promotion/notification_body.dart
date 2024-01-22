import 'package:c_talent/data/models/all_push_notifications.dart';
import 'package:c_talent/logic/providers/push_notification_provider.dart';
import 'package:c_talent/presentation/components/notification_and_promotion/push_notification_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class NotificationBody extends StatefulWidget {
  const NotificationBody({super.key});

  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<PushNotificationProvider>(context, listen: false)
        .loadInitialPushNotifications(context: context);

    // this will load more data when we reach the end of services
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMorePushNotifications();
      }
    });
    super.initState();
  }

  void loadMorePushNotifications() async {
    await Provider.of<PushNotificationProvider>(context, listen: false)
        .loadMorePushNotifications(context: context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PushNotificationProvider>(builder: (context, data, child) {
      return StreamBuilder<AllPushNotifications?>(
          stream: data.allPushNotificationStreamController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    AppLocalizations.of(context).loading,
                    style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5),
                  ),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).refreshPage,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).dataCouldNotLoad,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else {
                  return snapshot.data?.notifications == null ||
                          snapshot.data!.notifications!.isEmpty
                      ? Center(
                          child: Text(
                            data.pushNotificationIsLoading == true ||
                                    data.isRefreshingNotification == true
                                ? AppLocalizations.of(context).loading
                                // translate
                                : 'Push notification not available',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 1.5),
                          child: RefreshIndicator(
                            onRefresh: () =>
                                data.refreshPushNotifications(context: context),
                            child: ListView.builder(
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                itemCount:
                                    snapshot.data!.notifications!.length >= 10
                                        ? snapshot.data!.notifications!.length +
                                            1
                                        : snapshot.data!.notifications!.length,
                                itemBuilder: (context, index) {
                                  if (index <
                                      snapshot.data!.notifications!.length) {
                                    final pushNotification =
                                        snapshot.data!.notifications![index];
                                    return PushNotificationContainer(
                                      index: index,
                                      pushNotification: pushNotification,
                                    );
                                  } else {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.defaultSize,
                                            bottom: SizeConfig.defaultSize * 3),
                                        child: data.pushNotificationHasMore
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color:
                                                            Color(0xFFA08875)))
                                            : Center(
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .caughtUp,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaRegular,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.5),
                                                ),
                                              ));
                                  }
                                }),
                          ),
                        );
                }
            }
          });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
