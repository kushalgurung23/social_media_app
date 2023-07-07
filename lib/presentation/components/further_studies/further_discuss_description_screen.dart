import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/post_type.dart';
import 'package:spa_app/data/enum/user_type_enum.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/logic/providers/further_studies_provider.dart';
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

class FurtherStudiesDiscussDescriptionScreen extends StatefulWidget {
  final bool isParentAsk;
  final int newsPostId;
  final TextEditingController discussCommentTextEditingController;

  const FurtherStudiesDiscussDescriptionScreen({
    Key? key,
    required this.isParentAsk,
    required this.newsPostId,
    required this.discussCommentTextEditingController,
  }) : super(key: key);

  @override
  State<FurtherStudiesDiscussDescriptionScreen> createState() =>
      _FurtherStudiesDiscussDescriptionScreenState();
}

class _FurtherStudiesDiscussDescriptionScreenState
    extends State<FurtherStudiesDiscussDescriptionScreen> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    Provider.of<NewsAdProvider>(context, listen: false)
        .changeFurtherStudyReverse(isReverse: false, fromInitial: true);
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
              onPressed: () async {
                await Future.delayed(const Duration(seconds: 0), () {
                  focusNode.unfocus();
                  if (widget.discussCommentTextEditingController.text != '') {
                    widget.discussCommentTextEditingController.text = '';
                  }
                });
                Navigator.pop(context);
              },
            ),
            title: AppLocalizations.of(context).post,
          ),
          body: StreamBuilder<AllNewsPost>(
              stream: widget.isParentAsk
                  ? Provider.of<FurtherStudiesProvider>(context, listen: false)
                      .parentDiscussStreamController
                      .stream
                  : Provider.of<FurtherStudiesProvider>(context, listen: false)
                      .studentDiscussStreamController
                      .stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                        child: Text(
                      AppLocalizations.of(context).loading,
                      style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5,
                        color: Colors.black,
                      ),
                    ));
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

                        // List<CommentsData>? filteredAllComments = [];
                        // if (allComments != null && allComments.isNotEmpty) {
                        //   for (CommentsData commentData in allComments) {
                        //     NewsPostUser? commentBy =
                        //         commentData.attributes!.commentBy;
                        //     if ((commentBy == null || commentBy.data == null) ||
                        //         (!data.mainScreenProvider.blockedUsersIdList
                        //             .contains(commentData
                        //                 .attributes!.commentBy!.data!.id!))) {
                        //       filteredAllComments.add(CommentsData(
                        //           id: commentData.id,
                        //           attributes: CommentsAttributes(
                        //               content: commentData.attributes!.content,
                        //               createdAt:
                        //                   commentData.attributes!.createdAt,
                        //               updatedAt:
                        //                   commentData.attributes!.updatedAt,
                        //               publishedAt:
                        //                   commentData.attributes!.publishedAt,
                        //               commentBy: (commentBy != null &&
                        //                       commentBy.data != null)
                        //                   ? commentBy
                        //                   : NewsPostUser(
                        //                       data: UserData(
                        //                           id: null,
                        //                           attributes: UserAttributes(
                        //                               username: "(" +
                        //                                   AppLocalizations.of(
                        //                                           context)!
                        //                                       .deletedAccount +
                        //                                   ")",
                        //                               email: null,
                        //                               provider: null,
                        //                               confirmed: null,
                        //                               blocked: null,
                        //                               createdAt: null,
                        //                               updatedAt: null,
                        //                               userType: null,
                        //                               grade: null,
                        //                               teachingType: null,
                        //                               collegeType: null,
                        //                               teachingArea: null,
                        //                               region: null,
                        //                               category: null,
                        //                               profileImage: null,
                        //                               centerName: null,
                        //                               deviceToken: null,
                        //                               userFollower: null))))));
                        //     }
                        //   }
                        // }

                        return data.mainScreenProvider.blockedUsersIdList
                                .contains(postedById)
                            ? Center(
                                child: Text(
                                  "Content available",
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
                                        reverse: data.isFurtherStudyReverse,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      SizeConfig.defaultSize),
                                              child: PostTopBody(
                                                  newsCommentTextEditingController: widget
                                                      .discussCommentTextEditingController,
                                                  isOtherUserProfile: false,
                                                  isFromDescriptionScreen: true,
                                                  newsPostId: widget.newsPostId
                                                      .toString(),
                                                  commentOnPress: () {
                                                    data.changeFurtherStudyReverse(
                                                        isReverse: true);
                                                    focusNode.requestFocus();
                                                  },
                                                  postedByOnPress: () {
                                                    if (postedById !=
                                                        int.parse(data
                                                            .mainScreenProvider
                                                            .userId!)) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OtherUserProfileScreen(
                                                                    otherUserId:
                                                                        postedById!,
                                                                  )));
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          MyProfileScreen.id);
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
                                                  postedTime: data
                                                      .mainScreenProvider
                                                      .convertDateTimeToAgo(
                                                          newsPost.attributes!
                                                              .createdAt!,
                                                          context),
                                                  userImage:
                                                      postedBy.profileImage!.data == null
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
                                                    await data
                                                        .toggleNewsPostSaveFromFurtherStudies(
                                                            userType: (postedBy ==
                                                                    null)
                                                                ? UserType
                                                                    .deletedAccount
                                                                : (postedBy.userType! ==
                                                                        'Parent'
                                                                    ? UserType
                                                                        .parent
                                                                    : postedBy.userType! ==
                                                                            'Student'
                                                                        ? UserType
                                                                            .student
                                                                        : postedBy.userType! ==
                                                                                'Tutor'
                                                                            ? UserType
                                                                                .tutor
                                                                            : UserType
                                                                                .center),
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
                                                    await data
                                                        .toggleNewsPostLikeFromFurtherStudies(
                                                            userType: (postedBy ==
                                                                    null)
                                                                ? UserType
                                                                    .deletedAccount
                                                                : (postedBy.userType! ==
                                                                        'Parent'
                                                                    ? UserType
                                                                        .parent
                                                                    : postedBy.userType! ==
                                                                            'Student'
                                                                        ? UserType
                                                                            .student
                                                                        : postedBy.userType! ==
                                                                                'Tutor'
                                                                            ? UserType
                                                                                .tutor
                                                                            : UserType
                                                                                .center),
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
                                                allComments:
                                                    // ignore: prefer_null_aware_operators
                                                    allComments == null
                                                        ? null
                                                        : allComments
                                                            .where((element) =>
                                                                element.attributes != null &&
                                                                element
                                                                        .attributes!
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
                                            data.changeFurtherStudyReverse(
                                                isReverse: true);
                                          },
                                          textEditingController: widget
                                              .discussCommentTextEditingController,
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
                                                .discussCommentTextEditingController
                                                .text
                                                .trim()
                                                .isNotEmpty) {
                                              data.changeFurtherStudyReverse(
                                                  isReverse: true);
                                              focusNode.unfocus();
                                              await data
                                                  .postNewsCommentFromFurtherStudies(
                                                      userType: (postedBy ==
                                                              null)
                                                          ? UserType
                                                              .deletedAccount
                                                          : (postedBy.userType! ==
                                                                  'Parent'
                                                              ? UserType.parent
                                                              : postedBy.userType! ==
                                                                      'Student'
                                                                  ? UserType
                                                                      .student
                                                                  : postedBy.userType! ==
                                                                          'Tutor'
                                                                      ? UserType
                                                                          .tutor
                                                                      : UserType
                                                                          .center),
                                                      currentCommentCount:
                                                          newsPost
                                                              .attributes!
                                                              .comments!
                                                              .data!
                                                              .length
                                                              .toString(),
                                                      discussCommentCounts: newsPost
                                                          .attributes!
                                                          .discussCommentCounts,
                                                      context: context,
                                                      newsPostId: newsPost.id
                                                          .toString(),
                                                      newsCommentController: widget
                                                          .discussCommentTextEditingController,
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
                        child: Text(
                          AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context).dataCouldNotLoad,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
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
