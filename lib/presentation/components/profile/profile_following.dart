import 'package:c_talent/data/models/all_followings.dart';
import 'package:c_talent/logic/providers/profile_follow_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../../logic/providers/profile_news_provider.dart';
import '../../helper/size_configuration.dart';

class ProfileFollowing extends StatefulWidget {
  const ProfileFollowing({Key? key}) : super(key: key);

  @override
  State<ProfileFollowing> createState() => _ProfileFollowingState();
}

class _ProfileFollowingState extends State<ProfileFollowing> {
  @override
  void initState() {
    Provider.of<ProfileFollowProvider>(context, listen: false)
        .loadInitialProfileFollowings(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileFollowProvider>(
      builder: (context, data, child) {
        return StreamBuilder<AllFollowings?>(
            stream: data.profileFollowingsStreamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text(AppLocalizations.of(context).loading,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  );
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                          AppLocalizations.of(context)
                              .promotionCouldNotBeLoaded,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else {
                    final profileFollowings = snapshot.data?.followings;

                    return profileFollowings == null ||
                            profileFollowings.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 3),
                              child: Text(
                                data.isLoadingFollowings == true ||
                                        data.isLoadingFollowings == true
                                    ? AppLocalizations.of(context).loading
                                    : AppLocalizations.of(context)
                                        .noUserFollowedYet,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: const Color(0xFFA08875)
                                          .withOpacity(0.22),
                                      offset: const Offset(0, 1),
                                      blurRadius: 3)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      SizeConfig.defaultSize * 2),
                                  child: Text(
                                    AppLocalizations.of(context).following,
                                    style: TextStyle(
                                        color: const Color(0xFFA08875),
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 2),
                                  ),
                                ),
                                // first row
                                SizedBox(
                                  height: SizeConfig.defaultSize * 11.5,
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: profileFollowings.length >= 4
                                          ? 4
                                          : profileFollowings.length,
                                      itemBuilder: (context, index) {
                                        final followingUser =
                                            profileFollowings[index];
                                        return GestureDetector(
                                          onTap: () {
                                            // // If different user is tapped
                                            // if (followingUser.id.toString() !=
                                            //     data.mainScreenProvider.userId) {
                                            //   Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               OtherUserProfileScreen(
                                            //                   otherUserId:
                                            //                       followingUser.id!)));
                                            // }
                                          },
                                          child: Padding(
                                            padding: index == 0
                                                ? EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.defaultSize *
                                                            2)
                                                : EdgeInsets.only(
                                                    right:
                                                        SizeConfig.defaultSize *
                                                            2),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                followingUser.profilePicture ==
                                                            null ||
                                                        followingUser
                                                                .profilePicture ==
                                                            ''
                                                    ? CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            const AssetImage(
                                                                "assets/images/default_profile.jpg"),
                                                        radius: SizeConfig
                                                                .defaultSize *
                                                            3.5)
                                                    : CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage:
                                                            NetworkImage(kIMAGEURL +
                                                                followingUser
                                                                    .profilePicture
                                                                    .toString()),
                                                        radius: SizeConfig
                                                                .defaultSize *
                                                            3.5),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: SizeConfig
                                                          .defaultSize),
                                                  child: Text(
                                                    followingUser.username
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            kHelveticaMedium,
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            1.1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                // 2nd row
                                profileFollowings.length > 4
                                    ? SizedBox(
                                        height: SizeConfig.defaultSize * 11.5,
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount:
                                                profileFollowings.length >= 8
                                                    ? 4
                                                    : profileFollowings.length -
                                                        4,
                                            itemBuilder: (context, index) {
                                              final followingUser =
                                                  profileFollowings[index + 4];
                                              return Padding(
                                                padding: index == 0
                                                    ? EdgeInsets.symmetric(
                                                        horizontal: SizeConfig
                                                                .defaultSize *
                                                            2)
                                                    : EdgeInsets.only(
                                                        right: SizeConfig
                                                                .defaultSize *
                                                            2),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    profileFollowings.length >
                                                                8 &&
                                                            index == 3
                                                        ?
                                                        // For additional followings
                                                        GestureDetector(
                                                            onTap: () {
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) =>
                                                              //             const ProfileFollowingScreen(
                                                              //                 additionalProfile:
                                                              //                     true)));
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xFFE6E6E6),
                                                                  radius: SizeConfig
                                                                          .defaultSize *
                                                                      3.5,
                                                                  child: CircleAvatar(
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xFFF9F9F9),
                                                                      radius: SizeConfig
                                                                              .defaultSize *
                                                                          3.35),
                                                                ),
                                                                Positioned(
                                                                  left: 0,
                                                                  top: 0,
                                                                  right: 0,
                                                                  bottom: 0,
                                                                  child: Center(
                                                                    child: Text(
                                                                      snapshot.data?.count ==
                                                                              null
                                                                          ? '+'
                                                                          : '+${snapshot.data!.count! - 7}',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              kHelveticaRegular,
                                                                          fontSize:
                                                                              SizeConfig.defaultSize * 1.4),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        // For following profiles
                                                        : GestureDetector(
                                                            onTap: () {
                                                              // If different user is tapped
                                                              // if (followingUser.id
                                                              //         .toString() !=
                                                              //     data.mainScreenProvider
                                                              //         .userId) {
                                                              //   Navigator.push(
                                                              //       context,
                                                              //       MaterialPageRoute(
                                                              //           builder: (context) =>
                                                              //               OtherUserProfileScreen(
                                                              //                   otherUserId:
                                                              //                       followingUser
                                                              //                           .id!)));
                                                              // }
                                                            },
                                                            child: followingUser
                                                                            .profilePicture ==
                                                                        null ||
                                                                    followingUser
                                                                            .profilePicture ==
                                                                        ''
                                                                ? CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundImage:
                                                                        const AssetImage(
                                                                            "assets/images/default_profile.jpg"),
                                                                    radius:
                                                                        SizeConfig.defaultSize *
                                                                            3.5)
                                                                : CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundImage:
                                                                        NetworkImage(kIMAGEURL +
                                                                            followingUser.profilePicture
                                                                                .toString()),
                                                                    radius: SizeConfig
                                                                            .defaultSize *
                                                                        3.5),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: SizeConfig
                                                                  .defaultSize),
                                                      child: profileFollowings
                                                                      .length >
                                                                  8 &&
                                                              index == 3
                                                          ? Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .following,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      kHelveticaMedium,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .defaultSize *
                                                                          1.1),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                // If different user is tapped
                                                                // if (followingUser.id
                                                                //         .toString() !=
                                                                //     data.mainScreenProvider
                                                                //         .userId) {
                                                                //   Navigator.push(
                                                                //       context,
                                                                //       MaterialPageRoute(
                                                                //           builder: (context) =>
                                                                //               OtherUserProfileScreen(
                                                                //                   otherUserId:
                                                                //                       followingUser
                                                                //                           .id!)));
                                                                // }
                                                              },
                                                              child: Text(
                                                                followingUser
                                                                    .username
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        kHelveticaMedium,
                                                                    fontSize:
                                                                        SizeConfig.defaultSize *
                                                                            1.1),
                                                              ),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          );
                  }
              }
            });
      },
    );
  }
}
