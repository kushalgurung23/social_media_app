import 'dart:async';

import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/logic/providers/created_post_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/logic/providers/single_news_provider.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/news/liked_avatars.dart';
import 'package:c_talent/presentation/components/news/post_top_body.dart';
import 'package:c_talent/presentation/components/news/single_news_comments.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/news_posts/news_liked_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/constant/font_constant.dart';
import '../../../data/models/comment_load.dart';

class SingleNewsDescriptionScreen extends StatefulWidget {
  final String newsPostId;
  final bool isFocusTextField;
  final NewsPostActionFrom newsPostActionFrom;
  final TextEditingController commentTxtController;
  const SingleNewsDescriptionScreen(
      {Key? key,
      required this.commentTxtController,
      required this.isFocusTextField,
      required this.newsPostId,
      required this.newsPostActionFrom})
      : super(key: key);

  @override
  State<SingleNewsDescriptionScreen> createState() =>
      _SingleNewsDescriptionScreenState();
}

class _SingleNewsDescriptionScreenState
    extends State<SingleNewsDescriptionScreen> {
  StreamController<NewsPost> newsPostStreamController =
      BehaviorSubject<NewsPost>();
  late FocusNode focusNode;
  final scrollController = ScrollController();
  // EVERY SINGLE NEWS DESCRIPTION WILL HAVE THIS INITIAL VALUE WHILE LOADING COMMENTS
  // CLASS IS USED TO RETAIN THE VALUE OF EACH PROPERTY
  CommentLoad commentLoad = CommentLoad(
      isLoadingSingleNewsComments: false,
      singleNewsCommentsPageNum: 1,
      singleNewsCommentsPageSize: 10,
      hasMoreSingleNewsComments: true);

  @override
  void initState() {
    loadSingleNewsDetails();
    focusNode = FocusNode();
    if (widget.isFocusTextField == true) {
      focusNode.requestFocus();
    }
    super.initState();
  }

  Future<void> loadSingleNewsDetails() async {
    await Provider.of<SingleNewsProvider>(context, listen: false)
        .loadSingleNewsPost(
            singleNewsPostStreamController: newsPostStreamController,
            context: context,
            newsPostId: widget.newsPostId);
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsAdProvider>(context, listen: true);
    final createdPostProvider =
        Provider.of<CreatedPostProvider>(context, listen: true);
    final mainScreenProvider =
        Provider.of<MainScreenProvider>(context, listen: true);
    final singleNewsProvider =
        Provider.of<SingleNewsProvider>(context, listen: true);
    return Scaffold(
        appBar: topAppBar(
          leadingWidget: IconButton(
            splashRadius: SizeConfig.defaultSize * 2.5,
            icon: Icon(CupertinoIcons.back,
                color: const Color(0xFF8897A7),
                size: SizeConfig.defaultSize * 2.7),
            onPressed: () {
              // SAME FOR BOTH NEWS POST AND CREATED POST DESCRIPTION SCREEN
              singleNewsProvider.goBackFromNewsDescriptionScreen(
                  commentLoad: commentLoad,
                  newsCommentTextController: widget.commentTxtController,
                  context: context);
            },
          ),
          title: AppLocalizations.of(context).post,
        ),
        body: StreamBuilder<NewsPost?>(
            stream: newsPostStreamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).loading,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).refreshPage,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).dataCouldNotLoad,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    );
                  } else {
                    final newsPost = snapshot.data;
                    final postedBy = newsPost?.postedBy;
                    return newsPost == null || newsPost.postedBy == null
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.defaultSize * 2),
                            child: Column(
                              children: [
                                Flexible(
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics()),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: SizeConfig.defaultSize),
                                          child: PostTopBody(
                                              // isOtherUserProfile will be true only when we are viewing news post from other user's profile
                                              isOtherUserProfile: false,
                                              newsCommentTextEditingController:
                                                  widget.commentTxtController,
                                              newsPostFrom: NewsPostFrom
                                                  .newsPostDescription,
                                              newsPostId:
                                                  newsPost.id.toString(),
                                              commentOnPress: () {
                                                focusNode.requestFocus();
                                              },
                                              postedByOnPress: () {
                                                // if (postedBy.id != null &&
                                                //     data.mainScreenProvider.loginSuccess
                                                //             .user !=
                                                //         null) {
                                                //   if (postedBy.id !=
                                                //       int.parse(data.mainScreenProvider
                                                //           .loginSuccess.user!.id
                                                //           .toString())) {
                                                //     // Navigator.push(
                                                //     //     context,
                                                //     //     MaterialPageRoute(
                                                //     //         builder: (context) =>
                                                //     //             OtherUserProfileScreen(
                                                //     //               otherUserId:
                                                //     //                   int.parse(postedBy
                                                //     //                       .id
                                                //     //                       .toString()),
                                                //     //             )));
                                                //   } else {
                                                //     // Navigator.pushNamed(
                                                //     //     context,
                                                //     //     MyProfileScreen.id);
                                                //   }
                                                // }
                                              },
                                              showLevel: true,
                                              title: newsPost.title.toString(),
                                              userName:
                                                  postedBy!.username.toString(),
                                              postContent:
                                                  newsPost.content.toString(),
                                              postImages: newsPost.images,
                                              postedTime: newsPost.createdAt == null
                                                  ? ''
                                                  : mainScreenProvider
                                                      .convertDateTimeToAgo(
                                                          newsPost.createdAt!,
                                                          context),
                                              userImage:
                                                  postedBy.profilePicture,
                                              userType: newsProvider.getUserType(
                                                  userType:
                                                      postedBy.userType ?? '',
                                                  context: context),
                                              isSave: newsPost.isSaved == 1
                                                  ? true
                                                  : false,
                                              saveOnPress: () async {
                                                if (widget.newsPostActionFrom ==
                                                    NewsPostActionFrom
                                                        .newsPost) {
                                                  await newsProvider
                                                      .toggleNewsPostSave(
                                                          newsPost: newsPost,
                                                          context: context);
                                                } else if (widget
                                                        .newsPostActionFrom ==
                                                    NewsPostActionFrom
                                                        .createdPost) {
                                                  await createdPostProvider
                                                      .toggleCreatedPostSave(
                                                          createdPost: newsPost,
                                                          context: context);
                                                }
                                              },
                                              isLike: newsPost.isLiked == 1
                                                  ? true
                                                  : false,
                                              likeOnPress: () async {
                                                if (widget.newsPostActionFrom ==
                                                    NewsPostActionFrom
                                                        .newsPost) {
                                                  await newsProvider
                                                      .toggleNewsPostLike(
                                                          newsPost: newsPost,
                                                          context: context);
                                                } else if (widget
                                                        .newsPostActionFrom ==
                                                    NewsPostActionFrom
                                                        .createdPost) {
                                                  await createdPostProvider
                                                      .toggleCreatedPostLike(
                                                          createdPost: newsPost,
                                                          context: context);
                                                }
                                              },
                                              hasLikes: newsPost.likesCount == null ||
                                                      newsPost.likesCount! < 1
                                                  ? false
                                                  : true,
                                              seeLikesOnPress: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            NewsLikedScreen(
                                                              postId: int.parse(
                                                                  newsPost.id
                                                                      .toString()),
                                                            )));
                                              },
                                              likedAvtars: LikedAvatars(
                                                  newsPost: newsPost,
                                                  isLike: newsPost.isLiked == 1
                                                      ? true
                                                      : false),
                                              totalLikes: newsProvider.getLike(
                                                  likeCount: newsPost.likesCount ?? 0,
                                                  context: context)),
                                        ),
                                        // News comment
                                        newsPost.comments == null ||
                                                newsPost.commentCount == 0
                                            ? const SizedBox()
                                            : SingleNewsComments(
                                                commentLoad: commentLoad,
                                                scrollController:
                                                    scrollController,
                                                newsPost: newsPost),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFD0E0F0),
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.defaultSize * 2),
                                  child: RoundedTextFormField(
                                      focusNode: focusNode,
                                      onTap: () {},
                                      textEditingController:
                                          widget.commentTxtController,
                                      textInputType: TextInputType.text,
                                      isEnable: true,
                                      isReadOnly: false,
                                      usePrefix: false,
                                      useSuffix: true,
                                      hintText: AppLocalizations.of(context)
                                          .writeAComment,
                                      suffixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.defaultSize * 0.2,
                                            right:
                                                SizeConfig.defaultSize * 0.2),
                                        child: SvgPicture.asset(
                                          "assets/svg/post_comment.svg",

                                          height: SizeConfig.defaultSize * 4,
                                          width: SizeConfig.defaultSize * 4,
                                          // color: Colors.white,
                                        ),
                                      ),
                                      suffixOnPress: () async {
                                        // if (widget
                                        //     .newsCommentTextEditingController.text
                                        //     .trim()
                                        //     .isNotEmpty) {
                                        //   focusNode.unfocus();
                                        //   if (widget.newsPostActionFrom ==
                                        //       NewsPostActionFrom.newsPost) {
                                        //     await newsProvider.writeNewsPostComment(
                                        //         newsPost: newsPost,
                                        //         commentTextController: widget
                                        //             .newsCommentTextEditingController,
                                        //         context: context);
                                        //   } else {
                                        //     await createdPostProvider
                                        //         .writeCreatedPostComment(
                                        //             createdPost: newsPost,
                                        //             commentTextController: widget
                                        //                 .newsCommentTextEditingController,
                                        //             context: context);
                                        //   }
                                        // }
                                      },
                                      borderRadius:
                                          SizeConfig.defaultSize * 1.5),
                                ),
                              ],
                            ),
                          );
                  }
              }
            }));
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    newsPostStreamController.close();
    super.dispose();
  }
}
