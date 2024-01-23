import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikedAvatars extends StatelessWidget {
  final bool isLike;
  final NewsPost newsPost;

  const LikedAvatars({super.key, required this.isLike, required this.newsPost});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenProvider>(builder: (context, data, child) {
      final String? loggedInUserId = data.loginSuccess.user?.id.toString();
      List<Like?>? likes = newsPost.likes?.reversed.toList();
      if (likes == null || likes.isEmpty) {
        return const SizedBox();
        // If it's liked only by the current user
      } else if (likes.length == 1) {
        String? profilePicture = likes[0]?.likedBy?.profilePicture;
        return profilePicture == null
            ? CircleAvatar(
                backgroundImage:
                    const AssetImage("assets/images/default_profile.jpg"),
                radius: SizeConfig.defaultSize * 1.5)
            : CircleAvatar(
                backgroundImage: NetworkImage(kIMAGEURL + profilePicture),
                radius: SizeConfig.defaultSize * 1.5);
      }
      // IF POST IS LIKED BY 2 USERS
      else if (likes.length == 2) {
        String? firstProfilePicture;
        String? secondProfilePicture;
        // IF CURRENT USER HAS LIKED POST, SHOW THIER PICTURE AT THE LAST
        if (isLike) {
          if (likes[0]?.likedBy?.id.toString() == loggedInUserId) {
            firstProfilePicture = likes[1]?.likedBy?.profilePicture;
            secondProfilePicture = likes[0]?.likedBy?.profilePicture;
          } else {
            firstProfilePicture = likes[0]?.likedBy?.profilePicture;
            secondProfilePicture = likes[1]?.likedBy?.profilePicture;
          }
        } else {
          firstProfilePicture = likes[0]?.likedBy?.profilePicture;
          secondProfilePicture = likes[1]?.likedBy?.profilePicture;
        }
        return Stack(
          children: [
            // First avatar
            firstProfilePicture == null
                ? CircleAvatar(
                    backgroundImage:
                        const AssetImage("assets/images/default_profile.jpg"),
                    radius: SizeConfig.defaultSize * 1.5)
                : CircleAvatar(
                    backgroundImage:
                        NetworkImage(kIMAGEURL + firstProfilePicture),
                    radius: SizeConfig.defaultSize * 1.5),

            // Second avatar
            Padding(
                padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
                child: secondProfilePicture == null
                    ? CircleAvatar(
                        backgroundImage: const AssetImage(
                            "assets/images/default_profile.jpg"),
                        radius: SizeConfig.defaultSize * 1.5)
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(kIMAGEURL + secondProfilePicture),
                        radius: SizeConfig.defaultSize * 1.5)),
          ],
        );
      }
      // If like count is == 3
      else if (likes.length == 3) {
        String? firstProfilePicture;
        String? secondProfilePicture;
        String? thirdProfilePicture;

        if (isLike) {
          if (likes[0]?.likedBy?.id.toString() == loggedInUserId) {
            firstProfilePicture = likes[1]?.likedBy?.profilePicture;
            secondProfilePicture = likes[2]?.likedBy?.profilePicture;
            thirdProfilePicture = likes[0]?.likedBy?.profilePicture;
          } else if (likes[1]?.likedBy?.id.toString() == loggedInUserId) {
            firstProfilePicture = likes[0]?.likedBy?.profilePicture;
            secondProfilePicture = likes[2]?.likedBy?.profilePicture;
            thirdProfilePicture = likes[1]?.likedBy?.profilePicture;
          } else {
            firstProfilePicture = likes[0]?.likedBy?.profilePicture;
            secondProfilePicture = likes[1]?.likedBy?.profilePicture;
            thirdProfilePicture = likes[2]?.likedBy?.profilePicture;
          }
        } else {
          firstProfilePicture = likes[0]?.likedBy?.profilePicture;
          secondProfilePicture = likes[1]?.likedBy?.profilePicture;
          thirdProfilePicture = likes[2]?.likedBy?.profilePicture;
        }
        return Stack(
          children: [
            // First avatar
            firstProfilePicture == null
                ? CircleAvatar(
                    backgroundImage:
                        const AssetImage("assets/images/default_profile.jpg"),
                    radius: SizeConfig.defaultSize * 1.5)
                : CircleAvatar(
                    backgroundImage:
                        NetworkImage(kIMAGEURL + firstProfilePicture),
                    radius: SizeConfig.defaultSize * 1.5),

            // Second avatar
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
              child: secondProfilePicture == null
                  ? CircleAvatar(
                      backgroundImage:
                          const AssetImage("assets/images/default_profile.jpg"),
                      radius: SizeConfig.defaultSize * 1.5)
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(kIMAGEURL + secondProfilePicture),
                      radius: SizeConfig.defaultSize * 1.5),
            ),
            // Third avatar
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
              child: thirdProfilePicture == null || thirdProfilePicture == ''
                  ? CircleAvatar(
                      backgroundImage:
                          const AssetImage("assets/images/default_profile.jpg"),
                      radius: SizeConfig.defaultSize * 1.5)
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(kIMAGEURL + thirdProfilePicture),
                      radius: SizeConfig.defaultSize * 1.5),
            ),
          ],
        );
      }
      // WHEN NEWS POST IS LOADED, ONLY 4 lIKES WILL BE LOADED TO DISPLAY LIKERS' PROFILE PICTURE.
      // THEREFORE, WHENEVER CURRENT USER LIKES THE POST, THERE CAN ONLY BE UPTO 5 LIKES IN THE LIST,
      // OR EVEN 4, IF CURRENT USER HAS ALREADY LIKED THE POST.
      // THEREFORE IF LIKES COUNT IS 4, THEN FOLLOWING CONDITION WILL RUN
      else {
        String? firstProfilePicture;
        String? secondProfilePicture;
        String? thirdProfilePicture;

        if (likes.length == 4) {
          if (isLike == true) {
            // We will start from 1 index instead of 0, because item in 0 index is the oldest after reversing the list at the top.
            if (likes[1]?.likedBy?.id.toString() == loggedInUserId) {
              firstProfilePicture = likes[2]?.likedBy?.profilePicture;
              secondProfilePicture = likes[3]?.likedBy?.profilePicture;
              thirdProfilePicture = likes[1]?.likedBy?.profilePicture;
            } else if (likes[2]?.likedBy?.id.toString() == loggedInUserId) {
              firstProfilePicture = likes[1]?.likedBy?.profilePicture;
              secondProfilePicture = likes[3]?.likedBy?.profilePicture;
              thirdProfilePicture = likes[2]?.likedBy?.profilePicture;
            } else {
              firstProfilePicture = likes[1]?.likedBy?.profilePicture;
              secondProfilePicture = likes[2]?.likedBy?.profilePicture;
              thirdProfilePicture = likes[3]?.likedBy?.profilePicture;
            }
          } else {
            firstProfilePicture = likes[1]?.likedBy?.profilePicture;
            secondProfilePicture = likes[2]?.likedBy?.profilePicture;
            thirdProfilePicture = likes[3]?.likedBy?.profilePicture;
          }
        }
        // ELSE IF LENGTH WILL BE 5
        else {
          if (isLike == true) {
            // We will start from 2 index instead of 0, because item in 0 index is the oldest after reversing the list at the top.
            if (likes[2]?.likedBy?.id.toString() == loggedInUserId) {
              firstProfilePicture = likes[3]?.likedBy?.profilePicture;
              secondProfilePicture = likes[4]?.likedBy?.profilePicture;
              thirdProfilePicture = likes[2]?.likedBy?.profilePicture;
            } else if (likes[3]?.likedBy?.id.toString() == loggedInUserId) {
              firstProfilePicture = likes[2]?.likedBy?.profilePicture;
              secondProfilePicture = likes[4]?.likedBy?.profilePicture;
              thirdProfilePicture = likes[3]?.likedBy?.profilePicture;
            } else {
              firstProfilePicture = likes[2]?.likedBy?.profilePicture;
              secondProfilePicture = likes[3]?.likedBy?.profilePicture;
              thirdProfilePicture = likes[4]?.likedBy?.profilePicture;
            }
          } else {
            firstProfilePicture = likes[2]?.likedBy?.profilePicture;
            secondProfilePicture = likes[3]?.likedBy?.profilePicture;
            thirdProfilePicture = likes[4]?.likedBy?.profilePicture;
          }
        }
        return Stack(
          children: [
            // First avatar
            firstProfilePicture == null
                ? CircleAvatar(
                    backgroundImage:
                        const AssetImage("assets/images/default_profile.jpg"),
                    radius: SizeConfig.defaultSize * 1.5)
                : CircleAvatar(
                    backgroundImage:
                        NetworkImage(kIMAGEURL + firstProfilePicture),
                    radius: SizeConfig.defaultSize * 1.5),

            // Second avatar
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.defaultSize * 1.3),
              child: secondProfilePicture == null
                  ? CircleAvatar(
                      backgroundImage:
                          const AssetImage("assets/images/default_profile.jpg"),
                      radius: SizeConfig.defaultSize * 1.5)
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(kIMAGEURL + secondProfilePicture),
                      radius: SizeConfig.defaultSize * 1.5),
            ),
            // Third avatar
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.defaultSize * 2.6),
              child: thirdProfilePicture == null
                  ? CircleAvatar(
                      backgroundImage:
                          const AssetImage("assets/images/default_profile.jpg"),
                      radius: SizeConfig.defaultSize * 1.5)
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(kIMAGEURL + thirdProfilePicture),
                      radius: SizeConfig.defaultSize * 1.5),
            ),
          ],
        );
      }
    });
  }
}
