import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/profile/other_profile_top_container.dart';
import 'package:spa_app/presentation/components/profile/other_user_topic.dart';
import 'package:spa_app/presentation/components/profile/topic_follow_follower.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final int otherUserId;

  const OtherUserProfileScreen({Key? key, required this.otherUserId})
      : super(key: key);

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  StreamController<User> otherUserStreamController = BehaviorSubject();

  @override
  void initState() {
    super.initState();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getOtherUserProfile(
        otherUserId: widget.otherUserId.toString(),
        context: context,
        otherUserStreamController: otherUserStreamController);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Scaffold(
        appBar: topAppBar(
            title: AppLocalizations.of(context).userInfo,
            leadingWidget: IconButton(
              splashRadius: SizeConfig.defaultSize * 2.5,
              icon: Icon(CupertinoIcons.back,
                  color: const Color(0xFF8897A7),
                  size: SizeConfig.defaultSize * 2.7),
              onPressed: () {
                data.resetOtherUserLastTopicIndex();
                Navigator.pop(context);
              },
            ),
            widgetList: [
              data.mainScreenProvider.blockedUsersIdList
                      .contains(widget.otherUserId)
                  ? const SizedBox()
                  : Padding(
                      padding:
                          EdgeInsets.only(right: SizeConfig.defaultSize * 0.5),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            data.startChatWithOneUser(
                                otherUserId: widget.otherUserId.toString(),
                                context: context);
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/chat.svg',
                            color: const Color(0xFF8897A7),
                            height: SizeConfig.defaultSize * 2.5,
                            width: SizeConfig.defaultSize * 2.5,
                          ),
                          splashRadius: SizeConfig.defaultSize * 2.5,
                        ),
                      ),
                    ),
              data.mainScreenProvider.blockedUsersIdList
                      .contains(widget.otherUserId)
                  ? const SizedBox()
                  : Padding(
                      padding:
                          EdgeInsets.only(right: SizeConfig.defaultSize * 1.5),
                      child: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          position: PopupMenuPosition.under,
                          child: Icon(
                            Icons.more_vert,
                            color: const Color(0xFF8897A7),
                            size: SizeConfig.defaultSize * 2.5,
                          ),
                          onSelected: (value) {
                            if (value ==
                                AppLocalizations.of(context).blockAccount) {
                              data.blockUser(
                                  isOtherUserProfile: true,
                                  otherUserStreamController:
                                      otherUserStreamController,
                                  context: context,
                                  otherUserId: widget.otherUserId.toString());
                            }
                          },
                          itemBuilder: (context) {
                            return data
                                .getUserBlockOptionList(context: context)
                                .map((e) => PopupMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5,
                                          color: Colors.red),
                                    )))
                                .toList();
                          }),
                    ),
            ]),
        body: data.mainScreenProvider.blockedUsersIdList
                .contains(widget.otherUserId)
            ? Center(
                child: Text(
                  "User info not available",
                  style: TextStyle(
                    fontFamily: kHelveticaRegular,
                    fontSize: SizeConfig.defaultSize * 1.5,
                    color: Colors.black,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2),
                child: SingleChildScrollView(
                  child: StreamBuilder<User?>(
                      stream: otherUserStreamController.stream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 30),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).loading,
                                  style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          case ConnectionState.done:
                          default:
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .usersCouldNotLoad,
                                  style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  AppLocalizations.of(context).refreshPage,
                                  style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            } else {
                              final allCreatedPost =
                                  snapshot.data!.createdPost!;
                              return Column(
                                children: [
                                  SizedBox(height: SizeConfig.defaultSize * 2),
                                  OtherProfileTopContainer(
                                      otherUser: snapshot.data!,
                                      otherUserStreamController:
                                          otherUserStreamController),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 2.5,
                                  ),
                                  TopicFollowFollower(
                                      otherUserStreamController:
                                          otherUserStreamController,
                                      user: snapshot.data!,
                                      isOtherUser: true),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 2.5,
                                  ),

                                  // My Topic
                                  OtherUserTopic(
                                      otherUserStreamController:
                                          otherUserStreamController,
                                      otherUserId: widget.otherUserId,
                                      allCreatedPost: allCreatedPost),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 10,
                                  ),
                                ],
                              );
                            }
                        }
                      }),
                ),
              ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    otherUserStreamController.close();
  }
}
