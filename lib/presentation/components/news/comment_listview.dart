import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

class CommentListview extends StatelessWidget {
  final bool fromProfileTopic;
  final List<CommentsData>? allComments;

  const CommentListview(
      {Key? key, required this.allComments, required this.fromProfileTopic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 2),
        child: allComments == null
            ? const SizedBox()
            : SizedBox(
                child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: allComments!.length,
                    itemBuilder: (context, index) {
                      allComments!.sort((a, b) => a.attributes!.createdAt!
                          .compareTo(b.attributes!.createdAt!));
                      final newsComment = allComments![index];
                      final commentBy =
                          newsComment.attributes!.commentBy!.data?.attributes;
                      return Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.defaultSize * 1.5),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (commentBy!.profileImage == null ||
                                          commentBy.profileImage!.data == null)
                                      ? GestureDetector(
                                          onTap: () {
                                            if (newsComment.attributes!
                                                    .commentBy!.data!.id !=
                                                null) {
                                              if (fromProfileTopic == true) {
                                                data.profileUserOnPress(
                                                    commentById: newsComment
                                                        .attributes!
                                                        .commentBy!
                                                        .data!
                                                        .id!,
                                                    context: context);
                                              } else {
                                                data.postUserOnPress(
                                                  userId: newsComment
                                                      .attributes!
                                                      .commentBy!
                                                      .data!
                                                      .id!,
                                                  context: context,
                                                );
                                              }
                                            }
                                          },
                                          child: CircleAvatar(
                                              backgroundImage: const AssetImage(
                                                  "assets/images/default_profile.jpg"),
                                              radius:
                                                  SizeConfig.defaultSize * 1.5),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            if (newsComment.attributes!
                                                    .commentBy!.data!.id !=
                                                null) {
                                              if (fromProfileTopic == true) {
                                                data.profileUserOnPress(
                                                    commentById: newsComment
                                                        .attributes!
                                                        .commentBy!
                                                        .data!
                                                        .id!,
                                                    context: context);
                                              } else {
                                                data.postUserOnPress(
                                                  userId: newsComment
                                                      .attributes!
                                                      .commentBy!
                                                      .data!
                                                      .id!,
                                                  context: context,
                                                );
                                              }
                                            }
                                          },
                                          child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  kIMAGEURL +
                                                      commentBy
                                                          .profileImage!
                                                          .data!
                                                          .attributes!
                                                          .url!),
                                              radius:
                                                  SizeConfig.defaultSize * 1.5),
                                        ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: SizeConfig
                                                            .defaultSize),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (newsComment
                                                                .attributes!
                                                                .commentBy!
                                                                .data!
                                                                .id !=
                                                            null) {
                                                          if (fromProfileTopic ==
                                                              true) {
                                                            data.profileUserOnPress(
                                                                commentById:
                                                                    newsComment
                                                                        .attributes!
                                                                        .commentBy!
                                                                        .data!
                                                                        .id!,
                                                                context:
                                                                    context);
                                                          } else {
                                                            data.postUserOnPress(
                                                              userId: newsComment
                                                                  .attributes!
                                                                  .commentBy!
                                                                  .data!
                                                                  .id!,
                                                              context: context,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Text(
                                                          commentBy.username! +
                                                              " : ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  kHelveticaMedium,
                                                              fontSize: SizeConfig
                                                                      .defaultSize *
                                                                  1.2,
                                                              color:
                                                                  Colors.black,
                                                              height: 1.3),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        newsComment
                                                            .attributes!.content!,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                kHelveticaRegular,
                                                            fontSize: SizeConfig
                                                                    .defaultSize *
                                                                1.2,
                                                            color: Colors.black,
                                                            height: 1.3)),
                                                  )
                                                ])),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeConfig.defaultSize * 0.1,
                                              bottom: SizeConfig.defaultSize *
                                                  0.35),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  data.mainScreenProvider
                                                      .convertDateTimeToAgo(
                                                          newsComment
                                                              .attributes!
                                                              .createdAt!,
                                                          context),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        kHelveticaRegular,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            1.05,
                                                    color:
                                                        const Color(0xFF8897A7),
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
      );
    });
  }
}
