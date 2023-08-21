import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/user_follow_enum.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/profile_provider.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/my_profile_screen.dart';
import 'package:c_talent/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileFollowerScreen extends StatefulWidget {
  // If we are trying to update other user profile, it will be true

  const ProfileFollowerScreen({Key? key}) : super(key: key);

  @override
  State<ProfileFollowerScreen> createState() => _ProfileFollowerScreenState();
}

class _ProfileFollowerScreenState extends State<ProfileFollowerScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
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
            title: AppLocalizations.of(context).follower,
          ),
          body: StreamBuilder<User>(
            stream: data.mainScreenProvider.currentUserController.stream,
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
                final followerList = snapshot.data!.userFollower;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 2),
                  child: followerList!.isEmpty
                      ? Center(
                          child: Text(
                          AppLocalizations.of(context).noFollower,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ))
                      : ListView.builder(
                          itemCount: followerList.length,
                          itemBuilder: (context, index) {
                            final userFollow = followerList[index]!;
                            final followerUser = userFollow.followedBy!;
                            final userFollowByCurrentUser =
                                snapshot.data!.userFollowing != null
                                    ? snapshot.data!.userFollowing!
                                        .firstWhereOrNull((element) =>
                                            element!.followedTo != null &&
                                            element.followedTo!.id ==
                                                followerUser.id)
                                    : null;
                            return data.mainScreenProvider.blockedUsersIdList
                                    .contains(followerUser.id)
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      // If different user is tapped
                                      if (followerUser.id.toString() !=
                                          data.mainScreenProvider.userId) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherUserProfileScreen(
                                                      otherUserId:
                                                          followerUser.id!,
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
                                              bottom:
                                                  SizeConfig.defaultSize * 2)
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
                                                followerUser.profileImage ==
                                                        null
                                                    ? Container(
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
                                                          image: const DecorationImage(
                                                              image: AssetImage(
                                                                  "assets/images/default_profile.jpg"),
                                                              fit:
                                                                  BoxFit.cover),
                                                        ))
                                                    : CachedNetworkImage(
                                                        imageUrl: kIMAGEURL +
                                                            followerUser
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
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    SizeConfig
                                                                            .defaultSize *
                                                                        1.5),
                                                            color: Colors.white,
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
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
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    SizeConfig
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
                                                      left: SizeConfig
                                                          .defaultSize),
                                                  child: Text(
                                                      followerUser.username
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
                                          followerUser.id ==
                                                  int.parse(data
                                                      .mainScreenProvider
                                                      .userId!)
                                              ? const SizedBox()
                                              : RectangularButton(
                                                  textPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: SizeConfig
                                                                  .defaultSize *
                                                              0.5),
                                                  height:
                                                      SizeConfig.defaultSize *
                                                          3.5,
                                                  width:
                                                      SizeConfig.defaultSize *
                                                          10,
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
                                                                  .contains(
                                                                      followerUser
                                                                          .id) &&
                                                              userFollowByCurrentUser !=
                                                                  null
                                                          ? userFollowByCurrentUser
                                                              .id
                                                              .toString()
                                                          : null,
                                                      otherUserDeviceToken:
                                                          followerUser
                                                              .deviceToken,
                                                      otherUserId:
                                                          followerUser.id!,
                                                      context: context,
                                                      setLikeSaveCommentFollow:
                                                          false,
                                                    );
                                                  },
                                                  text: data.mainScreenProvider
                                                          .followingIdList
                                                          .contains(
                                                              followerUser.id)
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
                                                                  followerUser
                                                                      .id) ==
                                                          true
                                                      ? Colors.white
                                                      : const Color(0xFFA08875),
                                                  buttonColor: data
                                                              .mainScreenProvider
                                                              .followingIdList
                                                              .contains(
                                                                  followerUser
                                                                      .id) ==
                                                          true
                                                      ? const Color(0xFFA08875)
                                                      : Colors.white,
                                                  borderColor: data
                                                              .mainScreenProvider
                                                              .followingIdList
                                                              .contains(
                                                                  followerUser
                                                                      .id) ==
                                                          true
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
                );
              }
            },
          ));
    });
  }
}
