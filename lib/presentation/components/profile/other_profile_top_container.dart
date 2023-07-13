import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/color_constant.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/user_follow_enum.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

// ignore: must_be_immutable
class OtherProfileTopContainer extends StatelessWidget {
  final User otherUser;
  StreamController<User> otherUserStreamController;

  OtherProfileTopContainer(
      {Key? key,
      required this.otherUser,
      required this.otherUserStreamController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: SizeConfig.defaultSize * 1.5),
            height: SizeConfig.defaultSize * 9,
            width: SizeConfig.defaultSize * 9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                image: otherUser.profileImage == null
                    ? const DecorationImage(
                        image: AssetImage("assets/images/default_profile.jpg"),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: NetworkImage(
                            kIMAGEURL + otherUser.profileImage!.url!),
                        fit: BoxFit.cover)),
          ),
          Expanded(
            child: SizedBox(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            otherUser.username.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: kHelveticaMedium,
                              fontSize: SizeConfig.defaultSize * 2,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.defaultSize * .5,
                          ),
                          Text(
                            "ID: ${otherUser.id}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.defaultSize * 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RectangularButton(
                      textPadding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize * 0.5),
                      height: SizeConfig.defaultSize * 3.5,
                      width: SizeConfig.defaultSize * 10,
                      onPress: () async {
                        final userFollowId = data
                                    .mainScreenProvider.followingIdList
                                    .contains(otherUser.id) &&
                                otherUser.userFollower != null
                            ? otherUser.userFollower!.firstWhereOrNull(
                                (element) =>
                                    element!.followedBy!.id.toString() ==
                                    data.mainScreenProvider.userId.toString())
                            : null;
                        await data.toggleUserFollow(
                          userFollowSource: UserFollowSource.otherUserScreen,
                          otherUserStreamController: otherUserStreamController,
                          userFollowId: userFollowId?.id.toString(),
                          otherUserDeviceToken: otherUser.deviceToken,
                          otherUserId: otherUser.id!,
                          context: context,
                          setLikeSaveCommentFollow: false,
                        );
                        // ignore: use_build_context_synchronously
                        data.getOtherUserProfile(
                            otherUserStreamController:
                                otherUserStreamController,
                            otherUserId: otherUser.id!.toString(),
                            context: context);
                      },
                      text: data.mainScreenProvider.followingIdList
                              .contains(otherUser.id)
                          ? AppLocalizations.of(context).followed
                          : AppLocalizations.of(context).follow,
                      textColor: data.mainScreenProvider.followingIdList
                              .contains(otherUser.id)
                          ? Colors.white
                          : const Color(0xFFA08875),
                      buttonColor: data.mainScreenProvider.followingIdList
                              .contains(otherUser.id)
                          ? const Color(0xFFA08875)
                          : Colors.white,
                      borderColor: const Color(0xFFA08875),
                      fontFamily: kHelveticaMedium,
                      keepBoxShadow: false,
                      borderRadius: SizeConfig.defaultSize * 1.8,
                      fontSize: SizeConfig.defaultSize * 1.1,
                    )
                  ],
                ),
              ],
            )),
          )
        ],
      );
    });
  }
}
