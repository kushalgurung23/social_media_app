import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/models/push_notification_model.dart';
import 'package:spa_app/logic/providers/notification_provider.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowNotificationTab extends StatefulWidget {
  const FollowNotificationTab({Key? key}) : super(key: key);

  @override
  State<FollowNotificationTab> createState() => _FollowNotificationTabState();
}

class _FollowNotificationTabState extends State<FollowNotificationTab> {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<NotificationProvider>(context, listen: false)
        .refreshPushNotification(context: context);

    // this will load more data when we reach the end of paper share
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
    super.initState();
  }

  void loadNextData() async {
    await Provider.of<NotificationProvider>(context, listen: false)
        .loadMorePushNotifications(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, data, child) {
        return StreamBuilder<PushNotification?>(
            stream: data.pushNotificationStreamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text(AppLocalizations.of(context).loading,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  );
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                          AppLocalizations.of(context)
                              .notificationCouldNotBeLoaded,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else {
                    return snapshot.data!.data!.isEmpty &&
                            data.isNotificationRefresh == false
                        ? Center(
                            child: Text(
                                AppLocalizations.of(context).noNotification,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5)))
                        : snapshot.data!.data!.isEmpty &&
                                data.isNotificationRefresh == true
                            ? Center(
                                child: Text(
                                    AppLocalizations.of(context).reloading,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kHelveticaRegular,
                                        fontSize:
                                            SizeConfig.defaultSize * 1.5)))
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize * 2),
                                child: RefreshIndicator(
                                  onRefresh: () => data.refreshPushNotification(
                                      context: context),
                                  child: ListView.builder(
                                      controller: scrollController,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                      itemCount:
                                          snapshot.data!.data!.length >= 15
                                              ? snapshot.data!.data!.length + 1
                                              : snapshot.data!.data!.length,
                                      itemBuilder: (context, index) {
                                        if (index <
                                            snapshot.data!.data!.length) {
                                          final pushNotification = snapshot
                                              .data!.data![index]!.attributes;
                                          return InkWell(
                                            onTap: () {
                                              data.notificationOnTap(
                                                isRead: pushNotification
                                                            .isRead !=
                                                        null
                                                    ? pushNotification.isRead!
                                                    : false,
                                                notificationId: snapshot
                                                    .data!.data![index]!.id
                                                    .toString(),
                                                context: context,
                                                notificationSenderId:
                                                    pushNotification
                                                        .sender!.data!.id!
                                                        .toString(),
                                              );
                                            },
                                            child: Container(
                                              margin: index == 0
                                                  ? EdgeInsets.only(
                                                      top: SizeConfig
                                                              .defaultSize *
                                                          1,
                                                      bottom: SizeConfig
                                                              .defaultSize *
                                                          1)
                                                  : EdgeInsets.only(
                                                      bottom: SizeConfig
                                                              .defaultSize *
                                                          1),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: pushNotification!
                                                            .isRead ==
                                                        true
                                                    ? Colors.white
                                                    : const Color(0xFF5545CF)
                                                        .withOpacity(0.3),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        SizeConfig.defaultSize *
                                                            1,
                                                    horizontal:
                                                        SizeConfig.defaultSize *
                                                            1),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            4,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: SizeConfig
                                                                          .defaultSize *
                                                                      0.3,
                                                                  left: SizeConfig
                                                                          .defaultSize *
                                                                      0.25),
                                                              child: data.returnIcon(
                                                                  type: pushNotification
                                                                      .type
                                                                      .toString()),
                                                            ),
                                                          ],
                                                        )),
                                                    Expanded(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text: pushNotification
                                                                    .sender!
                                                                    .data!
                                                                    .attributes!
                                                                    .username
                                                                    .toString() +
                                                                " ",
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontFamily:
                                                                  kHelveticaRegular,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.4,
                                                            ),
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                  text: data.returnMessage(
                                                                      context:
                                                                          context,
                                                                      type: pushNotification
                                                                          .type
                                                                          .toString()),
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          kHelveticaMedium,
                                                                      fontSize:
                                                                          SizeConfig.defaultSize *
                                                                              1.3)),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: SizeConfig
                                                                      .defaultSize *
                                                                  0.2),
                                                          child: Text(
                                                            data.mainScreenProvider
                                                                .convertDateTimeToAgo(
                                                                    pushNotification
                                                                        .createdAt!,
                                                                    context),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              height: 1.3,
                                                              fontFamily:
                                                                  kHelveticaRegular,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.25,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                    pushNotification
                                                                .sender!
                                                                .data!
                                                                .attributes!
                                                                .profileImage!
                                                                .data ==
                                                            null
                                                        ? Container(
                                                            margin: EdgeInsets.only(
                                                                left: SizeConfig
                                                                        .defaultSize *
                                                                    2.5),
                                                            height: SizeConfig
                                                                    .defaultSize *
                                                                4,
                                                            width: SizeConfig
                                                                    .defaultSize *
                                                                4,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      SizeConfig
                                                                              .defaultSize *
                                                                          1.5),
                                                              color:
                                                                  Colors.white,
                                                              image: const DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/default_profile.jpg"),
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsets.only(
                                                                left: SizeConfig
                                                                        .defaultSize *
                                                                    2.5),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: kIMAGEURL +
                                                                  pushNotification
                                                                      .sender!
                                                                      .data!
                                                                      .attributes!
                                                                      .profileImage!
                                                                      .data!
                                                                      .attributes!
                                                                      .url
                                                                      .toString(),
                                                              imageBuilder:
                                                                  (context,
                                                                          imageProvider) =>
                                                                      Container(
                                                                height: SizeConfig
                                                                        .defaultSize *
                                                                    4,
                                                                width: SizeConfig
                                                                        .defaultSize *
                                                                    4,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          SizeConfig.defaultSize *
                                                                              1.5),
                                                                  color: Colors
                                                                      .white,
                                                                  image: DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ),
                                                              ),
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Container(
                                                                height: SizeConfig
                                                                        .defaultSize *
                                                                    4.7,
                                                                width: SizeConfig
                                                                        .defaultSize *
                                                                    4.7,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          SizeConfig.defaultSize *
                                                                              1.5),
                                                                  color: const Color(
                                                                      0xFFD0E0F0),
                                                                ),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig.defaultSize,
                                                  bottom:
                                                      SizeConfig.defaultSize *
                                                          3),
                                              child: data.notificationHasMore
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              color: Color(
                                                                  0xFF5545CF)))
                                                  : Center(
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
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
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
