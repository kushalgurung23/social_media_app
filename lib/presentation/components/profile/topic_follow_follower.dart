import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/profile/all_profile_topic_list.dart';
import 'package:spa_app/presentation/components/profile/other_user_follower_screen.dart';
import 'package:spa_app/presentation/components/profile/other_user_following_screen.dart';
import 'package:spa_app/presentation/components/profile/profile_follower_screen.dart';
import 'package:spa_app/presentation/components/profile/profile_following_screen.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class TopicFollowFollower extends StatelessWidget {
  StreamController<User>? otherUserStreamController;
  final User user;
  // If we are working on other user profile, it will be true
  final bool isOtherUser;
  TopicFollowFollower(
      {Key? key,
      required this.user,
      this.isOtherUser = false,
      this.otherUserStreamController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: SizedBox(
            height: SizeConfig.defaultSize * 15,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: SizeConfig.defaultSize * 12,
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
                    child: Padding(
                      padding: EdgeInsets.only(top: SizeConfig.defaultSize * 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllProfileTopicList(
                                            isOtherUser: isOtherUser,
                                            otherUserStreamController:
                                                isOtherUser == true
                                                    ? otherUserStreamController
                                                    : null,
                                            userId: isOtherUser == true
                                                ? user.id.toString()
                                                : data
                                                    .mainScreenProvider.userId!,
                                          )));
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    user.createdPost == null
                                        ? '0'
                                        : user.createdPost!.length.toString(),
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.8),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).topic,
                                    style: TextStyle(
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.6,
                                        color: const Color(0xFF8897A7)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              isOtherUser == true
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OtherUserFollowingScreen(
                                                otherUserStreamController:
                                                    isOtherUser == true
                                                        ? otherUserStreamController
                                                        : null,
                                                otherUserId: isOtherUser == true
                                                    ? user.id
                                                    : null,
                                              )))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfileFollowingScreen(
                                                  additionalProfile: false)));
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    user.userFollowing == null
                                        ? '0'
                                        : user.userFollowing!.length.toString(),
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.8),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).following,
                                    style: TextStyle(
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.6,
                                        color: const Color(0xFF8897A7)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              isOtherUser == true
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OtherUserFollowerScreen(
                                                  otherUserStreamController:
                                                      isOtherUser == true
                                                          ? otherUserStreamController
                                                          : null,
                                                  otherUserId:
                                                      isOtherUser == true
                                                          ? user.id
                                                          : null)))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ProfileFollowerScreen()));
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    user.userFollower == null
                                        ? '0'
                                        : user.userFollower!.length.toString(),
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.8),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize,
                                  ),
                                  Text(
                                    AppLocalizations.of(context).follower,
                                    style: TextStyle(
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.6,
                                        color: const Color(0xFF8897A7)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        height: SizeConfig.defaultSize * 6,
                        width: SizeConfig.defaultSize * 15.5,
                        decoration: BoxDecoration(
                            color: isOtherUser
                                ? const Color(0xFFE9FFEC)
                                : const Color(0xFFEFE9FF),
                            border: Border.all(
                              color: isOtherUser
                                  ? const Color(0xFFDFF3E9)
                                  : const Color(0xFFE5DFF3),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFFA08875).withOpacity(0.22),
                                  offset: const Offset(0, 0),
                                  blurRadius: 3)
                            ]),
                        child: Center(
                          child: Text(
                            isOtherUser
                                ? user.userType.toString()
                                : data.userTypeTextController.text,
                            style: TextStyle(
                                fontFamily: kHelveticaMedium,
                                fontSize: SizeConfig.defaultSize * 1.65,
                                color: isOtherUser
                                    ? const Color(0xFF4ACF45)
                                    : const Color(0xFFA08875)),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
      );
    });
  }
}
