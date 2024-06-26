// import 'dart:async';
// import 'package:c_talent/data/enum/all.dart';
// import 'package:c_talent/data/models/all_news_posts.dart';
// import 'package:c_talent/logic/providers/created_post_provider.dart';
// import 'package:c_talent/logic/providers/main_screen_provider.dart';
// import 'package:c_talent/logic/providers/news_ad_provider.dart';
// import 'package:c_talent/presentation/components/news/post_top_body.dart';
// import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
// import 'package:c_talent/presentation/components/all/top_app_bar.dart';
// import 'package:c_talent/presentation/components/news/comment_listview.dart';
// import 'package:c_talent/presentation/components/news/liked_avatars.dart';
// import 'package:c_talent/presentation/helper/size_configuration.dart';
// import 'package:c_talent/presentation/views/news_posts/news_liked_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:rxdart/rxdart.dart';

// class NewsDescriptionScreen extends StatefulWidget {
//   final NewsPost newsPost;
//   final bool isFocusTextField;
//   final NewsPostActionFrom newsPostActionFrom;
//   final TextEditingController newsCommentTextEditingController;
//   const NewsDescriptionScreen(
//       {Key? key,
//       required this.isFocusTextField,
//       required this.newsPost,
//       required this.newsCommentTextEditingController,
//       required this.newsPostActionFrom})
//       : super(key: key);

//   @override
//   State<NewsDescriptionScreen> createState() => _NewsDescriptionScreenState();
// }

// class _NewsDescriptionScreenState extends State<NewsDescriptionScreen> {
//   StreamController<List<NewsComment>?> allNewsCommentStreamController =
//       BehaviorSubject();
//   late FocusNode focusNode;
//   final scrollController = ScrollController();

//   @override
//   void initState() {
//     loadInitialNewsComments();

//     focusNode = FocusNode();
//     if (widget.isFocusTextField == true) {
//       focusNode.requestFocus();
//     }

//     scrollController.addListener(() {
//       if (scrollController.position.maxScrollExtent ==
//           scrollController.offset) {
//         loadMoreNewsComments();
//       }
//     });
//     super.initState();
//   }

//   Future<void> loadInitialNewsComments() async {
//     // await Provider.of<NewsAdProvider>(context, listen: false)
//     //     .loadInitialNewsComments(
//     //         newsPost: widget.newsPost,
//     //         context: context,
//     //         allNewsCommentStreamController: allNewsCommentStreamController);
//   }

