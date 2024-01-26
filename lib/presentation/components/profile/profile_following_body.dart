// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:c_talent/data/models/all_followings.dart';
import 'package:c_talent/presentation/views/profile/following_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class ProfileFollowingBody extends StatelessWidget {
  final List<Follower> profileFollowings;
  final int? followingsCount;
  const ProfileFollowingBody({
    Key? key,
    required this.profileFollowings,
    this.followingsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: profileFollowings.length >= 4
                    ? 4
                    : profileFollowings.length,
                itemBuilder: (context, index) {
                  final followingUser = profileFollowings[index];
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
                              horizontal: SizeConfig.defaultSize * 2)
                          : EdgeInsets.only(right: SizeConfig.defaultSize * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          followingUser.profilePicture == null ||
                                  followingUser.profilePicture == ''
                              ? CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: const AssetImage(
                                      "assets/images/default_profile.jpg"),
                                  radius: SizeConfig.defaultSize * 3.5)
                              : CircleAvatar(
                                  backgroundColor: Colors.white,
                                  backgroundImage: NetworkImage(kIMAGEURL +
                                      followingUser.profilePicture.toString()),
                                  radius: SizeConfig.defaultSize * 3.5),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.defaultSize),
                            child: Text(
                              followingUser.username.toString(),
                              style: TextStyle(
                                  fontFamily: kHelveticaMedium,
                                  fontSize: SizeConfig.defaultSize * 1.1),
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
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: profileFollowings.length >= 8
                          ? 4
                          : profileFollowings.length - 4,
                      itemBuilder: (context, index) {
                        final followingUser = profileFollowings[index + 4];
                        return Padding(
                          padding: index == 0
                              ? EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize * 2)
                              : EdgeInsets.only(
                                  right: SizeConfig.defaultSize * 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              profileFollowings.length > 8 && index == 3
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(FollowingScreen.id);
                                      },
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                const Color(0xFFE6E6E6),
                                            radius:
                                                SizeConfig.defaultSize * 3.5,
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    const Color(0xFFF9F9F9),
                                                radius: SizeConfig.defaultSize *
                                                    3.35),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            right: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: Text(
                                                followingsCount == null
                                                    ? '+'
                                                    : '+${followingsCount! - 7}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaRegular,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
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
                                      child: followingUser.profilePicture ==
                                                  null ||
                                              followingUser.profilePicture == ''
                                          ? CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: const AssetImage(
                                                  "assets/images/default_profile.jpg"),
                                              radius:
                                                  SizeConfig.defaultSize * 3.5)
                                          : CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: NetworkImage(
                                                  kIMAGEURL +
                                                      followingUser
                                                          .profilePicture
                                                          .toString()),
                                              radius:
                                                  SizeConfig.defaultSize * 3.5),
                                    ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.defaultSize),
                                child: profileFollowings.length > 8 &&
                                        index == 3
                                    ? Text(
                                        AppLocalizations.of(context).following,
                                        style: TextStyle(
                                            fontFamily: kHelveticaMedium,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.1),
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
                                          followingUser.username.toString(),
                                          style: TextStyle(
                                              fontFamily: kHelveticaMedium,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.1),
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
