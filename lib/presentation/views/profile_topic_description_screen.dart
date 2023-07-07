import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/news_post_enum.dart';
import 'package:spa_app/data/enum/post_type.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/post_top_body.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/profile/profile_topic_comment_listview.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/news_liked_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

// ignore: must_be_immutable
class ProfileTopicDescriptionScreen extends StatefulWidget {
  final int newsPostId;
  final TextEditingController topicTextEditingController;
  StreamController<User>? otherUserStreamController;
  final bool scrollToBottom, isFocusTextField, isOtheruser;

  ProfileTopicDescriptionScreen(
      {Key? key,
      required this.isOtheruser,
      required this.newsPostId,
      required this.topicTextEditingController,
      this.otherUserStreamController,
      required this.scrollToBottom,
      required this.isFocusTextField})
      : super(key: key);

  @override
  State<ProfileTopicDescriptionScreen> createState() =>
      _ProfileTopicDescriptionScreenState();
}

class _ProfileTopicDescriptionScreenState
    extends State<ProfileTopicDescriptionScreen> {
  late FocusNode focusNode;

  @override
  void initState() {
    Provider.of<NewsAdProvider>(context, listen: false)
        .changeProfileTopicReverse(
            isReverse: widget.scrollToBottom, fromInitial: true);
    focusNode = FocusNode();
    if (widget.isFocusTextField == true) {
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
                Navigator.pop(context);
              },
            ),
            title: AppLocalizations.of(context).post,
          ),
          body: StreamBuilder<User?>(
              stream: data.mainScreenProvider.allProfileTopicController.stream,
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
                      final topicPost = snapshot.data!.createdPost!
                          .firstWhereOrNull(
                              (element) => element!.id == widget.newsPostId);
                      if (topicPost == null) {
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
                        final postedBy = snapshot.data;
                        final checkNewsPostSave = data
                                    .mainScreenProvider.savedNewsPostIdList
                                    .contains(widget.newsPostId) &&
                                topicPost.newsPostSaves != null
                            ? topicPost.newsPostSaves!.firstWhereOrNull(
                                (element) =>
                                    element!.savedBy != null &&
                                    element.savedBy!.id.toString() ==
                                        data.mainScreenProvider.userId
                                            .toString())
                            : null;
                        final checkNewsPostLike = data
                                    .mainScreenProvider.likedPostIdList
                                    .contains(widget.newsPostId) &&
                                topicPost.newsPostLikes != null
                            ? topicPost.newsPostLikes!.firstWhereOrNull(
                                (element) =>
                                    element!.likedBy != null &&
                                    element.likedBy!.id.toString() ==
                                        data.mainScreenProvider.userId
                                            .toString())
                            : null;
                        // blocked and deleted users won't be included
                        final totalLikeCountList = topicPost.newsPostLikes!
                            .where((element) =>
                                element != null &&
                                element.likedBy != null &&
                                !data.mainScreenProvider.blockedUsersIdList
                                    .contains(element.likedBy!.id))
                            .toList();
                        return data.mainScreenProvider.blockedUsersIdList
                                .contains(postedBy!.id)
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
                                        reverse: data.isProfileTopicReverse,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      SizeConfig.defaultSize),
                                              child: PostTopBody(
                                                  newsCommentTextEditingController: widget
                                                      .topicTextEditingController,
                                                  isOtherUserProfile:
                                                      widget.isOtheruser,
                                                  otherUserStreamController: widget
                                                      .otherUserStreamController,
                                                  isFromDescriptionScreen: true,
                                                  newsPostId: widget.newsPostId
                                                      .toString(),
                                                  commentOnPress: () {
                                                    data.changeProfileTopicReverse(
                                                        isReverse: true);
                                                    focusNode.requestFocus();
                                                  },
                                                  // postFromProfile = true denotes that the post is viewed from profile section. Two different image data type are made due to different result while fetching api from news post and user. If true, allPostImage will be used, else postImage will be used.
                                                  postFromProfile: true,
                                                  allPostImage: topicPost.image,
                                                  postedByOnPress: () {
                                                    if (postedBy.id !=
                                                        int.parse(data
                                                            .mainScreenProvider
                                                            .userId!)) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OtherUserProfileScreen(
                                                                    otherUserId:
                                                                        postedBy
                                                                            .id!,
                                                                  )));
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          MyProfileScreen.id);
                                                    }
                                                  },
                                                  postType:
                                                      PostType.profileTopic,
                                                  showLevel: true,
                                                  title: topicPost.title!,
                                                  userName: postedBy.username!,
                                                  postContent:
                                                      topicPost.content!,
                                                  postedTime: data.mainScreenProvider
                                                      .convertDateTimeToAgo(
                                                          topicPost.createdAt!,
                                                          context),
                                                  userImage:
                                                      postedBy.profileImage == null
                                                          ? null
                                                          : postedBy
                                                              .profileImage!
                                                              .url,
                                                  userType: data.getUserType(
                                                      usertType:
                                                          postedBy.userType ??
                                                              '',
                                                      context: context),
                                                  isSave: data.checkNewsPostSaveStatus(
                                                      postId: topicPost.id!),
                                                  saveOnPress: () async {
                                                    await data.toggleNewsPostSaveFromProfile(
                                                        newsPostSaveId:
                                                            checkNewsPostSave
                                                                ?.id
                                                                .toString(),
                                                        updateOnlyOneTopic:
                                                            false,
                                                        isMe: postedBy.id
                                                                    .toString() ==
                                                                data.mainScreenProvider
                                                                    .userId
                                                            ? true
                                                            : false,
                                                        postedById: postedBy.id
                                                            .toString(),
                                                        otherUserStreamController:
                                                            postedBy.id.toString() ==
                                                                    data.mainScreenProvider
                                                                        .userId
                                                                ? null
                                                                : widget
                                                                    .otherUserStreamController,
                                                        newsPostSource:
                                                            NewsPostSource
                                                                .profile,
                                                        context: context,
                                                        postId: topicPost.id
                                                            .toString(),
                                                        setLikeSaveCommentFollow:
                                                            false);
                                                  },
                                                  isLike: data.checkNewsPostLikeStatus(
                                                      postId: topicPost.id!),
                                                  likeOnPress: () async {
                                                    await data.toggleNewsPostLikeFromProfile(
                                                        updateOnlyOneTopic:
                                                            false,
                                                        isMe: postedBy.id.toString() ==
                                                                data
                                                                    .mainScreenProvider.userId
                                                            ? true
                                                            : false,
                                                        postedById: postedBy.id
                                                            .toString(),
                                                        otherUserStreamController:
                                                            postedBy.id.toString() ==
                                                                    data.mainScreenProvider
                                                                        .userId
                                                                ? null
                                                                : widget
                                                                    .otherUserStreamController,
                                                        newsPostSource: NewsPostSource
                                                            .profile,
                                                        context: context,
                                                        newsPostLikeId:
                                                            checkNewsPostLike?.id
                                                                .toString(),
                                                        postId: topicPost
                                                            .id
                                                            .toString(),
                                                        postLikeCount:
                                                            topicPost.newsPostLikes == null
                                                                ? 0
                                                                : totalLikeCountList
                                                                    .length,
                                                        setLikeSaveCommentFollow:
                                                            false);
                                                    // If we are working with different user, we will listen to it's streams which might have changed after performing this particular event.
                                                    if (postedBy.id
                                                            .toString() !=
                                                        data.mainScreenProvider
                                                            .userId) {
                                                      Provider.of<ProfileProvider>(
                                                              context,
                                                              listen: false)
                                                          .getOtherUserProfile(
                                                              otherUserStreamController:
                                                                  widget
                                                                      .otherUserStreamController!,
                                                              otherUserId:
                                                                  postedBy.id
                                                                      .toString(),
                                                              context: context);
                                                    }
                                                    data.getSelectedUserProfileTopics(
                                                        userId: postedBy.id
                                                            .toString(),
                                                        context: context);
                                                  },
                                                  hasLikes: topicPost.newsPostLikes == null
                                                      ? false
                                                      : totalLikeCountList.isNotEmpty,
                                                  seeLikesOnPress: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NewsLikedScreen(
                                                                  postId:
                                                                      topicPost
                                                                          .id!,
                                                                )));
                                                  },
                                                  likedAvtars: data.profileTopiclikedAvatars(likeCount: topicPost.newsPostLikes == null ? null : totalLikeCountList, isLike: data.mainScreenProvider.likedPostIdList.contains(topicPost.id)),
                                                  totalLikes: data.getLike(likeCount: topicPost.newsPostLikes == null ? 0 : totalLikeCountList.length, context: context)),
                                            ),
                                            // Topic comment
                                            ProfileTopicCommentListview(
                                                allComments: topicPost.comments ==
                                                        null
                                                    ? null
                                                    : topicPost.comments!
                                                        .where((element) =>
                                                            element != null &&
                                                            element.commentBy !=
                                                                null &&
                                                            !data
                                                                .mainScreenProvider
                                                                .blockedUsersIdList
                                                                .contains(element
                                                                    .commentBy!
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
                                            data.changeProfileTopicReverse(
                                                isReverse: true);
                                          },
                                          textEditingController:
                                              widget.topicTextEditingController,
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
                                                .topicTextEditingController.text
                                                .trim()
                                                .isNotEmpty) {
                                              data.changeProfileTopicReverse(
                                                  isReverse: true);
                                              focusNode.unfocus();
                                              await data.postNewsCommentFromProfile(
                                                  updateOnlyOneTopic: false,
                                                  isMe: postedBy.id.toString() ==
                                                          data.mainScreenProvider
                                                              .userId
                                                      ? true
                                                      : false,
                                                  postedById:
                                                      postedBy.id.toString(),
                                                  otherUserStreamController: postedBy
                                                              .id
                                                              .toString() ==
                                                          data.mainScreenProvider
                                                              .userId
                                                      ? null
                                                      : widget
                                                          .otherUserStreamController,
                                                  newsPostSource:
                                                      NewsPostSource.profile,
                                                  context: context,
                                                  newsPostId:
                                                      topicPost.id.toString(),
                                                  newsCommentController: widget
                                                      .topicTextEditingController,
                                                  setLikeSaveCommentFollow:
                                                      false);
                                              // // If we are working with different user, we will listen to it's streams which might have changed after performing this particular event.
                                              // if (postedBy.id.toString() !=
                                              //     data.mainScreenProvider.userId) {
                                              //   Provider.of<ProfileProvider>(
                                              //           context,
                                              //           listen: false)
                                              //       .getOtherUserProfile(
                                              //           otherUserStreamController: widget
                                              //               .otherUserStreamController!,
                                              //           otherUserId:
                                              //               postedBy.id.toString(),
                                              //           context: context);
                                              // }
                                              // data.getSelectedUserProfileTopics(
                                              //     userId: postedBy.id.toString(),
                                              //     context: context);
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
