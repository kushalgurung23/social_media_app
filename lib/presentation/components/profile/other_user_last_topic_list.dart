import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/profile_provider.dart';
import 'package:c_talent/presentation/views/last_bookmark_topic_description_screen.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class OtherUserLastTopicList extends StatelessWidget {
  final int otherUserId;
  final List<UserPost?>? allCreatedPost;
  StreamController<User>? otherUserStreamController;
  OtherUserLastTopicList(
      {Key? key,
      required this.allCreatedPost,
      required this.otherUserId,
      this.otherUserStreamController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return allCreatedPost == null
          ? const SizedBox()
          : ListView.builder(
              primary: false,
              shrinkWrap: true,
              // If length is greater than or equal to 6, make the list view item count: 6. Else make the item count's value the remaining items left in the list
              itemCount: allCreatedPost!.length -
                          (6 * (data.selectedOtherProfileTopicIndex)) >=
                      6
                  ? 6
                  : allCreatedPost!.length -
                      (6 * (data.selectedOtherProfileTopicIndex)),
              itemBuilder: (BuildContext context, int index) {
                final topicData = allCreatedPost!.reversed.toList()[
                    index + (6 * data.selectedOtherProfileTopicIndex)];
// blocked and deleted users won't be included
                final totalLikeCountList = topicData?.newsPostLikes!
                    .where(
                        (element) => element != null && element.likedBy != null)
                    .toList();
                // blocked and deleted users won't be included
                final totalCommentCountList = topicData?.comments!
                    .where((element) =>
                        element != null && element.commentBy != null)
                    .toList();
                return topicData == null
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LastBookmarkTopicDescriptionScreen(
                                          otherUserStreamController:
                                              otherUserStreamController,
                                          isOtherUser: true,
                                          otherUserId: otherUserId,
                                          topicId: topicData.id.toString(),
                                          newsCommentTextEditingController: data
                                              .profileTopicTextEditingController)));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: SizeConfig.defaultSize * 3,
                              left: SizeConfig.defaultSize * 2,
                              right: SizeConfig.defaultSize * 2),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0xFFD0E0F0), width: 1))),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize),
                                  child: Text(
                                    topicData.title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.4,
                                        color: const Color(0xFF000000)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize * 0.8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        SizeConfig.defaultSize),
                                                child: SvgPicture.asset(
                                                  "assets/svg/heart.svg",
                                                  color:
                                                      const Color(0xFFD1D3D5),
                                                  height:
                                                      SizeConfig.defaultSize *
                                                          1.3,
                                                  width:
                                                      SizeConfig.defaultSize *
                                                          1.3,
                                                ),
                                              ),
                                              Text(
                                                  '${totalLikeCountList != null ? totalLikeCountList.length : '0'} ${totalLikeCountList != null && totalLikeCountList.length > 1 ? AppLocalizations.of(context).likes : AppLocalizations.of(context).like}',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaRegular,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.3,
                                                      color: const Color(
                                                          0xFF8897A7))),
                                            ]),
                                      ),
                                      SizedBox(
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right:
                                                        SizeConfig.defaultSize),
                                                child: SvgPicture.asset(
                                                  "assets/svg/comment.svg",
                                                  color:
                                                      const Color(0xFFD1D3D5),
                                                  height:
                                                      SizeConfig.defaultSize *
                                                          1.3,
                                                  width:
                                                      SizeConfig.defaultSize *
                                                          1.3,
                                                ),
                                              ),
                                              Text(
                                                '${totalCommentCountList != null ? totalCommentCountList.length : '0'}'
                                                ' '
                                                '${totalCommentCountList != null && totalCommentCountList.length > 1 ? AppLocalizations.of(context).replies : AppLocalizations.of(context).reply.toLowerCase()}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaRegular,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.3,
                                                    color: const Color(
                                                        0xFF8897A7)),
                                              ),
                                            ]),
                                      ),
                                      Text(
                                          data.mainScreenProvider
                                              .convertDateTimeToAgo(
                                                  topicData.createdAt!,
                                                  context),
                                          style: TextStyle(
                                              fontFamily: kHelveticaRegular,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.3,
                                              color: const Color(0xFF8897A7)))
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      );
              },
            );
    });
  }
}
