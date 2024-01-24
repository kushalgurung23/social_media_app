import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/profile_news.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class ProfileTopicBody extends StatelessWidget {
  final AllProfileNews allProfileNews;
  final int selectedTopicIndex;
  final VoidCallback goBack, goInfront;
  final ProfileTopicType profileTopicType;
  const ProfileTopicBody(
      {super.key,
      required this.allProfileNews,
      required this.selectedTopicIndex,
      required this.goBack,
      required this.profileTopicType,
      required this.goInfront});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // If length is greater than or equal to 6, make the list view item count: 6. Else make the item count's value the remaining items left in the list
          itemCount: allProfileNews.count! - (6 * selectedTopicIndex) >= 6
              ? 6
              : allProfileNews.count! - (6 * selectedTopicIndex),
          itemBuilder: (BuildContext context, int index) {
            final topicData =
                allProfileNews.news![index + (6 * selectedTopicIndex)];
            return GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             LastBookmarkTopicDescriptionScreen(
                //                 topicId:
                //                     topicData.id.toString(),
                //                 newsCommentTextEditingController:
                //                     data.profileTopicTextEditingController)));
              },
              child: Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.defaultSize * 3,
                    left: SizeConfig.defaultSize * 2,
                    right: SizeConfig.defaultSize * 2),
                width: double.infinity,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Color(0xFFD0E0F0), width: 1))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: SizeConfig.defaultSize),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig.defaultSize),
                                      child: SvgPicture.asset(
                                        "assets/svg/heart.svg",
                                        color: const Color(0xFFD1D3D5),
                                        height: SizeConfig.defaultSize * 1.3,
                                        width: SizeConfig.defaultSize * 1.3,
                                      ),
                                    ),
                                    Text(
                                        '${topicData.likeCount ?? '0'} ${topicData.likeCount != null && topicData.likeCount! > 1 ? AppLocalizations.of(context).likes : AppLocalizations.of(context).like}',
                                        style: TextStyle(
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.3,
                                            color: const Color(0xFF8897A7))),
                                  ]),
                            ),
                            SizedBox(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: SizeConfig.defaultSize),
                                      child: SvgPicture.asset(
                                        "assets/svg/comment.svg",
                                        color: const Color(0xFFD1D3D5),
                                        height: SizeConfig.defaultSize * 1.3,
                                        width: SizeConfig.defaultSize * 1.3,
                                      ),
                                    ),
                                    Text(
                                      '${topicData.commentCount ?? '0'}'
                                      ' '
                                      '${topicData.commentCount != null && topicData.commentCount! > 1 ? AppLocalizations.of(context).replies : AppLocalizations.of(context).reply.toLowerCase()}',
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.3,
                                          color: const Color(0xFF8897A7)),
                                    ),
                                  ]),
                            ),
                            Text(
                                topicData.createdAt == null
                                    ? ''
                                    : Provider.of<MainScreenProvider>(context,
                                            listen: false)
                                        .convertDateTimeToAgo(
                                            profileTopicType ==
                                                        ProfileTopicType
                                                            .bookmarkTopic &&
                                                    topicData.savedAt != null
                                                ? topicData.savedAt!
                                                : topicData.createdAt!,
                                            context),
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.3,
                                    color: const Color(0xFF8897A7)))
                          ],
                        ),
                      )
                    ]),
              ),
            );
          },
        ),
        // GO TO FRONT/BACK BUTTON
        // Only show bottom left, right button if listview has length equal or greater than 6
        allProfileNews.count! <= 6
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.defaultSize,
                    bottom: SizeConfig.defaultSize * 2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: goBack,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFF9F9F9),
                              border: Border.all(
                                  color: selectedTopicIndex == 0
                                      ? const Color(0xFFE6E6E6)
                                      : const Color(0xFF8897A7),
                                  width: 0.6)),
                          height: SizeConfig.defaultSize * 3.5,
                          width: SizeConfig.defaultSize * 3.5,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: selectedTopicIndex == 0
                                ? const Color(0xFFD1D3D5)
                                : const Color(0xFF8897A7),
                            size: SizeConfig.defaultSize * 2.5,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Text(
                          allProfileNews.count == null
                              ? ''
                              : '${selectedTopicIndex + 1}/${(allProfileNews.count! / 6).ceil()}',
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.7,
                              color: const Color(0xFF8897A7))),
                    ),
                    GestureDetector(
                      onTap: goInfront,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFF9F9F9),
                              border: Border.all(
                                  color: selectedTopicIndex + 1 >=
                                          (allProfileNews.count! / 6).ceil()
                                      ? const Color(0xFFE6E6E6)
                                      : const Color(0xFF8897A7),
                                  width: 0.6)),
                          height: SizeConfig.defaultSize * 3.5,
                          width: SizeConfig.defaultSize * 3.5,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: allProfileNews.count != null &&
                                    selectedTopicIndex + 1 >=
                                        (allProfileNews.count! / 6).ceil()
                                ? const Color(0xFFD1D3D5)
                                : const Color(0xFF8897A7),
                            size: SizeConfig.defaultSize * 2.5,
                          )),
                    ),
                  ],
                ),
              )
      ],
    );
  }
}
