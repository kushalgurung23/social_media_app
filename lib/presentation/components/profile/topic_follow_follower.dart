import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../data/constant/font_constant.dart';
import '../../../logic/providers/profile_provider.dart';
import '../../helper/size_configuration.dart';

// ignore: must_be_immutable
class TopicFollowFollower extends StatelessWidget {
  // If we are working on other user profile, it will be true
  final bool isOtherUser;
  const TopicFollowFollower({Key? key, this.isOtherUser = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      final user = data.mainScreenProvider.loginSuccess.user;
      return user == null
          ? const SizedBox()
          : Padding(
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
                                    color: const Color(0xFFA08875)
                                        .withOpacity(0.22),
                                    offset: const Offset(0, 1),
                                    blurRadius: 3)
                              ]),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.defaultSize * 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => AllProfileTopicList(
                                    //               isOtherUser: isOtherUser,
                                    //               otherUserStreamController:
                                    //                   isOtherUser == true
                                    //                       ? otherUserStreamController
                                    //                       : null,
                                    //               userId: isOtherUser == true
                                    //                   ? user.id.toString()
                                    //                   : data
                                    //                       .mainScreenProvider.userId!,
                                    //             )));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.createdPostsCount == null ||
                                                  user.createdPostsCount
                                                          .toString() ==
                                                      ''
                                              ? '0'
                                              : user.createdPostsCount
                                                  .toString(),
                                          style: TextStyle(
                                              fontFamily: kHelveticaMedium,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.8),
                                        ),
                                        SizedBox(
                                          height: SizeConfig.defaultSize,
                                        ),
                                        Text(
                                          AppLocalizations.of(context).topic,
                                          style: TextStyle(
                                              fontFamily: kHelveticaRegular,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.6,
                                              color: const Color(0xFF8897A7)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // isOtherUser == true
                                    //     ? Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 OtherUserFollowingScreen(
                                    //                   otherUserStreamController:
                                    //                       isOtherUser == true
                                    //                           ? otherUserStreamController
                                    //                           : null,
                                    //                   otherUserId: isOtherUser == true
                                    //                       ? user.id
                                    //                       : null,
                                    //                 )))
                                    //     : Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 const ProfileFollowingScreen(
                                    //                     additionalProfile: false)));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.followingCount == null ||
                                                  user.followingCount
                                                          .toString() ==
                                                      ''
                                              ? '0'
                                              : user.followingCount.toString(),
                                          style: TextStyle(
                                              fontFamily: kHelveticaMedium,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.8),
                                        ),
                                        SizedBox(
                                          height: SizeConfig.defaultSize,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)
                                              .following,
                                          style: TextStyle(
                                              fontFamily: kHelveticaRegular,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.6,
                                              color: const Color(0xFF8897A7)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // isOtherUser == true
                                    //     ? Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 OtherUserFollowerScreen(
                                    //                     otherUserStreamController:
                                    //                         isOtherUser == true
                                    //                             ? otherUserStreamController
                                    //                             : null,
                                    //                     otherUserId:
                                    //                         isOtherUser == true
                                    //                             ? user.id
                                    //                             : null)))
                                    //     : Navigator.push(
                                    //         context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) =>
                                    //                 const ProfileFollowerScreen()));
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.followerCount == null ||
                                                  user.followerCount
                                                          .toString() ==
                                                      ''
                                              ? '0'
                                              : user.followerCount.toString(),
                                          style: TextStyle(
                                              fontFamily: kHelveticaMedium,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.8),
                                        ),
                                        SizedBox(
                                          height: SizeConfig.defaultSize,
                                        ),
                                        Text(
                                          AppLocalizations.of(context).follower,
                                          style: TextStyle(
                                              fontFamily: kHelveticaRegular,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.6,
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
                                        color: const Color(0xFFA08875)
                                            .withOpacity(0.22),
                                        offset: const Offset(0, 0),
                                        blurRadius: 3)
                                  ]),
                              child: Center(
                                child: Text(
                                  user.userType.toString(),
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
