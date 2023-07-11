import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/user_follow_enum.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class OtherUserFollowingScreen extends StatefulWidget {
  final int? otherUserId;
  StreamController<User>? otherUserStreamController;

  OtherUserFollowingScreen(
      {Key? key, this.otherUserId, this.otherUserStreamController})
      : super(key: key);

  @override
  State<OtherUserFollowingScreen> createState() =>
      _OtherUserFollowingScreenState();
}

class _OtherUserFollowingScreenState extends State<OtherUserFollowingScreen> {
// provide key
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return StreamBuilder<User>(
        stream: widget.otherUserStreamController!.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                AppLocalizations.of(context).loading,
                style: TextStyle(
                    fontFamily: kHelveticaRegular,
                    fontSize: SizeConfig.defaultSize * 1.5),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context).refreshPage,
                style: TextStyle(
                    fontFamily: kHelveticaRegular,
                    fontSize: SizeConfig.defaultSize * 1.5),
              ),
            );
          } else {
            final followingList = snapshot.data!.userFollowing;
            return Scaffold(
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
                title: AppLocalizations.of(context).following,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2),
                child: followingList!.isEmpty
                    ? Center(
                        child: Text(
                        AppLocalizations.of(context).noUserFollowedYet,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ))
                    : ListView.builder(
                        // If more profile icon is clicked, only show additional profiles
                        itemCount: followingList.length,
                        itemBuilder: (context, index) {
                          final followingUser =
                              followingList[index]!.followedTo!;
                          final checkUserFollow = data
                                  .mainScreenProvider.followingIdList
                                  .contains(followingUser.id)
                              ? data.mainScreenProvider.currentUser!
                                          .userFollowing !=
                                      null
                                  ? data.mainScreenProvider.currentUser!
                                      .userFollowing!
                                      .firstWhereOrNull((element) =>
                                          element!.followedTo != null &&
                                          element.followedTo!.id.toString() ==
                                              followingUser.id.toString())
                                  : null
                              : null;
                          return data.mainScreenProvider.blockedUsersIdList
                                  .contains(followingUser.id)
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () async {
                                    // If different user is tapped
                                    if (followingUser.id.toString() !=
                                        data.mainScreenProvider.userId) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherUserProfileScreen(
                                                    otherUserId:
                                                        followingUser.id!,
                                                  )));
                                    } else {
                                      Navigator.pushNamed(
                                          context, MyProfileScreen.id);
                                    }
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    margin: index == 0
                                        ? EdgeInsets.only(
                                            top: SizeConfig.defaultSize * 2,
                                            bottom: SizeConfig.defaultSize * 2)
                                        : EdgeInsets.only(
                                            bottom:
                                                SizeConfig.defaultSize * 1.5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              followingUser.profileImage == null
                                                  ? Container(
                                                      height: SizeConfig
                                                              .defaultSize *
                                                          4.7,
                                                      width: SizeConfig
                                                              .defaultSize *
                                                          4.7,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(SizeConfig
                                                                    .defaultSize *
                                                                1.5),
                                                        color: Colors.white,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/default_profile.jpg"),
                                                            fit: BoxFit.cover),
                                                      ))
                                                  : CachedNetworkImage(
                                                      imageUrl: kIMAGEURL +
                                                          followingUser
                                                              .profileImage!
                                                              .url!,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(SizeConfig
                                                                      .defaultSize *
                                                                  1.5),
                                                          color: Colors.white,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(SizeConfig
                                                                      .defaultSize *
                                                                  1.5),
                                                          color: const Color(
                                                              0xFFD0E0F0),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.defaultSize),
                                                child: Text(
                                                    followingUser.username
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            kHelveticaMedium,
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            1.4)),
                                              )
                                            ],
                                          ),
                                        ),
                                        //  button
                                        followingUser.id ==
                                                int.parse(data
                                                    .mainScreenProvider.userId!)
                                            ? const SizedBox()
                                            : RectangularButton(
                                                textPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: SizeConfig
                                                                .defaultSize *
                                                            0.5),
                                                height: SizeConfig.defaultSize *
                                                    3.5,
                                                width:
                                                    SizeConfig.defaultSize * 10,
                                                onPress: () async {
                                                  await data.toggleUserFollow(
                                                    userFollowSource:
                                                        UserFollowSource
                                                            .currentUserScreen,
                                                    otherUserStreamController:
                                                        null,
                                                    userFollowId: data
                                                                .mainScreenProvider
                                                                .followingIdList
                                                                .contains(widget
                                                                    .otherUserId) &&
                                                            checkUserFollow !=
                                                                null
                                                        ? checkUserFollow.id
                                                            .toString()
                                                        : null,
                                                    otherUserDeviceToken:
                                                        followingUser
                                                            .deviceToken,
                                                    otherUserId:
                                                        followingUser.id!,
                                                    context: context,
                                                    setLikeSaveCommentFollow:
                                                        false,
                                                  );
                                                  data.getOtherUserProfile(
                                                      otherUserStreamController:
                                                          widget
                                                              .otherUserStreamController!,
                                                      otherUserId: widget
                                                          .otherUserId
                                                          .toString(),
                                                      context: context);
                                                },
                                                text: data.mainScreenProvider
                                                        .followingIdList
                                                        .contains(
                                                            followingUser.id)
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .followed
                                                    : AppLocalizations.of(
                                                            context)
                                                        .follow,
                                                textColor: data
                                                        .mainScreenProvider
                                                        .followingIdList
                                                        .contains(
                                                            followingUser.id)
                                                    ? Colors.white
                                                    : const Color(0xFFA08875),
                                                buttonColor: data
                                                        .mainScreenProvider
                                                        .followingIdList
                                                        .contains(
                                                            followingUser.id)
                                                    ? const Color(0xFFA08875)
                                                    : Colors.white,
                                                borderColor: data
                                                        .mainScreenProvider
                                                        .followingIdList
                                                        .contains(
                                                            followingUser.id)
                                                    ? const Color(0xFFA08875)
                                                    : const Color(0xFF5349C7),
                                                fontFamily: kHelveticaMedium,
                                                keepBoxShadow: false,
                                                borderRadius:
                                                    SizeConfig.defaultSize *
                                                        1.8,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.1,
                                              )
                                      ],
                                    ),
                                  ),
                                );
                        }),
              ),
            );
          }
        },
      );
    });
  }
}
