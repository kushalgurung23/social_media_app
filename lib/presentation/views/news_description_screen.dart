import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/news_post_enum.dart';
import 'package:c_talent/data/enum/post_type.dart';
// ignore: depend_on_referenced_packages
import 'package:c_talent/data/new_models/all_news_posts.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/components/all/post_top_body.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/news/comment_listview.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/my_profile_screen.dart';
import 'package:c_talent/presentation/views/news_liked_screen.dart';
import 'package:c_talent/presentation/views/other_user_profile_screen.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class NewsDescriptionScreen extends StatefulWidget {
  final NewsPost newsPost;
  final TextEditingController newsCommentTextEditingController;
  final bool scrollToBottom, focusTextfield;

  const NewsDescriptionScreen(
      {Key? key,
      this.focusTextfield = false,
      this.scrollToBottom = false,
      required this.newsPost,
      required this.newsCommentTextEditingController})
      : super(key: key);

  @override
  State<NewsDescriptionScreen> createState() => _NewsDescriptionScreenState();
}

class _NewsDescriptionScreenState extends State<NewsDescriptionScreen> {
  late FocusNode focusNode;
  @override
  void initState() {
    Provider.of<NewsAdProvider>(context, listen: false)
        .changeNewsReverse(isReverse: widget.scrollToBottom, fromInitial: true);
    focusNode = FocusNode();
    if (widget.focusTextfield == true) {
      focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsAdProvider>(
      builder: (context, data, child) {
        return Scaffold(
          appBar: topAppBar(
            leadingWidget: IconButton(
              splashRadius: SizeConfig.defaultSize * 2.5,
              icon: Icon(CupertinoIcons.back,
                  color: const Color(0xFF8897A7),
                  size: SizeConfig.defaultSize * 2.7),
              onPressed: () {
                if (widget.newsCommentTextEditingController.text != '') {
                  widget.newsCommentTextEditingController.text = '';
                }
                Navigator.pop(context);
              },
            ),
            title: AppLocalizations.of(context).post,
          ),
          body: StreamBuilder<AllNewsPosts>(
              stream: data.allNewsPostController.stream,
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
                        child: Text(AppLocalizations.of(context).errorOccured,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5)),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                            AppLocalizations.of(context).newsCouldNotLoad,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5)),
                      );
                    } else {
                      final postedBy = widget.newsPost.postedBy;

                      return postedBy == null
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize * 2),
                              child: Column(
                                children: [
                                  Flexible(
                                    child: SingleChildScrollView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(
                                              parent: BouncingScrollPhysics()),
                                      reverse: data.isNewsDescriptionReverse,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: SizeConfig.defaultSize),
                                            child: PostTopBody(
                                                // isOtherUserProfile will be true only when we are viewing news post from other user's profile
                                                isOtherUserProfile: false,
                                                newsCommentTextEditingController: widget
                                                    .newsCommentTextEditingController,
                                                isFromDescriptionScreen: true,
                                                newsPostId: widget.newsPost.id
                                                    .toString(),
                                                commentOnPress: () {
                                                  data.changeNewsReverse(
                                                      isReverse: true);
                                                  focusNode.requestFocus();
                                                },
                                                postedByOnPress: () {
                                                  if (postedBy.id != null) {
                                                    if (postedBy.id !=
                                                        int.parse(data
                                                            .mainScreenProvider
                                                            .currentUserId!)) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OtherUserProfileScreen(
                                                                    otherUserId:
                                                                        int.parse(postedBy
                                                                            .id
                                                                            .toString()),
                                                                  )));
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          MyProfileScreen.id);
                                                    }
                                                  }
                                                },
                                                postType: PostType.newsPost,
                                                showLevel: true,
                                                title: widget.newsPost.title
                                                    .toString(),
                                                userName: postedBy.username
                                                    .toString(),
                                                postContent: widget.newsPost.content
                                                    .toString(),
                                                postImage:
                                                    widget.newsPost.images,
                                                postedTime: widget.newsPost.createdAt == null
                                                    ? ''
                                                    : data.mainScreenProvider.convertDateTimeToAgo(
                                                        widget.newsPost
                                                            .createdAt!,
                                                        context),
                                                userImage:
                                                    postedBy.profilePicture,
                                                userType: data.getUserType(
                                                    userType:
                                                        postedBy.userType ?? '',
                                                    context: context),
                                                isSave: widget.newsPost.isSaved == 1
                                                    ? true
                                                    : false,
                                                saveOnPress: () async {},
                                                isLike: widget.newsPost.isLiked == 1
                                                    ? true
                                                    : false,
                                                likeOnPress: () async {},
                                                hasLikes: widget.newsPost.likesCount == null ||
                                                        widget.newsPost.likesCount! < 1
                                                    ? false
                                                    : true,
                                                seeLikesOnPress: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewsLikedScreen(
                                                                postId: int
                                                                    .parse(widget
                                                                        .newsPost
                                                                        .id
                                                                        .toString()),
                                                              )));
                                                },
                                                likedAvtars: data.likedAvatars(likes: widget.newsPost.likes, isLike: widget.newsPost.isLiked == 1 ? true : false),
                                                totalLikes: data.getLike(likeCount: widget.newsPost.likesCount ?? 0, context: context)),
                                          ),
                                          // News comment
                                          // CommentListview(
                                          //     fromProfileTopic: false,
                                          //     // ignore: prefer_null_aware_operators
                                          //     allComments: allComments == null
                                          //         ? null
                                          //         : allComments
                                          //             .where((element) =>
                                          //                 element.attributes !=
                                          //                     null &&
                                          //                 element.attributes!
                                          //                         .commentBy !=
                                          //                     null &&
                                          //                 element
                                          //                         .attributes!
                                          //                         .commentBy!
                                          //                         .data !=
                                          //                     null &&
                                          //                 !data
                                          //                     .mainScreenProvider
                                          //                     .blockedUsersIdList
                                          //                     .contains(element
                                          //                         .attributes!
                                          //                         .commentBy!
                                          //                         .data!
                                          //                         .id))
                                          //             .toList()),
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
                                        onTap: () {
                                          data.changeNewsReverse(
                                              isReverse: true);
                                        },
                                        textEditingController: widget
                                            .newsCommentTextEditingController,
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
                                          if (widget
                                              .newsCommentTextEditingController
                                              .text
                                              .trim()
                                              .isNotEmpty) {
                                            data.changeNewsReverse(
                                                isReverse: true);
                                            focusNode.unfocus();

                                            // await data.postNewsComment(
                                            //     newsPostSource:
                                            //         NewsPostSource.all,
                                            //     context: context,
                                            //     newsPostId:
                                            //         newsPost.id.toString(),
                                            //     newsCommentController: widget
                                            //         .newsCommentTextEditingController,
                                            //     setLikeSaveCommentFollow:
                                            //         false);
                                          }
                                        },
                                        borderRadius:
                                            SizeConfig.defaultSize * 1.5),
                                  ),
                                ],
                              ),
                            );
                    }
                }
              }),
        );
      },
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
