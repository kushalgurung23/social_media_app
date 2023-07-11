import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/presentation/views/last_bookmark_topic_description_screen.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarkedTopic extends StatelessWidget {
  final List<UserPostSaveLike?>? bookMarkedTopic;
  final GlobalKey<FormState> bookmarkedTopicKey = GlobalKey<FormState>();

  BookmarkedTopic({Key? key, required this.bookMarkedTopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Container(
        key: bookmarkedTopicKey,
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
                AppLocalizations.of(context).bookmarkedTopic,
                style: TextStyle(
                    color: const Color(0xFFA08875),
                    fontFamily: kHelveticaMedium,
                    fontSize: SizeConfig.defaultSize * 2),
              ),
            ),
            bookMarkedTopic == null ||
                    (bookMarkedTopic != null && bookMarkedTopic!.isEmpty)
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.defaultSize * 5,
                          bottom: SizeConfig.defaultSize * 7),
                      child: Text(
                        AppLocalizations.of(context).noBookmarkTopicFound,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,

                    // If length is greater than or equal to 6, make the list view item count: 6. Else make the item count's value the remaining items left in the list
                    itemCount: bookMarkedTopic!.length -
                                (6 * (data.selectedBookmarkedTopicIndex)) >=
                            6
                        ? 6
                        : bookMarkedTopic!.length -
                            (6 * (data.selectedBookmarkedTopicIndex)),
                    itemBuilder: (BuildContext context, int index) {
                      bookMarkedTopic!.sort(
                          (a, b) => a!.createdAt!.compareTo(b!.createdAt!));
                      final reversedList = bookMarkedTopic!.reversed.toList();
                      final bookmarkData = reversedList[
                          index + (6 * data.selectedBookmarkedTopicIndex)]!;
                      final topicData = reversedList[
                              index + (6 * data.selectedBookmarkedTopicIndex)]!
                          .newsPost;
// blocked and deleted users won't be included
                      final totalLikeCountList = topicData?.newsPostLikes!
                          .where((element) =>
                              element != null && element.likedBy != null)
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
                                                topicId:
                                                    topicData.id.toString(),
                                                newsCommentTextEditingController:
                                                    data.profileTopicTextEditingController)));
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
                                            color: Color(0xFFD0E0F0),
                                            width: 1))),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.4,
                                              color: const Color(0xFF000000)),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                SizeConfig.defaultSize * 0.8),
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
                                                          right: SizeConfig
                                                              .defaultSize),
                                                      child: SvgPicture.asset(
                                                        "assets/svg/heart.svg",
                                                        color: const Color(
                                                            0xFFD1D3D5),
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            1.3,
                                                        width: SizeConfig
                                                                .defaultSize *
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
                                                          right: SizeConfig
                                                              .defaultSize),
                                                      child: SvgPicture.asset(
                                                        "assets/svg/comment.svg",
                                                        color: const Color(
                                                            0xFFD1D3D5),
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            1.3,
                                                        width: SizeConfig
                                                                .defaultSize *
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
                                                          fontSize: SizeConfig
                                                                  .defaultSize *
                                                              1.3,
                                                          color: const Color(
                                                              0xFF8897A7)),
                                                    ),
                                                  ]),
                                            ),
                                            Text(
                                                data.mainScreenProvider
                                                    .convertDateTimeToAgo(
                                                        bookmarkData.createdAt!,
                                                        context),
                                                style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaRegular,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.3,
                                                    color: const Color(
                                                        0xFF8897A7)))
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            );
                    },
                  ),
            // Only show bottom left, right button if listview has length equal or greater than 6
            bookMarkedTopic == null ||
                    (bookMarkedTopic != null && bookMarkedTopic!.length <= 6)
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.defaultSize,
                        bottom: SizeConfig.defaultSize * 2.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Value of 0 index is 1
                            // Value of 1 index is 2
                            if (data.selectedBookmarkedTopicIndex >= 1) {
                              data.changeBookmarkedTopic(
                                  isAdd: false,
                                  context: bookmarkedTopicKey.currentContext!);
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFFF9F9F9),
                                  border: Border.all(
                                      color:
                                          data.selectedBookmarkedTopicIndex == 0
                                              ? const Color(0xFFE6E6E6)
                                              : const Color(0xFF8897A7),
                                      width: 0.6)),
                              height: SizeConfig.defaultSize * 3.5,
                              width: SizeConfig.defaultSize * 3.5,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: data.selectedBookmarkedTopicIndex == 0
                                    ? const Color(0xFFD1D3D5)
                                    : const Color(0xFF8897A7),
                                size: SizeConfig.defaultSize * 2.5,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: Text(
                              '${data.selectedBookmarkedTopicIndex + 1}/${(bookMarkedTopic!.length / 6).ceil()}',
                              style: TextStyle(
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.7,
                                  color: const Color(0xFF8897A7))),
                        ),
                        GestureDetector(
                          onTap: () {
                            // If we our current page number is less than total pages in the list view. [Ex: if (0+1) = 1 < 2]
                            if (data.selectedBookmarkedTopicIndex + 1 <
                                (bookMarkedTopic!.length / 6).ceil()) {
                              data.changeBookmarkedTopic(
                                  isAdd: true,
                                  context: bookmarkedTopicKey.currentContext!);
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFFF9F9F9),
                                  border: Border.all(
                                      color: data.selectedBookmarkedTopicIndex +
                                                  1 >=
                                              (bookMarkedTopic!.length / 6)
                                                  .ceil()
                                          ? const Color(0xFFE6E6E6)
                                          : const Color(0xFF8897A7),
                                      width: 0.6)),
                              height: SizeConfig.defaultSize * 3.5,
                              width: SizeConfig.defaultSize * 3.5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: data.selectedBookmarkedTopicIndex + 1 >=
                                        (bookMarkedTopic!.length / 6).ceil()
                                    ? const Color(0xFFD1D3D5)
                                    : const Color(0xFF8897A7),
                                size: SizeConfig.defaultSize * 2.5,
                              )),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      );
    });
  }
}
