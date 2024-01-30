import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/profile_news.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/components/profile/my_topic_and_bookmark_container.dart';
import 'package:c_talent/presentation/views/news_posts/single_news_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class ProfileTopicBody extends StatefulWidget {
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
  State<ProfileTopicBody> createState() => _ProfileTopicBodyState();
}

class _ProfileTopicBodyState extends State<ProfileTopicBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // If length is greater than or equal to 6, make the list view item count: 6. Else make the item count's value the remaining items left in the list
          itemCount: widget.allProfileNews.count! -
                      (6 * widget.selectedTopicIndex) >=
                  6
              ? 6
              : widget.allProfileNews.count! - (6 * widget.selectedTopicIndex),
          itemBuilder: (BuildContext context, int index) {
            final topicData = widget
                .allProfileNews.news?[index + (6 * widget.selectedTopicIndex)];
            return topicData == null
                ? const SizedBox()
                : MyTopicAndBookmarkContainer(
                    topicData: topicData,
                    profileTopicType: widget.profileTopicType);
          },
        ),
        // GO TO FRONT/BACK BUTTON
        // Only show bottom left, right button if listview has length equal or greater than 6
        widget.allProfileNews.count! <= 6
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.defaultSize,
                    bottom: SizeConfig.defaultSize * 2.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: widget.goBack,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFF9F9F9),
                              border: Border.all(
                                  color: widget.selectedTopicIndex == 0
                                      ? const Color(0xFFE6E6E6)
                                      : const Color(0xFF8897A7),
                                  width: 0.6)),
                          height: SizeConfig.defaultSize * 3.5,
                          width: SizeConfig.defaultSize * 3.5,
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: widget.selectedTopicIndex == 0
                                ? const Color(0xFFD1D3D5)
                                : const Color(0xFF8897A7),
                            size: SizeConfig.defaultSize * 2.5,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Text(
                          widget.allProfileNews.count == null
                              ? ''
                              : '${widget.selectedTopicIndex + 1}/${(widget.allProfileNews.count! / 6).ceil()}',
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.7,
                              color: const Color(0xFF8897A7))),
                    ),
                    GestureDetector(
                      onTap: widget.goInfront,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color(0xFFF9F9F9),
                              border: Border.all(
                                  color: widget.selectedTopicIndex + 1 >=
                                          (widget.allProfileNews.count! / 6)
                                              .ceil()
                                      ? const Color(0xFFE6E6E6)
                                      : const Color(0xFF8897A7),
                                  width: 0.6)),
                          height: SizeConfig.defaultSize * 3.5,
                          width: SizeConfig.defaultSize * 3.5,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: widget.allProfileNews.count != null &&
                                    widget.selectedTopicIndex + 1 >=
                                        (widget.allProfileNews.count! / 6)
                                            .ceil()
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
