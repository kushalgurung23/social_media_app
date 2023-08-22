import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

class ProfileTopicCommentListview extends StatelessWidget {
  final List<UserComment?>? allComments;

  const ProfileTopicCommentListview({Key? key, required this.allComments})
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
                      allComments!.sort(
                          (a, b) => a!.createdAt!.compareTo(b!.createdAt!));
                      final topicComment = allComments![index];
                      final commentBy = topicComment!.commentBy!;
                      return const SizedBox();

                      // data.mainScreenProvider.blockedUsersIdList
                      //         .contains(commentBy.id)
                      //     ?
                      //     : Padding(
                      //         padding: EdgeInsets.only(
                      //             top: SizeConfig.defaultSize * 1.5),
                      //         child: SizedBox(
                      //           child: Column(
                      //             children: [
                      //               Row(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   commentBy.profileImage == null
                      //                       ? GestureDetector(
                      //                           onTap: () {
                      //                             data.profileUserOnPress(
                      //                                 commentById:
                      //                                     commentBy.id!,
                      //                                 context: context);
                      //                           },
                      //                           child: CircleAvatar(
                      //                               backgroundImage:
                      //                                   const AssetImage(
                      //                                       "assets/images/default_profile.jpg"),
                      //                               radius:
                      //                                   SizeConfig.defaultSize *
                      //                                       1.5),
                      //                         )
                      //                       : GestureDetector(
                      //                           onTap: () {
                      //                             data.profileUserOnPress(
                      //                                 commentById:
                      //                                     commentBy.id!,
                      //                                 context: context);
                      //                           },
                      //                           child: CircleAvatar(
                      //                               backgroundImage:
                      //                                   NetworkImage(kIMAGEURL +
                      //                                       commentBy
                      //                                           .profileImage!
                      //                                           .url!),
                      //                               radius:
                      //                                   SizeConfig.defaultSize *
                      //                                       1.5),
                      //                         ),
                      //                   Flexible(
                      //                     child: Column(
                      //                       children: [
                      //                         Row(
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.start,
                      //                           children: [
                      //                             Expanded(
                      //                                 child: Row(
                      //                                     crossAxisAlignment:
                      //                                         CrossAxisAlignment
                      //                                             .start,
                      //                                     children: [
                      //                                   Padding(
                      //                                     padding: EdgeInsets.only(
                      //                                         left: SizeConfig
                      //                                             .defaultSize),
                      //                                     child:
                      //                                         GestureDetector(
                      //                                       onTap: () {
                      //                                         data.profileUserOnPress(
                      //                                             commentById:
                      //                                                 commentBy
                      //                                                     .id!,
                      //                                             context:
                      //                                                 context);
                      //                                       },
                      //                                       child: Container(
                      //                                         color: Colors
                      //                                             .transparent,
                      //                                         child: Text(
                      //                                           "${commentBy.username!} : ",
                      //                                           style: TextStyle(
                      //                                               fontFamily:
                      //                                                   kHelveticaMedium,
                      //                                               fontSize:
                      //                                                   SizeConfig.defaultSize *
                      //                                                       1.2,
                      //                                               color: Colors
                      //                                                   .black,
                      //                                               height:
                      //                                                   1.3),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   ),
                      //                                   Expanded(
                      //                                     child: Text(
                      //                                         topicComment
                      //                                             .content!,
                      //                                         style: TextStyle(
                      //                                             fontFamily:
                      //                                                 kHelveticaRegular,
                      //                                             fontSize:
                      //                                                 SizeConfig
                      //                                                         .defaultSize *
                      //                                                     1.2,
                      //                                             color: Colors
                      //                                                 .black,
                      //                                             height: 1.3)),
                      //                                   )
                      //                                 ])),
                      //                           ],
                      //                         ),
                      //                         Padding(
                      //                           padding: EdgeInsets.only(
                      //                               top:
                      //                                   SizeConfig.defaultSize *
                      //                                       0.1,
                      //                               bottom:
                      //                                   SizeConfig.defaultSize *
                      //                                       0.35),
                      //                           child: Row(
                      //                             mainAxisAlignment:
                      //                                 MainAxisAlignment.end,
                      //                             children: [
                      //                               Text(
                      //                                   data.mainScreenProvider
                      //                                       .convertDateTimeToAgo(
                      //                                           topicComment
                      //                                               .createdAt!,
                      //                                           context),
                      //                                   style: TextStyle(
                      //                                     fontFamily:
                      //                                         kHelveticaRegular,
                      //                                     fontSize: SizeConfig
                      //                                             .defaultSize *
                      //                                         1.05,
                      //                                     color: const Color(
                      //                                         0xFF8897A7),
                      //                                   )),
                      //                             ],
                      //                           ),
                      //                         )
                      //                       ],
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                    }),
              ),
      );
    });
  }
}
