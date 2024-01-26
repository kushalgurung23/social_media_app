import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/color_constant.dart';
import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../../data/models/all_followers.dart';
import '../../components/all/rectangular_button.dart';
import '../../helper/size_configuration.dart';

class FollowerContainer extends StatelessWidget {
  final Follower followerUser;
  final int index;
  final bool isMe;

  const FollowerContainer(
      {super.key,
      required this.followerUser,
      required this.index,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        color: Colors.transparent,
        margin: index == 0
            ? EdgeInsets.only(
                top: SizeConfig.defaultSize * 2,
                bottom: SizeConfig.defaultSize * 2)
            : EdgeInsets.only(bottom: SizeConfig.defaultSize * 1.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Row(
                children: [
                  followerUser.profilePicture == null ||
                          followerUser.profilePicture == ''
                      ? Container(
                          height: SizeConfig.defaultSize * 4.7,
                          width: SizeConfig.defaultSize * 4.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.defaultSize * 1.5),
                            color: Colors.white,
                            image: const DecorationImage(
                                image: AssetImage(
                                    "assets/images/default_profile.jpg"),
                                fit: BoxFit.cover),
                          ))
                      : CachedNetworkImage(
                          imageUrl: kIMAGEURL +
                              followerUser.profilePicture.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: SizeConfig.defaultSize * 4.7,
                            width: SizeConfig.defaultSize * 4.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.defaultSize * 1.5),
                              color: Colors.white,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            height: SizeConfig.defaultSize * 4.7,
                            width: SizeConfig.defaultSize * 4.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.defaultSize * 1.5),
                              color: const Color(0xFFD0E0F0),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.defaultSize),
                    child: Text(followerUser.username.toString(),
                        style: TextStyle(
                            fontFamily: kHelveticaMedium,
                            fontSize: SizeConfig.defaultSize * 1.4)),
                  )
                ],
              ),
            ),
            //  button
            isMe
                ? const SizedBox()
                : RectangularButton(
                    textPadding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize * 0.5),
                    height: SizeConfig.defaultSize * 3.5,
                    width: SizeConfig.defaultSize * 10,
                    onPress: () async {},
                    text: followerUser.isFollowed == 1
                        ? AppLocalizations.of(context).followed
                        : AppLocalizations.of(context).follow,
                    textColor: followerUser.isFollowed == 1
                        ? Colors.white
                        : const Color(0xFFA08875),
                    buttonColor: followerUser.isFollowed == 1
                        ? const Color(0xFFA08875)
                        : Colors.white,
                    borderColor: kPrimaryColor,
                    fontFamily: kHelveticaMedium,
                    keepBoxShadow: false,
                    borderRadius: SizeConfig.defaultSize * 1.8,
                    fontSize: SizeConfig.defaultSize * 1.1,
                  )
          ],
        ),
      ),
    );
  }
}
