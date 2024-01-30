import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/profile_news.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/views/news_posts/single_news_description_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class MyTopicAndBookmarkContainer extends StatefulWidget {
  final ProfileNews topicData;
  final ProfileTopicType profileTopicType;
  const MyTopicAndBookmarkContainer(
      {super.key, required this.topicData, required this.profileTopicType});

  @override
  State<MyTopicAndBookmarkContainer> createState() =>
      _MyTopicAndBookmarkContainerState();
}

class _MyTopicAndBookmarkContainerState
    extends State<MyTopicAndBookmarkContainer> {
  final TextEditingController commentTxtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleNewsDescriptionScreen(
                      commentTxtController: commentTxtController,
                      newsPostId: widget.topicData.id.toString(),
                      isFocusTextField: false,
                      newsPostActionFrom: NewsPostActionFrom.newsPost,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: SizeConfig.defaultSize * 3,
            left: SizeConfig.defaultSize * 2,
            right: SizeConfig.defaultSize * 2),
        width: double.infinity,
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Color(0xFFD0E0F0), width: 1))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.defaultSize),
            child: Text(
              widget.topicData.title.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: kHelveticaMedium,
                  fontSize: SizeConfig.defaultSize * 1.4,
                  color: const Color(0xFF000000)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 0.8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(right: SizeConfig.defaultSize),
                          child: SvgPicture.asset(
                            "assets/svg/heart.svg",
                            color: const Color(0xFFD1D3D5),
                            height: SizeConfig.defaultSize * 1.3,
                            width: SizeConfig.defaultSize * 1.3,
                          ),
                        ),
                        Text(
                            '${widget.topicData.likeCount ?? '0'} ${widget.topicData.likeCount != null && widget.topicData.likeCount! > 1 ? AppLocalizations.of(context).likes : AppLocalizations.of(context).like}',
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.3,
                                color: const Color(0xFF8897A7))),
                      ]),
                ),
                SizedBox(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(right: SizeConfig.defaultSize),
                          child: SvgPicture.asset(
                            "assets/svg/comment.svg",
                            color: const Color(0xFFD1D3D5),
                            height: SizeConfig.defaultSize * 1.3,
                            width: SizeConfig.defaultSize * 1.3,
                          ),
                        ),
                        Text(
                          '${widget.topicData.commentCount ?? '0'}'
                          ' '
                          '${widget.topicData.commentCount != null && widget.topicData.commentCount! > 1 ? AppLocalizations.of(context).replies : AppLocalizations.of(context).reply.toLowerCase()}',
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.3,
                              color: const Color(0xFF8897A7)),
                        ),
                      ]),
                ),
                Text(
                    widget.topicData.createdAt == null
                        ? ''
                        : Provider.of<MainScreenProvider>(context,
                                listen: false)
                            .convertDateTimeToAgo(
                                widget.profileTopicType ==
                                            ProfileTopicType.bookmarkTopic &&
                                        widget.topicData.savedAt != null
                                    ? widget.topicData.savedAt!
                                    : widget.topicData.createdAt!,
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
  }

  @override
  void dispose() {
    commentTxtController.dispose();
    super.dispose();
  }
}
