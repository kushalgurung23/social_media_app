import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentContainer extends StatelessWidget {
  final NewsComment comment;
  const CommentContainer({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return comment.commentBy == null
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: SizeConfig.defaultSize * 1.5),
            child: SizedBox(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      comment.commentBy!.profilePicture == null
                          ? GestureDetector(
                              onTap: () {
                                // if (newsComment.attributes!
                                //         .commentBy!.data!.id !=
                                //     null) {
                                //   if (fromProfileTopic == true) {
                                //     data.profileUserOnPress(
                                //         commentById: newsComment
                                //             .attributes!
                                //             .commentBy!
                                //             .data!
                                //             .id!,
                                //         context: context);
                                //   } else {
                                //     data.postUserOnPress(
                                //       userId: newsComment
                                //           .attributes!
                                //           .commentBy!
                                //           .data!
                                //           .id!,
                                //       context: context,
                                //     );
                                //   }
                                // }
                              },
                              child: CircleAvatar(
                                  backgroundImage: const AssetImage(
                                      "assets/images/default_profile.jpg"),
                                  radius: SizeConfig.defaultSize * 1.5),
                            )
                          : GestureDetector(
                              onTap: () {
                                // if (newsComment.attributes!.commentBy!.data!.id !=
                                //     null) {
                                //   if (fromProfileTopic == true) {
                                //     data.profileUserOnPress(
                                //         commentById: newsComment
                                //             .attributes!.commentBy!.data!.id!,
                                //         context: context);
                                //   } else {
                                //     data.postUserOnPress(
                                //       userId: newsComment
                                //           .attributes!.commentBy!.data!.id!,
                                //       context: context,
                                //     );
                                //   }
                                // }
                              },
                              child: CircleAvatar(
                                  backgroundImage: NetworkImage(kIMAGEURL +
                                      comment.commentBy!.profilePicture
                                          .toString()),
                                  radius: SizeConfig.defaultSize * 1.5),
                            ),
                      Flexible(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: SizeConfig.defaultSize),
                                        child: GestureDetector(
                                          onTap: () {
                                            // if (newsComment.attributes!.commentBy!
                                            //         .data!.id !=
                                            //     null) {
                                            //   if (fromProfileTopic == true) {
                                            //     data.profileUserOnPress(
                                            //         commentById: newsComment
                                            //             .attributes!
                                            //             .commentBy!
                                            //             .data!
                                            //             .id!,
                                            //         context: context);
                                            //   } else {
                                            //     data.postUserOnPress(
                                            //       userId: newsComment.attributes!
                                            //           .commentBy!.data!.id!,
                                            //       context: context,
                                            //     );
                                            //   }
                                            // }
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Text(
                                              "${comment.commentBy!.username} : ",
                                              style: TextStyle(
                                                  fontFamily: kHelveticaMedium,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.2,
                                                  color: Colors.black,
                                                  height: 1.3),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(comment.comment.toString(),
                                            style: TextStyle(
                                                fontFamily: kHelveticaRegular,
                                                fontSize:
                                                    SizeConfig.defaultSize *
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
                                  bottom: SizeConfig.defaultSize * 0.35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      comment.createdAt == null
                                          ? ''
                                          : Provider.of<MainScreenProvider>(
                                                  context,
                                                  listen: false)
                                              .convertDateTimeToAgo(
                                                  comment.createdAt!, context),
                                      style: TextStyle(
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.05,
                                        color: const Color(0xFF8897A7),
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
  }
}
