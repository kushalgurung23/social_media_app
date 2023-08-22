import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/profile_provider.dart';
import 'package:c_talent/presentation/components/profile/profile_following_screen.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowingContainer extends StatefulWidget {
  final String userId;

  const FollowingContainer({Key? key, required this.userId}) : super(key: key);

  @override
  State<FollowingContainer> createState() => _FollowingContainerState();
}

class _FollowingContainerState extends State<FollowingContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, data, child) {
        return StreamBuilder<User>(
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
              final followingList = snapshot.data!.userFollowing;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 1),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFA08875).withOpacity(0.22),
                          offset: const Offset(0, 1),
                          blurRadius: 3)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(SizeConfig.defaultSize * 2),
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
                      child: followingList == null || followingList.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.defaultSize * 2),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)
                                      .noAccountFollowed,
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: followingList.length >= 4
                                  ? 4
                                  : followingList.length,
                              itemBuilder: (context, index) {
                                final followingUser =
                                    followingList[index]!.followedTo!;
                                return GestureDetector(
                                  onTap: () {
                                    // If different user is tapped
                                    if (followingUser.id.toString() !=
                                        data.mainScreenProvider.currentUserId) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherUserProfileScreen(
                                                      otherUserId:
                                                          followingUser.id!)));
                                    }
                                  },
                                  child: Padding(
                                    padding: index == 0
                                        ? EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.defaultSize * 2)
                                        : EdgeInsets.only(
                                            right: SizeConfig.defaultSize * 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        followingUser.profileImage == null
                                            ? CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: const AssetImage(
                                                    "assets/images/default_profile.jpg"),
                                                radius: SizeConfig.defaultSize *
                                                    3.5)
                                            : CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                    kIMAGEURL +
                                                        followingUser
                                                            .profileImage!
                                                            .url!),
                                                radius: SizeConfig.defaultSize *
                                                    3.5),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: SizeConfig.defaultSize),
                                          child: Text(
                                            followingUser.username.toString(),
                                            style: TextStyle(
                                                fontFamily: kHelveticaMedium,
                                                fontSize:
                                                    SizeConfig.defaultSize *
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
                    followingList != null && followingList.length > 4
                        ? SizedBox(
                            height: SizeConfig.defaultSize * 11.5,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: followingList.length >= 8
                                    ? 4
                                    : followingList.length - 4,
                                itemBuilder: (context, index) {
                                  final followingUser =
                                      followingList[index + 4]!.followedTo!;
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.defaultSize * 2)
                                        : EdgeInsets.only(
                                            right: SizeConfig.defaultSize * 2),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        followingList.length > 8 && index == 3
                                            ?
                                            // For additional followings
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ProfileFollowingScreen(
                                                                  additionalProfile:
                                                                      true)));
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
                                                          '+${followingList.length - 7}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kHelveticaRegular,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.4),
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
                                                  if (followingUser.id
                                                          .toString() !=
                                                      data.mainScreenProvider
                                                          .currentUserId) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OtherUserProfileScreen(
                                                                    otherUserId:
                                                                        followingUser
                                                                            .id!)));
                                                  }
                                                },
                                                child: followingUser
                                                            .profileImage ==
                                                        null
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
                                                                    .profileImage!
                                                                    .url!),
                                                        radius: SizeConfig
                                                                .defaultSize *
                                                            3.5),
                                              ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: SizeConfig.defaultSize),
                                          child: followingList.length > 8 &&
                                                  index == 3
                                              ? Text(
                                                  AppLocalizations.of(context)
                                                      .following,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaMedium,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.1),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    // If different user is tapped
                                                    if (followingUser.id
                                                            .toString() !=
                                                        data.mainScreenProvider
                                                            .currentUserId) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OtherUserProfileScreen(
                                                                      otherUserId:
                                                                          followingUser
                                                                              .id!)));
                                                    }
                                                  },
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
          },
        );
      },
    );
  }
}
