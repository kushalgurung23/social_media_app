import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/news_post_enum.dart';
import 'package:spa_app/data/enum/post_type.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/presentation/components/all/post_top_body.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/news_liked_screen.dart';
import 'package:spa_app/presentation/views/profile_topic_description_screen.dart';

// ignore: must_be_immutable
class AllProfileTopicList extends StatefulWidget {
  final bool isOtherUser;
  final String userId;
  StreamController<User>? otherUserStreamController;

  AllProfileTopicList(
      {Key? key,
      required this.userId,
      this.otherUserStreamController,
      required this.isOtherUser})
      : super(key: key);

  @override
  State<AllProfileTopicList> createState() => _AllProfileTopicListState();
}

class _AllProfileTopicListState extends State<AllProfileTopicList> {
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final newsAdProvider = Provider.of<NewsAdProvider>(context, listen: false);
    await newsAdProvider.getSelectedUserProfileTopics(
        userId: widget.userId, context: context);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: AppLocalizations.of(context).createdPost,
      ),
      body: isLoaded == false
          ? Center(
              child: Text(
                AppLocalizations.of(context).loading,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: kHelveticaRegular,
                    fontSize: SizeConfig.defaultSize * 1.5),
              ),
            )
          : Consumer<NewsAdProvider>(
              builder: (context, data, child) {
                return StreamBuilder<User?>(
                  stream:
                      data.mainScreenProvider.allProfileTopicController.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(
                          child: Text(
                            AppLocalizations.of(context).loading,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: kHelveticaRegular,
                                fontSize: SizeConfig.defaultSize * 1.5),
                          ),
                        );
                      case ConnectionState.done:
                      default:
                        if (snapshot.hasData) {
                          return snapshot.data!.createdPost!.isEmpty &&
                                  snapshot.data!.createdPost!.length < 2 - 1
                              ? Center(
                                  child: Text(
                                  AppLocalizations.of(context).noPostCreatedYet,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ))
                              : ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: snapshot.data!.createdPost!.length,
                                  itemBuilder: (context, index) {
                                    final sortedList =
                                        snapshot.data!.createdPost!;
                                    sortedList.sort(((a, b) => a!.createdAt!
                                        .compareTo(b!.createdAt!)));
                                    // Topic post
                                    final createdPost =
                                        sortedList.reversed.toList()[index];

                                    final postedBy = snapshot.data;
                                    List<UserComment?>? allComments =
                                        createdPost!.comments!
                                            .where((element) =>
                                                element != null &&
                                                element.commentBy != null &&
                                                !data.mainScreenProvider
                                                    .blockedUsersIdList
                                                    .contains(
                                                        element.commentBy!.id))
                                            .toList();

                                    if (data.profileNewsCommentControllerList
                                            .length !=
                                        sortedList.length) {
                                      if (data.profileNewsCommentControllerList
                                              .length <
                                          sortedList.length) {
                                        data.profileNewsCommentControllerList
                                            .add(TextEditingController());
                                      } else if (data
                                              .profileNewsCommentControllerList
                                              .length >
                                          sortedList.length) {
                                        data.profileNewsCommentControllerList
                                            .clear();
                                        data.profileNewsCommentControllerList
                                            .add(TextEditingController());
                                      }
                                    }
                                    final checkNewsPostSave = data
                                                .mainScreenProvider
                                                .savedNewsPostIdList
                                                .contains(createdPost.id) &&
                                            createdPost.newsPostSaves != null
                                        ? createdPost.newsPostSaves!
                                            .firstWhereOrNull((element) =>
                                                element!.savedBy != null &&
                                                element.savedBy!.id
                                                        .toString() ==
                                                    data.mainScreenProvider
                                                        .userId
                                                        .toString())
                                        : null;
                                    final checkNewsPostLike = data
                                                .mainScreenProvider
                                                .likedPostIdList
                                                .contains(createdPost.id) &&
                                            createdPost.newsPostLikes != null
                                        ? createdPost.newsPostLikes!
                                            .firstWhereOrNull((element) =>
                                                element!.likedBy != null &&
                                                element.likedBy!.id
                                                        .toString() ==
                                                    data.mainScreenProvider
                                                        .userId
                                                        .toString())
                                        : null;
                                    // blocked and deleted users won't be included
                                    final totalLikeCountList = createdPost
                                        .newsPostLikes!
                                        .where((element) =>
                                            element != null &&
                                            element.likedBy != null &&
                                            !data.mainScreenProvider
                                                .blockedUsersIdList
                                                .contains(element.likedBy!.id))
                                        .toList();
                                    return data.mainScreenProvider
                                            .blockedUsersIdList
                                            .contains(postedBy!.id)
                                        ? Center(
                                            child: Text(
                                            "No content available",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: kHelveticaRegular,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.5),
                                          ))
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    SizeConfig.defaultSize * 2),
                                            child: Column(
                                              children: [
                                                index == 0
                                                    ? SizedBox(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            2)
                                                    : const SizedBox(),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileTopicDescriptionScreen(
                                                                  isOtheruser:
                                                                      widget
                                                                          .isOtherUser,
                                                                  isFocusTextField:
                                                                      false,
                                                                  scrollToBottom:
                                                                      false,
                                                                  newsPostId:
                                                                      createdPost
                                                                          .id!,
                                                                  topicTextEditingController:
                                                                      data.profileNewsCommentControllerList[
                                                                          index],
                                                                  otherUserStreamController:
                                                                      widget
                                                                          .otherUserStreamController,
                                                                )));
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: SizeConfig
                                                                .defaultSize *
                                                            2),
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: SizeConfig
                                                            .defaultSize,
                                                        horizontal: SizeConfig
                                                                .defaultSize *
                                                            1.5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: const Color(
                                                                    0xFFA08875)
                                                                .withOpacity(
                                                                    0.22),
                                                            offset:
                                                                const Offset(
                                                                    0, 1),
                                                            blurRadius: 3)
                                                      ],
                                                      borderRadius: BorderRadius
                                                          .circular(SizeConfig
                                                                  .defaultSize *
                                                              2),
                                                    ),
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        //Profile post upper body
                                                        PostTopBody(
                                                            newsCommentTextEditingController:
                                                                data.profileNewsCommentControllerList[
                                                                    index],
                                                            otherUserStreamController:
                                                                widget.isOtherUser == true
                                                                    ? widget
                                                                        .otherUserStreamController
                                                                    : null,
                                                            isOtherUserProfile: widget
                                                                .isOtherUser,
                                                            isFromDescriptionScreen:
                                                                false,
                                                            newsPostId:
                                                                createdPost.id
                                                                    .toString(),
                                                            commentOnPress: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProfileTopicDescriptionScreen(
                                                                            isOtheruser:
                                                                                widget.isOtherUser,
                                                                            isFocusTextField:
                                                                                true,
                                                                            scrollToBottom:
                                                                                true,
                                                                            newsPostId:
                                                                                createdPost.id!,
                                                                            topicTextEditingController:
                                                                                data.profileNewsCommentControllerList[index],
                                                                            otherUserStreamController:
                                                                                widget.otherUserStreamController,
                                                                          )));
                                                            },
                                                            // postFromProfile = true denotes that the post is viewed from profile section. Two different image data type are made due to different result while fetching api from news post and user. If true, allPostImage will be used, else postImage will be used.
                                                            postFromProfile:
                                                                true,
                                                            allPostImage: createdPost
                                                                .image,
                                                            postedByOnPress:
                                                                () {
                                                              data.profileUserOnPress(
                                                                  commentById:
                                                                      postedBy
                                                                          .id!,
                                                                  context:
                                                                      context);
                                                            },
                                                            postType: PostType
                                                                .profileTopic,
                                                            showLevel: true,
                                                            title: createdPost
                                                                .title!,
                                                            userName: postedBy
                                                                .username!,
                                                            postContent: createdPost
                                                                .content!,
                                                            postedTime: data
                                                                .mainScreenProvider
                                                                .convertDateTimeToAgo(
                                                                    createdPost
                                                                        .createdAt!,
                                                                    context),
                                                            userImage: postedBy.profileImage == null
                                                                ? null
                                                                : postedBy
                                                                    .profileImage!
                                                                    .url,
                                                            userType: data.getUserType(
                                                                usertType: postedBy.userType ?? '',
                                                                context: context),
                                                            isSave: data.checkNewsPostSaveStatus(postId: createdPost.id!),
                                                            saveOnPress: () async {
                                                              await data.toggleNewsPostSaveFromProfile(
                                                                  newsPostSaveId:
                                                                      checkNewsPostSave?.id
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
                                                                      postedBy.id.toString() == data.mainScreenProvider.userId
                                                                          ? null
                                                                          : widget
                                                                              .otherUserStreamController,
                                                                  newsPostSource:
                                                                      NewsPostSource
                                                                          .profile,
                                                                  context:
                                                                      context,
                                                                  postId: createdPost
                                                                      .id
                                                                      .toString(),
                                                                  setLikeSaveCommentFollow:
                                                                      false);
                                                            },
                                                            isLike: data.checkNewsPostLikeStatus(postId: createdPost.id!),
                                                            likeOnPress: () async {
                                                              await data.toggleNewsPostLikeFromProfile(
                                                                  updateOnlyOneTopic:
                                                                      false,
                                                                  isMe: postedBy.id.toString() == data.mainScreenProvider.userId
                                                                      ? true
                                                                      : false,
                                                                  postedById:
                                                                      postedBy.id
                                                                          .toString(),
                                                                  otherUserStreamController:
                                                                      postedBy.id.toString() == data.mainScreenProvider.userId
                                                                          ? null
                                                                          : widget
                                                                              .otherUserStreamController,
                                                                  newsPostSource:
                                                                      NewsPostSource
                                                                          .profile,
                                                                  context:
                                                                      context,
                                                                  newsPostLikeId:
                                                                      checkNewsPostLike
                                                                          ?.id
                                                                          .toString(),
                                                                  postId: createdPost
                                                                      .id
                                                                      .toString(),
                                                                  postLikeCount:
                                                                      createdPost.newsPostLikes == null
                                                                          ? 0
                                                                          : totalLikeCountList
                                                                              .length,
                                                                  setLikeSaveCommentFollow:
                                                                      false);
                                                            },
                                                            hasLikes: createdPost.newsPostLikes == null ? false : totalLikeCountList.isNotEmpty,
                                                            seeLikesOnPress: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          NewsLikedScreen(
                                                                            postId:
                                                                                createdPost.id!,
                                                                          )));
                                                            },
                                                            likedAvtars: data.profileTopiclikedAvatars(likeCount: createdPost.newsPostLikes == null ? null : totalLikeCountList, isLike: data.mainScreenProvider.likedPostIdList.contains(createdPost.id)),
                                                            totalLikes: data.getLike(likeCount: createdPost.newsPostLikes == null ? 0 : totalLikeCountList.length, context: context)),
                                                        // comment box
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: SizeConfig
                                                                      .defaultSize *
                                                                  1.5),
                                                          child:
                                                              RoundedTextFormField(
                                                                  textEditingController:
                                                                      data.profileNewsCommentControllerList[
                                                                          index],
                                                                  textInputType:
                                                                      TextInputType
                                                                          .text,
                                                                  isEnable:
                                                                      true,
                                                                  isReadOnly:
                                                                      false,
                                                                  usePrefix:
                                                                      false,
                                                                  useSuffix:
                                                                      true,
                                                                  hintText: AppLocalizations.of(
                                                                          context)
                                                                      .writeAComment,
                                                                  suffixIcon:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: SizeConfig.defaultSize *
                                                                            0.2,
                                                                        right: SizeConfig.defaultSize *
                                                                            0.2),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "assets/svg/post_comment.svg",
                                                                      height:
                                                                          SizeConfig.defaultSize *
                                                                              4,

                                                                      width:
                                                                          SizeConfig.defaultSize *
                                                                              4,
                                                                      // color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  suffixOnPress:
                                                                      () async {
                                                                    if (data.profileNewsCommentControllerList[index]
                                                                            .text !=
                                                                        '') {
                                                                      await data.postNewsCommentFromProfile(
                                                                          updateOnlyOneTopic:
                                                                              false,
                                                                          isMe: postedBy.id.toString() == data.mainScreenProvider.userId
                                                                              ? true
                                                                              : false,
                                                                          postedById: postedBy
                                                                              .id
                                                                              .toString(),
                                                                          otherUserStreamController: postedBy.id.toString() == data.mainScreenProvider.userId
                                                                              ? null
                                                                              : widget
                                                                                  .otherUserStreamController,
                                                                          newsPostSource: NewsPostSource
                                                                              .profile,
                                                                          context:
                                                                              context,
                                                                          newsPostId: createdPost
                                                                              .id
                                                                              .toString(),
                                                                          newsCommentController: data.profileNewsCommentControllerList[
                                                                              index],
                                                                          setLikeSaveCommentFollow:
                                                                              false);
                                                                    }
                                                                  },
                                                                  borderRadius:
                                                                      SizeConfig
                                                                              .defaultSize *
                                                                          1.5),
                                                        ),
                                                        SizedBox(
                                                          child:
                                                              allComments
                                                                      .isEmpty
                                                                  ? SizedBox(
                                                                      height: SizeConfig
                                                                          .defaultSize,
                                                                    )
                                                                  : Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: SizeConfig.defaultSize *
                                                                              2),
                                                                      child: ListView.builder(
                                                                          shrinkWrap: true,
                                                                          primary: false,
                                                                          itemCount: allComments.length >= 2 ? 2 : 1,
                                                                          itemBuilder: (context, index) {
                                                                            allComments.sort((a, b) =>
                                                                                a!.createdAt!.compareTo(b!.createdAt!));
                                                                            final commentData = allComments.length > 2
                                                                                ? allComments[(allComments.length - 2) + index]
                                                                                : allComments[index];
                                                                            return commentData!.commentBy == null || (commentData.commentBy != null && data.mainScreenProvider.blockedUsersIdList.contains(commentData.commentBy!.id))
                                                                                ? const SizedBox()
                                                                                : Padding(
                                                                                    padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 0.6),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Flexible(
                                                                                                  child: Row(children: [
                                                                                                GestureDetector(
                                                                                                  onTap: () {
                                                                                                    data.profileUserOnPress(commentById: commentData.commentBy!.id!, context: context);
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    color: Colors.transparent,
                                                                                                    child: Text(
                                                                                                      '${commentData.commentBy!.username} : ',
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: TextStyle(fontFamily: kHelveticaMedium, fontSize: SizeConfig.defaultSize * 1.3, color: Colors.black),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                Expanded(
                                                                                                  child: Text(commentData.content.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: kHelveticaRegular, fontSize: SizeConfig.defaultSize * 1.4)),
                                                                                                )
                                                                                              ])),
                                                                                              SizedBox(width: SizeConfig.defaultSize * 1)
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        Text(data.mainScreenProvider.convertDateTimeToAgo(commentData.createdAt!, context), style: TextStyle(fontFamily: kHelveticaRegular, fontSize: SizeConfig.defaultSize * 1.1)),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                          }),
                                                                    ),
                                                        ),
                                                        allComments.length > 2
                                                            ? Center(
                                                                child:
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => ProfileTopicDescriptionScreen(
                                                                                        isOtheruser: widget.isOtherUser,
                                                                                        isFocusTextField: false,
                                                                                        scrollToBottom: true,
                                                                                        newsPostId: createdPost.id!,
                                                                                        topicTextEditingController: data.profileNewsCommentControllerList[index],
                                                                                        otherUserStreamController: widget.otherUserStreamController,
                                                                                      )));
                                                                        },
                                                                        child: Text(
                                                                            allComments.length > 3
                                                                                ? "${AppLocalizations.of(context).seeOther} ${allComments.length - 2}\n${AppLocalizations.of(context).comments}\n..."
                                                                                : "${AppLocalizations.of(context).seeOther} ${allComments.length - 2}\n${AppLocalizations.of(context).comment}\n...",
                                                                            textAlign: TextAlign
                                                                                .center,
                                                                            style: TextStyle(
                                                                                fontFamily: kHelveticaMedium,
                                                                                color: const Color(0xFFA08875),
                                                                                fontSize: SizeConfig.defaultSize * 1.2))))
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                  });
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context).refreshPage,
                              style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.5,
                                  fontFamily: kHelveticaRegular),
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              AppLocalizations.of(context).newsCouldNotLoad,
                              style: TextStyle(
                                  fontSize: SizeConfig.defaultSize * 1.5,
                                  fontFamily: kHelveticaRegular),
                            ),
                          );
                        }
                    }
                  },
                );
              },
            ),
    );
  }
}