//   Future<void> loadMoreNewsComments() async {
//     // await Provider.of<NewsAdProvider>(context, listen: false)
//     //     .loadMoreNewsComments(
//     //         context: context,
//     //         allNewsCommentStreamController: allNewsCommentStreamController,
//     //         newsPost: widget.newsPost);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final postedBy = widget.newsPost.postedBy;
//     final newsProvider = Provider.of<NewsAdProvider>(context, listen: true);
//     final createdPostProvider =
//         Provider.of<CreatedPostProvider>(context, listen: true);
//     final mainScreenProvider =
//         Provider.of<MainScreenProvider>(context, listen: true);
//     return Scaffold(
//         appBar: topAppBar(
//           leadingWidget: IconButton(
//             splashRadius: SizeConfig.defaultSize * 2.5,
//             icon: Icon(CupertinoIcons.back,
//                 color: const Color(0xFF8897A7),
//                 size: SizeConfig.defaultSize * 2.7),
//             onPressed: () {
//               // SAME FOR BOTH NEWS POST AND CREATED POST DESCRIPTION SCREEN
//               newsProvider.goBackFromNewsDescriptionScreen(
//                   newsCommentTextController:
//                       widget.newsCommentTextEditingController,
//                   context: context);
//             },
//           ),
//           title: AppLocalizations.of(context).post,
//         ),
//         body: postedBy == null
//             ? const SizedBox()
//             : Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: SizeConfig.defaultSize * 2),
//                 child: Column(
//                   children: [
//                     Flexible(
//                       child: SingleChildScrollView(
//                         controller: scrollController,
//                         physics: const AlwaysScrollableScrollPhysics(
//                             parent: BouncingScrollPhysics()),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(
//                                   bottom: SizeConfig.defaultSize),
//                               child: PostTopBody(
//                                   // isOtherUserProfile will be true only when we are viewing news post from other user's profile
//                                   isOtherUserProfile: false,
//                                   newsCommentTextEditingController:
//                                       widget.newsCommentTextEditingController,
//                                   newsPostFrom:
//                                       NewsPostFrom.newsPostDescription,
//                                   newsPostId: widget.newsPost.id.toString(),
//                                   commentOnPress: () {
//                                     focusNode.requestFocus();
//                                   },
//                                   postedByOnPress: () {
//                                     // if (postedBy.id != null &&
//                                     //     data.mainScreenProvider.loginSuccess
//                                     //             .user !=
//                                     //         null) {
//                                     //   if (postedBy.id !=
//                                     //       int.parse(data.mainScreenProvider
//                                     //           .loginSuccess.user!.id
//                                     //           .toString())) {
//                                     //     // Navigator.push(
//                                     //     //     context,
//                                     //     //     MaterialPageRoute(
//                                     //     //         builder: (context) =>
//                                     //     //             OtherUserProfileScreen(
//                                     //     //               otherUserId:
//                                     //     //                   int.parse(postedBy
//                                     //     //                       .id
//                                     //     //                       .toString()),
//                                     //     //             )));
//                                     //   } else {
//                                     //     // Navigator.pushNamed(
//                                     //     //     context,
//                                     //     //     MyProfileScreen.id);
//                                     //   }
//                                     // }
//                                   },
//                                   showLevel: true,
//                                   title: widget.newsPost.title.toString(),
//                                   userName: postedBy.username.toString(),
//                                   postContent:
//                                       widget.newsPost.content.toString(),
//                                   postImages: widget.newsPost.images,
//                                   postedTime: widget.newsPost.createdAt == null
//                                       ? ''
//                                       : mainScreenProvider.convertDateTimeToAgo(
//                                           widget.newsPost.createdAt!, context),
//                                   userImage: postedBy.profilePicture,
//                                   userType: newsProvider.getUserType(
//                                       userType: postedBy.userType ?? '',
//                                       context: context),
//                                   isSave: widget.newsPost.isSaved == 1
//                                       ? true
//                                       : false,
//                                   saveOnPress: () async {
//                                     if (widget.newsPostActionFrom ==
//                                         NewsPostActionFrom.newsPost) {
//                                       await newsProvider.toggleNewsPostSave(
//                                           newsPost: widget.newsPost,
//                                           context: context);
//                                     } else if (widget.newsPostActionFrom ==
//                                         NewsPostActionFrom.createdPost) {
//                                       await createdPostProvider
//                                           .toggleCreatedPostSave(
//                                               createdPost: widget.newsPost,
//                                               context: context);
//                                     }
//                                   },
//                                   isLike: widget.newsPost.isLiked == 1
//                                       ? true
//                                       : false,
//                                   likeOnPress: () async {
//                                     if (widget.newsPostActionFrom ==
//                                         NewsPostActionFrom.newsPost) {
//                                       await newsProvider.toggleNewsPostLike(
//                                           newsPost: widget.newsPost,
//                                           context: context);
//                                     } else if (widget.newsPostActionFrom ==
//                                         NewsPostActionFrom.createdPost) {
//                                       await createdPostProvider
//                                           .toggleCreatedPostLike(
//                                               createdPost: widget.newsPost,
//                                               context: context);
//                                     }
//                                   },
//                                   hasLikes:
//                                       widget.newsPost.likesCount == null ||
//                                               widget.newsPost.likesCount! < 1
//                                           ? false
//                                           : true,
//                                   seeLikesOnPress: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 NewsLikedScreen(
//                                                   postId: int.parse(widget
//                                                       .newsPost.id
//                                                       .toString()),
//                                                 )));
//                                   },
//                                   likedAvtars: LikedAvatars(
//                                       newsPost: widget.newsPost,
//                                       isLike: widget.newsPost.isLiked == 1
//                                           ? true
//                                           : false),
//                                   totalLikes: newsProvider.getLike(
//                                       likeCount:
//                                           widget.newsPost.likesCount ?? 0,
//                                       context: context)),
//                             ),
//                             // News comment
//                             widget.newsPost.comments == null ||
//                                     widget.newsPost.commentCount == 0
//                                 ? const SizedBox()
//                                 : CommentListview(
//                                     newsPost: widget.newsPost,
//                                     allNewsCommentStreamController:
//                                         allNewsCommentStreamController,
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Divider(
//                       height: 1,
//                       color: Color(0xFFD0E0F0),
//                       thickness: 1,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: SizeConfig.defaultSize * 2),
//                       child: RoundedTextFormField(
//                           focusNode: focusNode,
//                           onTap: () {},
//                           textEditingController:
//                               widget.newsCommentTextEditingController,
//                           textInputType: TextInputType.text,
//                           isEnable: true,
//                           isReadOnly: false,
//                           usePrefix: false,
//                           useSuffix: true,
//                           hintText: AppLocalizations.of(context).writeAComment,
//                           suffixIcon: Padding(
//                             padding: EdgeInsets.only(
//                                 top: SizeConfig.defaultSize * 0.2,
//                                 right: SizeConfig.defaultSize * 0.2),
//                             child: SvgPicture.asset(
//                               "assets/svg/post_comment.svg",

//                               height: SizeConfig.defaultSize * 4,
//                               width: SizeConfig.defaultSize * 4,
//                               // color: Colors.white,
//                             ),
//                           ),
//                           suffixOnPress: () async {
//                             if (widget.newsCommentTextEditingController.text
//                                 .trim()
//                                 .isNotEmpty) {
//                               focusNode.unfocus();
//                               if (widget.newsPostActionFrom ==
//                                   NewsPostActionFrom.newsPost) {
//                                 await newsProvider.writeNewsPostComment(
//                                     newsPost: widget.newsPost,
//                                     commentTextController:
//                                         widget.newsCommentTextEditingController,
//                                     context: context);
//                               } else {
//                                 await createdPostProvider
//                                     .writeCreatedPostComment(
//                                         createdPost: widget.newsPost,
//                                         commentTextController: widget
//                                             .newsCommentTextEditingController,
//                                         context: context);
//                               }
//                             }
//                           },
//                           borderRadius: SizeConfig.defaultSize * 1.5),
//                     ),
//                   ],
//                 ),
//               ));
//   }

//   @override
//   void dispose() {
//     focusNode.dispose();
//     scrollController.dispose();
//     allNewsCommentStreamController.close();

//     super.dispose();
//   }
// }
