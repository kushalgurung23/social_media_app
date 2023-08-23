import 'package:c_talent/data/new_models/all_news_posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/news_post_enum.dart';
import 'package:c_talent/data/enum/post_type.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/components/all/post_top_body.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/my_profile_screen.dart';
import 'package:c_talent/presentation/views/news_description_screen.dart';
import 'package:c_talent/presentation/views/news_liked_screen.dart';
import 'package:c_talent/presentation/views/other_user_profile_screen.dart';

class NewsPostContainer extends StatefulWidget {
  final NewsPost newsPost;
  final int index;
  const NewsPostContainer(
      {Key? key, required this.index, required this.newsPost})
      : super(key: key);

  @override
  State<NewsPostContainer> createState() => _NewsPostContainerState();
}

class _NewsPostContainerState extends State<NewsPostContainer>
    with AutomaticKeepAliveClientMixin {
  TextEditingController newsTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewsDescriptionScreen(
                              focusTextfield: false,
                              scrollToBottom: false,
                              newsPost: widget.newsPost,
                              newsCommentTextEditingController:
                                  newsTextEditingController,
                            )));
              },
              child: Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.defaultSize * 2,
                    top: widget.index == 0 ? SizeConfig.defaultSize : 0),
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.defaultSize,
                    horizontal: SizeConfig.defaultSize * 1.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFA08875).withOpacity(0.22),
                        offset: const Offset(0, 1),
                        blurRadius: 3)
                  ],
                  borderRadius:
                      BorderRadius.circular(SizeConfig.defaultSize * 2),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //News post upper body
                    PostTopBody(
                      newsCommentTextEditingController:
                          newsTextEditingController,
                      isOtherUserProfile: false,
                      isFromDescriptionScreen: false,
                      newsPostId: widget.newsPost.id.toString(),
                      postedByOnPress: () {
                        if (widget.newsPost.postedBy == null ||
                            widget.newsPost.postedBy?.id == null) {
                          return;
                        } else if (widget.newsPost.postedBy?.id !=
                            int.parse(data.mainScreenProvider.currentUserId
                                .toString())) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherUserProfileScreen(
                                        otherUserId: int.parse(widget
                                            .newsPost.postedBy!.id
                                            .toString()),
                                      )));
                        } else {
                          Navigator.pushNamed(context, MyProfileScreen.id);
                        }
                      },
                      commentOnPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDescriptionScreen(
                                      focusTextfield: true,
                                      scrollToBottom: true,
                                      newsPost: widget.newsPost,
                                      newsCommentTextEditingController:
                                          newsTextEditingController,
                                    )));
                      },
                      postType: PostType.newsPost,
                      showLevel: true,
                      title: widget.newsPost.title.toString(),
                      userName: widget.newsPost.postedBy?.username ?? 'User',
                      postContent: widget.newsPost.content.toString(),
                      postImage: widget.newsPost.images,
                      postedTime: widget.newsPost.createdAt == null
                          ? ''
                          : data.mainScreenProvider.convertDateTimeToAgo(
                              widget.newsPost.createdAt!, context),
                      userImage: widget.newsPost.postedBy?.profilePicture,
                      userType: data.getUserType(
                          userType: widget.newsPost.postedBy?.userType ?? '',
                          context: context),
                      isSave: widget.newsPost.isSaved == 1 ? true : false,
                      saveOnPress: () async {
                        // await data.toggleNewsPostSave(
                        //     newsPostSource: NewsPostSource.all,
                        //     newsPostSaveId:
                        //         widget.checkNewsPostSave?.id.toString(),
                        //     postId: widget.newsPost.id.toString(),
                        //     context: context,
                        //     setLikeSaveCommentFollow: false);
                      },
                      isLike: widget.newsPost.isLiked == 1 ? true : false,
                      likeOnPress: () async {
                        // await data.toggleNewsPostLike(
                        //     newsPostSource: NewsPostSource.all,
                        //     newsPostLikeId:
                        //         widget.checkNewsPostLike?.id.toString(),
                        //     postId: widget.newsPost.id.toString(),
                        //     postLikeCount: 0,
                        //     context: context,
                        //     setLikeSaveCommentFollow: false);
                      },
                      hasLikes: widget.newsPost.likesCount == null ||
                              widget.newsPost.likesCount! < 1
                          ? false
                          : true,
                      seeLikesOnPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsLikedScreen(
                                      postId: widget.newsPost.id!,
                                    )));
                      },
                      likedAvtars: data.likedAvatars(
                          likes: widget.newsPost.likes,
                          isLike: widget.newsPost.isLiked == 1 ? true : false),
                      totalLikes: data.getLike(
                        likeCount: widget.newsPost.likesCount ?? 0,
                        context: context,
                      ),
                    ),
                    // comment box
                    Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.defaultSize * 1.5),
                      child: RoundedTextFormField(
                          textEditingController: newsTextEditingController,
                          textInputType: TextInputType.text,
                          isEnable: true,
                          isReadOnly: false,
                          usePrefix: false,
                          useSuffix: true,
                          hintText: AppLocalizations.of(context).writeAComment,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.defaultSize * 0.2,
                                right: SizeConfig.defaultSize * 0.2),
                            child: SvgPicture.asset(
                              "assets/svg/post_comment.svg",

                              height: SizeConfig.defaultSize * 4,
                              width: SizeConfig.defaultSize * 4,
                              // color: Colors.white,
                            ),
                          ),
                          suffixOnPress: () async {
                            if (newsTextEditingController.text
                                .trim()
                                .isNotEmpty) {
                              // await data.postNewsComment(
                              //   newsPostSource: NewsPostSource.all,
                              //   context: context,
                              //   newsPostId: widget.newsPost.id.toString(),
                              //   newsCommentController:
                              //       widget.newsCommentTextEditingController,
                              //   setLikeSaveCommentFollow: false,
                              // );
                            }
                          },
                          borderRadius: SizeConfig.defaultSize * 1.5),
                    ),
                    widget.newsPost.comments != null &&
                            widget.newsPost.commentCount != null &&
                            widget.newsPost.commentCount! >= 1
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.defaultSize * 2),
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount:
                                    widget.newsPost.commentCount! >= 2 ? 2 : 1,
                                itemBuilder: (context, index) {
                                  final commentData = widget
                                      .newsPost.comments?.reversed
                                      .toList()[index];
                                  return commentData == null ||
                                          commentData.commentBy == null
                                      ? const SizedBox()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  SizeConfig.defaultSize * 0.6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                        child: Row(children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (commentData
                                                                  .commentBy
                                                                  ?.id !=
                                                              null) {
                                                            if (commentData
                                                                    .commentBy
                                                                    ?.id !=
                                                                int.parse(data
                                                                    .mainScreenProvider
                                                                    .currentUserId!)) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          OtherUserProfileScreen(
                                                                            otherUserId:
                                                                                commentData.commentBy!.id!,
                                                                          )));
                                                            } else {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  MyProfileScreen
                                                                      .id);
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          child: Text(
                                                            '${commentData.commentBy?.username} : ',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    kHelveticaMedium,
                                                                fontSize: SizeConfig
                                                                        .defaultSize *
                                                                    1.3,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            commentData.comment
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    kHelveticaRegular,
                                                                fontSize: SizeConfig
                                                                        .defaultSize *
                                                                    1.4)),
                                                      )
                                                    ])),
                                                    SizedBox(
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            1)
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                  commentData.createdAt == null
                                                      ? ''
                                                      : data.mainScreenProvider
                                                          .convertDateTimeToAgo(
                                                              commentData
                                                                  .createdAt!,
                                                              context),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaRegular,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.1)),
                                            ],
                                          ),
                                        );
                                }),
                          )
                        : SizedBox(
                            height: SizeConfig.defaultSize,
                          ),
                    widget.newsPost.commentCount != null &&
                            widget.newsPost.commentCount! > 2
                        ? Center(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsDescriptionScreen(
                                                focusTextfield: false,
                                                scrollToBottom: true,
                                                newsPost: widget.newsPost,
                                                newsCommentTextEditingController:
                                                    newsTextEditingController,
                                              )));
                                },
                                child: Text(
                                    widget.newsPost.commentCount != null &&
                                            widget.newsPost.commentCount! > 3
                                        ? "${AppLocalizations.of(context).seeOther} ${widget.newsPost.commentCount! - 2}\n${AppLocalizations.of(context).comments}\n..."
                                        : "${AppLocalizations.of(context).seeOther} ${widget.newsPost.commentCount! - 2}\n${AppLocalizations.of(context).comment}\n...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        color: const Color(0xFFA08875),
                                        fontSize:
                                            SizeConfig.defaultSize * 1.2))))
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    newsTextEditingController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
