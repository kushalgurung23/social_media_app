import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/enum/news_post_enum.dart';
import 'package:c_talent/data/enum/post_type.dart';
import 'package:c_talent/data/models/all_news_post_model.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/logic/providers/profile_provider.dart';
import 'package:c_talent/presentation/components/all/post_top_body.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/news/comment_listview.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/news_liked_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

// Last topic and bookmark topic
// ignore: must_be_immutable
class LastBookmarkTopicDescriptionScreen extends StatefulWidget {
  // If we are trying to update other user profile, it will be true
  final bool isOtherUser;
  final int? otherUserId;
  StreamController<User>? otherUserStreamController;
  final String topicId;
  final TextEditingController newsCommentTextEditingController;

  LastBookmarkTopicDescriptionScreen(
      {Key? key,
      this.otherUserStreamController,
      this.isOtherUser = false,
      this.otherUserId,
      required this.topicId,
      required this.newsCommentTextEditingController})
      : super(key: key);

  @override
  State<LastBookmarkTopicDescriptionScreen> createState() =>
      _LastBookmarkTopicDescriptionScreenState();
}

class _LastBookmarkTopicDescriptionScreenState
    extends State<LastBookmarkTopicDescriptionScreen> {
  late FocusNode focusNode;
  bool isLoaded = false;
  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
    final newsAdProvider = Provider.of<NewsAdProvider>(context, listen: false);
    newsAdProvider.changeLastBookmarkTopicReverse(
        isReverse: false, fromInitial: true);
    loadLastBookmarkTopic();
  }

  void loadLastBookmarkTopic() async {
    await Provider.of<NewsAdProvider>(context, listen: false)
        .getOneProfileTopic(topicId: widget.topicId, context: context);
    setState(() {
      isLoaded = true;
    });
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
                final profileProvider =
                    Provider.of<ProfileProvider>(context, listen: false);
                if (profileProvider.profileTopicTextEditingController.text !=
                    '') {
                  profileProvider.profileTopicTextEditingController.clear();
                }
                Navigator.pop(context);
              },
            ),
            title: AppLocalizations.of(context).post,
          ),
          body: isLoaded == false
              ? Center(
                  child: Text(
                    AppLocalizations.of(context).loading,
                    style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5),
                  ),
                )
              : StreamBuilder<NewsPost?>(
                  stream: data.mainScreenProvider
                      .profileNewsTopicStreamController.stream,
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
                        if (snapshot.data == null) {
                          return Center(
                            child: Text(
                              "Content not available",
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
                          NewsPost? newsPost = snapshot.data;
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
                              postedBy = newsPost
                                  .attributes!.postedBy!.data!.attributes!;
                              postedById =
                                  newsPost.attributes!.postedBy!.data!.id;
                            } else {
                              postedBy = UserAttributes(
                                  username:
                                      "(${AppLocalizations.of(context).deletedAccount})",
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
                                        .contains(newsPost.id) &&
                                    newsPost.attributes!.newsPostSaves != null
                                ? newsPost.attributes!.newsPostSaves!.data!
                                    .firstWhereOrNull((element) =>
                                        element!.attributes!.savedBy != null &&
                                        element.attributes!.savedBy!.data !=
                                            null &&
                                        element.attributes!.savedBy!.data!.id
                                                .toString() ==
                                            data.mainScreenProvider.userId
                                                .toString())
                                : null;
                            final checkNewsPostLike = data
                                        .mainScreenProvider.likedPostIdList
                                        .contains(newsPost.id) &&
                                    newsPost.attributes!.newsPostLikes!.data !=
                                        null
                                ? newsPost.attributes!.newsPostLikes!.data!
                                    .firstWhereOrNull((element) =>
                                        element!.attributes!.likedBy != null &&
                                        element.attributes!.likedBy!.data !=
                                            null &&
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
                                        .contains(element
                                            .attributes!.likedBy!.data!.id))
                                .toList();

                            return data.mainScreenProvider.blockedUsersIdList
                                    .contains(postedById)
                                ? Center(
                                    child: Text(
                                      "Content not available",
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5),
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
                                            reverse:
                                                data.isLastBookmarkTopicReverse,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: SizeConfig
                                                          .defaultSize),
                                                  child: PostTopBody(
                                                    newsCommentTextEditingController:
                                                        widget
                                                            .newsCommentTextEditingController,
                                                    isOtherUserProfile:
                                                        widget.isOtherUser,
                                                    otherUserStreamController:
                                                        widget
                                                            .otherUserStreamController,
                                                    isFromDescriptionScreen:
                                                        true,
                                                    newsPostId: widget.topicId,
                                                    commentOnPress: () {
                                                      data.changeLastBookmarkTopicReverse(
                                                          isReverse: true);
                                                      focusNode.requestFocus();
                                                    },
                                                    postedByOnPress: () {
                                                      data.profileUserOnPress(
                                                          commentById: newsPost
                                                              .attributes!
                                                              .postedBy!
                                                              .data!
                                                              .id!,
                                                          context: context);
                                                    },
                                                    postType:
                                                        PostType.profileTopic,
                                                    showLevel: true,
                                                    title: newsPost
                                                        .attributes!.title!,
                                                    userName:
                                                        postedBy.username!,
                                                    postContent: newsPost
                                                        .attributes!.content!,
                                                    postImage: newsPost
                                                                .attributes!
                                                                .image!
                                                                .data ==
                                                            null
                                                        ? null
                                                        : newsPost.attributes!
                                                            .image!.data!,
                                                    postedTime: data
                                                        .mainScreenProvider
                                                        .convertDateTimeToAgo(
                                                            newsPost.attributes!
                                                                .createdAt!,
                                                            context),
                                                    userImage: postedBy
                                                                .profileImage!
                                                                .data ==
                                                            null
                                                        ? null
                                                        : postedBy
                                                            .profileImage!
                                                            .data!
                                                            .attributes!
                                                            .url,
                                                    userType: data.getUserType(
                                                        usertType:
                                                            postedBy.userType ??
                                                                '',
                                                        context: context),
                                                    isSave: data
                                                        .checkNewsPostSaveStatus(
                                                            postId:
                                                                newsPost.id!),
                                                    saveOnPress: () async {
                                                      await data.toggleNewsPostSaveFromProfile(
                                                          newsPostSaveId:
                                                              checkNewsPostSave?.id
                                                                  .toString(),
                                                          updateOnlyOneTopic:
                                                              true,
                                                          isMe:
                                                              widget.isOtherUser ==
                                                                      true
                                                                  ? false
                                                                  : true,
                                                          postedById: newsPost
                                                              .attributes!
                                                              .postedBy!
                                                              .data!
                                                              .id
                                                              .toString(),
                                                          otherUserStreamController:
                                                              widget.isOtherUser ==
                                                                      true
                                                                  ? widget
                                                                      .otherUserStreamController
                                                                  : null,
                                                          newsPostSource:
                                                              NewsPostSource
                                                                  .profile,
                                                          context: context,
                                                          postId:
                                                              widget.topicId,
                                                          setLikeSaveCommentFollow:
                                                              false);
                                                    },
                                                    isLike: data
                                                        .checkNewsPostLikeStatus(
                                                            postId:
                                                                newsPost.id!),
                                                    likeOnPress: () async {
                                                      await data.toggleNewsPostLikeFromProfile(
                                                          updateOnlyOneTopic:
                                                              true,
                                                          isMe: widget.isOtherUser == true
                                                              ? false
                                                              : true,
                                                          postedById: newsPost
                                                              .attributes!
                                                              .postedBy!
                                                              .data!
                                                              .id
                                                              .toString(),
                                                          otherUserStreamController:
                                                              widget.isOtherUser == true
                                                                  ? widget
                                                                      .otherUserStreamController
                                                                  : null,
                                                          newsPostSource:
                                                              NewsPostSource
                                                                  .profile,
                                                          context: context,
                                                          newsPostLikeId:
                                                              checkNewsPostLike?.id
                                                                  .toString(),
                                                          postId: newsPost.id
                                                              .toString(),
                                                          postLikeCount: newsPost
                                                                          .attributes!
                                                                          .newsPostLikes ==
                                                                      null ||
                                                                  newsPost.attributes!.newsPostLikes!.data == null
                                                              ? 0
                                                              : totalLikeCountList.length,
                                                          setLikeSaveCommentFollow: false);
                                                    },
                                                    hasLikes: newsPost
                                                                    .attributes!
                                                                    .newsPostLikes ==
                                                                null ||
                                                            newsPost
                                                                    .attributes!
                                                                    .newsPostLikes!
                                                                    .data ==
                                                                null
                                                        ? false
                                                        : totalLikeCountList
                                                            .isNotEmpty,
                                                    seeLikesOnPress: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  NewsLikedScreen(
                                                                    postId: int
                                                                        .parse(widget
                                                                            .topicId),
                                                                  )));
                                                    },
                                                    likedAvtars: data.likedAvatars(
                                                        likeCount: newsPost
                                                                        .attributes!
                                                                        .newsPostLikes ==
                                                                    null ||
                                                                newsPost
                                                                        .attributes!
                                                                        .newsPostLikes!
                                                                        .data ==
                                                                    null
                                                            ? null
                                                            : totalLikeCountList,
                                                        isLike: data
                                                            .mainScreenProvider
                                                            .likedPostIdList
                                                            .contains(
                                                                newsPost.id)),
                                                    totalLikes: data.getLike(
                                                        likeCount: newsPost
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
                                                        context: context),
                                                  ),
                                                ),
                                                // Last and bookmark topics' comment
                                                CommentListview(
                                                    fromProfileTopic: true,
                                                    // ignore: prefer_null_aware_operators
                                                    allComments: allComments ==
                                                            null
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
                                              vertical:
                                                  SizeConfig.defaultSize * 2),
                                          child: RoundedTextFormField(
                                              focusNode: focusNode,
                                              onTap: () {
                                                data.changeLastBookmarkTopicReverse(
                                                    isReverse: true);
                                              },
                                              textEditingController: widget
                                                  .newsCommentTextEditingController,
                                              textInputType: TextInputType.text,
                                              isEnable: true,
                                              isReadOnly: false,
                                              usePrefix: false,
                                              useSuffix: true,
                                              hintText:
                                                  AppLocalizations.of(context)
                                                      .writeAComment,
                                              suffixIcon: Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        SizeConfig.defaultSize *
                                                            0.2,
                                                    right:
                                                        SizeConfig.defaultSize *
                                                            0.2),
                                                child: SvgPicture.asset(
                                                  "assets/svg/post_comment.svg",
                                                  height:
                                                      SizeConfig.defaultSize *
                                                          4,
                                                  width:
                                                      SizeConfig.defaultSize *
                                                          4,
                                                ),
                                              ),
                                              suffixOnPress: () async {
                                                if (widget
                                                    .newsCommentTextEditingController
                                                    .text
                                                    .trim()
                                                    .isNotEmpty) {
                                                  data.changeLastBookmarkTopicReverse(
                                                      isReverse: true);
                                                  focusNode.unfocus();
                                                  await data.postNewsCommentFromProfile(
                                                      updateOnlyOneTopic: true,
                                                      isMe:
                                                          widget.isOtherUser == true
                                                              ? false
                                                              : true,
                                                      postedById: newsPost
                                                          .attributes!
                                                          .postedBy!
                                                          .data!
                                                          .id
                                                          .toString(),
                                                      otherUserStreamController:
                                                          widget.isOtherUser ==
                                                                  true
                                                              ? widget
                                                                  .otherUserStreamController
                                                              : null,
                                                      newsPostSource:
                                                          NewsPostSource
                                                              .profile,
                                                      context: context,
                                                      newsPostId:
                                                          widget.topicId,
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
