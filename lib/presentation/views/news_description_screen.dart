import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/news_post_enum.dart';
import 'package:spa_app/data/enum/post_type.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/presentation/components/all/post_top_body.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/news/comment_listview.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/news_liked_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

class NewsDescriptionScreen extends StatefulWidget {
  final int newsPostId;
  final TextEditingController newsCommentTextEditingController;
  final bool scrollToBottom, focusTextfield;

  const NewsDescriptionScreen(
      {Key? key,
      this.focusTextfield = false,
      this.scrollToBottom = false,
      required this.newsPostId,
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
          body: StreamBuilder<AllNewsPost>(
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
                    if (snapshot.hasData) {
                      final newsPost = snapshot.data!.data!.firstWhereOrNull(
                          (element) => element.id == widget.newsPostId);
                      if (newsPost == null) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: Center(
                            child: Text(
                              "Content not available",
                              style: TextStyle(
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.5),
                            ),
                          ),
                        );
                      } else {
                        UserAttributes? postedBy;
                        int? postedById;
                        if (newsPost.attributes!.postedBy != null &&
                            newsPost.attributes!.postedBy!.data != null) {
                          postedBy =
                              newsPost.attributes!.postedBy!.data!.attributes!;
                          postedById = newsPost.attributes!.postedBy!.data!.id;
                        } else {
                          postedBy = UserAttributes(
                              username: "(" +
                                  AppLocalizations.of(context).deletedAccount +
                                  ")",
                              email: null,
                              provider: null,
                              confirmed: null,
                              blocked: null,
                              createdAt: null,
                              updatedAt: null,
                              userType: null,
                              grade: null,
                              teachingType: null,
                              collegeType: null,
                              teachingArea: null,
                              region: null,
                              category: null,
                              profileImage: null,
                              centerName: null,
                              deviceToken: null,
                              userFollower: null);
                        }

                        final checkNewsPostSave = data
                                    .mainScreenProvider.savedNewsPostIdList
                                    .contains(widget.newsPostId) &&
                                newsPost.attributes!.newsPostSaves!.data != null
                            ? newsPost.attributes!.newsPostSaves!.data!
                                .firstWhereOrNull((element) =>
                                    element!.attributes!.savedBy != null &&
                                    element.attributes!.savedBy!.data != null &&
                                    element.attributes!.savedBy!.data!.id
                                            .toString() ==
                                        data.mainScreenProvider.userId
                                            .toString())
                            : null;
                        final checkNewsPostLike = data
                                    .mainScreenProvider.likedPostIdList
                                    .contains(widget.newsPostId) &&
                                newsPost.attributes!.newsPostLikes!.data != null
                            ? newsPost.attributes!.newsPostLikes!.data!
                                .firstWhereOrNull((element) =>
                                    element!.attributes!.likedBy != null &&
                                    element.attributes!.likedBy!.data != null &&
                                    element.attributes!.likedBy!.data!.id
                                            .toString() ==
                                        data.mainScreenProvider.userId
                                            .toString())
                            : null;

                        List<CommentsData>? allComments =
                            newsPost.attributes!.comments!.data;

                        // blocked and deleted users won't be included
                        final totalLikeCountList = newsPost
                            .attributes!.newsPostLikes!.data!
                            .where((element) =>
                                element != null &&
                                element.attributes != null &&
                                element.attributes!.likedBy != null &&
                                element.attributes!.likedBy!.data != null &&
                                !data.mainScreenProvider.blockedUsersIdList
                                    .contains(
                                        element.attributes!.likedBy!.data!.id))
                            .toList();

                        return data.mainScreenProvider.blockedUsersIdList
                                .contains(postedById)
                            ? Center(
                                child: Text(
                                  "Content not available",
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize * 2),
                                child: Column(
                                  children: [
                                    Flexible(
                                      child: SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(
                                                parent:
                                                    BouncingScrollPhysics()),
                                        reverse: data.isNewsDescriptionReverse,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      SizeConfig.defaultSize),
                                              child: PostTopBody(
                                                  // isOtherUserProfile will be true only when we are viewing news post from other user's profile
                                                  isOtherUserProfile: false,
                                                  newsCommentTextEditingController: widget
                                                      .newsCommentTextEditingController,
                                                  isFromDescriptionScreen: true,
                                                  newsPostId:
                                                      newsPost.id.toString(),
                                                  commentOnPress: () {
                                                    data.changeNewsReverse(
                                                        isReverse: true);
                                                    focusNode.requestFocus();
                                                  },
                                                  postedByOnPress: () {
                                                    if (postedById != null) {
                                                      if (postedById !=
                                                          int.parse(data
                                                              .mainScreenProvider
                                                              .userId!)) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OtherUserProfileScreen(
                                                                          otherUserId:
                                                                              postedById!,
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
                                                  title: newsPost
                                                      .attributes!.title!,
                                                  userName: postedBy.username!,
                                                  postContent: newsPost
                                                      .attributes!.content!,
                                                  postImage:
                                                      newsPost.attributes!.image!.data == null
                                                          ? null
                                                          : newsPost.attributes!
                                                              .image!.data!,
                                                  postedTime: data.mainScreenProvider
                                                      .convertDateTimeToAgo(
                                                          newsPost.attributes!
                                                              .createdAt!,
                                                          context),
                                                  userImage:
                                                      (postedBy.profileImage == null || postedBy.profileImage!.data == null)
                                                          ? null
                                                          : postedBy
                                                              .profileImage!
                                                              .data!
                                                              .attributes!
                                                              .url,
                                                  userType: data.getUserType(
                                                      usertType: postedBy.userType ?? '',
                                                      context: context),
                                                  isSave: data.checkNewsPostSaveStatus(postId: newsPost.id!),
                                                  saveOnPress: () async {
                                                    await data.toggleNewsPostSave(
                                                        newsPostSource:
                                                            NewsPostSource.all,
                                                        newsPostSaveId:
                                                            checkNewsPostSave
                                                                ?.id
                                                                .toString(),
                                                        postId: newsPost.id
                                                            .toString(),
                                                        context: context,
                                                        setLikeSaveCommentFollow:
                                                            false);
                                                  },
                                                  isLike: data.checkNewsPostLikeStatus(postId: newsPost.id!),
                                                  likeOnPress: () async {
                                                    await data.toggleNewsPostLike(
                                                        newsPostSource:
                                                            NewsPostSource.all,
                                                        newsPostLikeId:
                                                            checkNewsPostLike
                                                                ?.id
                                                                .toString(),
                                                        postId: newsPost.id
                                                            .toString(),
                                                        postLikeCount: newsPost
                                                                        .attributes!
                                                                        .newsPostLikes ==
                                                                    null ||
                                                                newsPost
                                                                        .attributes!
                                                                        .newsPostLikes!
                                                                        .data ==
                                                                    null
                                                            ? 0
                                                            : totalLikeCountList
                                                                .length,
                                                        context: context,
                                                        setLikeSaveCommentFollow:
                                                            false);
                                                  },
                                                  hasLikes: newsPost.attributes!.newsPostLikes == null || newsPost.attributes!.newsPostLikes!.data == null ? false : totalLikeCountList.isNotEmpty,
                                                  seeLikesOnPress: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewsLikedScreen(
                                                                  postId: widget
                                                                      .newsPostId,
                                                                )));
                                                  },
                                                  likedAvtars: data.likedAvatars(likeCount: newsPost.attributes!.newsPostLikes == null || newsPost.attributes!.newsPostLikes!.data == null ? null : totalLikeCountList, isLike: data.mainScreenProvider.likedPostIdList.contains(newsPost.id)),
                                                  totalLikes: data.getLike(likeCount: newsPost.attributes!.newsPostLikes == null || newsPost.attributes!.newsPostLikes!.data == null ? 0 : totalLikeCountList.length, context: context)),
                                            ),
                                            // News comment
                                            CommentListview(
                                                fromProfileTopic: false,
                                                // ignore: prefer_null_aware_operators
                                                allComments: allComments == null
                                                    ? null
                                                    : allComments
                                                        .where((element) =>
                                                            element.attributes != null &&
                                                            element.attributes!
                                                                    .commentBy !=
                                                                null &&
                                                            element
                                                                    .attributes!
                                                                    .commentBy!
                                                                    .data !=
                                                                null &&
                                                            !data
                                                                .mainScreenProvider
                                                                .blockedUsersIdList
                                                                .contains(element
                                                                    .attributes!
                                                                    .commentBy!
                                                                    .data!
                                                                    .id))
                                                        .toList()),
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
                                                top: SizeConfig.defaultSize *
                                                    0.2,
                                                right: SizeConfig.defaultSize *
                                                    0.2),
                                            child: SvgPicture.asset(
                                              "assets/svg/post_comment.svg",
                                              height:
                                                  SizeConfig.defaultSize * 4,
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

                                              await data.postNewsComment(
                                                  newsPostSource:
                                                      NewsPostSource.all,
                                                  context: context,
                                                  newsPostId:
                                                      newsPost.id.toString(),
                                                  newsCommentController: widget
                                                      .newsCommentTextEditingController,
                                                  setLikeSaveCommentFollow:
                                                      false);
                                            }
                                          },
                                          borderRadius:
                                              SizeConfig.defaultSize * 1.5),
                                    ),
                                  ],
                                ),
                              );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(AppLocalizations.of(context).errorOccured,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5)),
                      );
                    } else {
                      return Center(
                        child: Text(
                            AppLocalizations.of(context).newsCouldNotLoad,
                            style: TextStyle(
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5)),
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
