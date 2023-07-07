import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/news_description_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/enum/news_post_enum.dart';
import 'package:spa_app/data/enum/post_type.dart';
import 'package:spa_app/presentation/components/all/post_top_body.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/views/news_liked_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsPostContainer extends StatefulWidget {
  final NewsPost newsPost;
  final UserAttributes postedBy;
  final int? postedById;
  final List<CommentsData>? allComments;
  final int index;
  final NewsPostSavesData? checkNewsPostSave;
  final TextEditingController newsCommentTextEditingController;
  final AllNewsPostLikesData? checkNewsPostLike;
  const NewsPostContainer(
      {Key? key,
      required this.newsPost,
      required this.postedBy,
      required this.postedById,
      required this.checkNewsPostLike,
      required this.allComments,
      required this.index,
      required this.newsCommentTextEditingController,
      required this.checkNewsPostSave})
      : super(key: key);

  @override
  State<NewsPostContainer> createState() => _NewsPostContainerState();
}

class _NewsPostContainerState extends State<NewsPostContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
      // blocked and deleted users won't be included
      final totalLikeCountList = widget
          .newsPost.attributes!.newsPostLikes!.data!
          .where((element) =>
              element != null &&
              element.attributes != null &&
              element.attributes!.likedBy != null &&
              element.attributes!.likedBy!.data != null &&
              !data.mainScreenProvider.blockedUsersIdList
                  .contains(element.attributes!.likedBy!.data!.id))
          .toList();
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
                              newsPostId: widget.newsPost.id!,
                              newsCommentTextEditingController:
                                  widget.newsCommentTextEditingController,
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
                        color: const Color(0xFF5545CF).withOpacity(0.22),
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
                          widget.newsCommentTextEditingController,
                      isOtherUserProfile: false,
                      isFromDescriptionScreen: false,
                      newsPostId: widget.newsPost.id.toString(),
                      postedByOnPress: () {
                        if (widget.postedById != null) {
                          if (widget.postedById !=
                              int.parse(data.mainScreenProvider.userId!)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OtherUserProfileScreen(
                                          otherUserId: widget.postedById!,
                                        )));
                          } else {
                            Navigator.pushNamed(context, MyProfileScreen.id);
                          }
                        }
                      },
                      commentOnPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsDescriptionScreen(
                                      focusTextfield: true,
                                      scrollToBottom: true,
                                      newsPostId: widget.newsPost.id!,
                                      newsCommentTextEditingController: widget
                                          .newsCommentTextEditingController,
                                    )));
                      },
                      postType: PostType.newsPost,
                      showLevel: true,
                      title: widget.newsPost.attributes!.title!,
                      userName: widget.postedBy.username!,
                      postContent: widget.newsPost.attributes!.content!,
                      postImage: widget.newsPost.attributes!.image!.data == null
                          ? null
                          : widget.newsPost.attributes!.image!.data!,
                      postedTime: data.mainScreenProvider.convertDateTimeToAgo(
                          widget.newsPost.attributes!.createdAt!, context),
                      userImage: (widget.postedBy.profileImage == null ||
                              widget.postedBy.profileImage!.data == null)
                          ? null
                          : widget.postedBy.profileImage!.data!.attributes!.url,
                      userType: data.getUserType(
                          usertType: widget.postedBy.userType ?? '',
                          context: context),
                      isSave: data.checkNewsPostSaveStatus(
                          postId: widget.newsPost.id!),
                      saveOnPress: () async {
                        await data.toggleNewsPostSave(
                            newsPostSource: NewsPostSource.all,
                            newsPostSaveId:
                                widget.checkNewsPostSave?.id.toString(),
                            postId: widget.newsPost.id.toString(),
                            context: context,
                            setLikeSaveCommentFollow: false);
                      },
                      isLike: data.checkNewsPostLikeStatus(
                          postId: widget.newsPost.id!),
                      likeOnPress: () async {
                        await data.toggleNewsPostLike(
                            newsPostSource: NewsPostSource.all,
                            newsPostLikeId:
                                widget.checkNewsPostLike?.id.toString(),
                            postId: widget.newsPost.id.toString(),
                            postLikeCount:
                                widget.newsPost.attributes!.newsPostLikes ==
                                            null ||
                                        widget.newsPost.attributes!
                                                .newsPostLikes!.data ==
                                            null
                                    ? 0
                                    : totalLikeCountList.length,
                            context: context,
                            setLikeSaveCommentFollow: false);
                      },
                      hasLikes: widget.newsPost.attributes!.newsPostLikes ==
                                  null ||
                              widget.newsPost.attributes!.newsPostLikes!.data ==
                                  null
                          ? false
                          : totalLikeCountList.isNotEmpty,
                      seeLikesOnPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewsLikedScreen(
                                      postId: widget.newsPost.id!,
                                    )));
                      },
                      likedAvtars: data.mainScreenProvider.userId == null
                          ? const SizedBox()
                          : data.likedAvatars(
                              likeCount:
                                  widget.newsPost.attributes!.newsPostLikes ==
                                              null ||
                                          widget.newsPost.attributes!
                                                  .newsPostLikes!.data ==
                                              null
                                      ? null
                                      : totalLikeCountList,
                              isLike: data.mainScreenProvider.likedPostIdList
                                  .contains(widget.newsPost.id)),
                      totalLikes: data.getLike(
                        likeCount:
                            widget.newsPost.attributes!.newsPostLikes == null ||
                                    widget.newsPost.attributes!.newsPostLikes!
                                            .data ==
                                        null
                                ? 0
                                : totalLikeCountList.length,
                        context: context,
                      ),
                    ),
                    // comment box
                    Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.defaultSize * 1.5),
                      child: RoundedTextFormField(
                          textEditingController:
                              widget.newsCommentTextEditingController,
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
                            if (widget.newsCommentTextEditingController.text
                                .trim()
                                .isNotEmpty) {
                              await data.postNewsComment(
                                newsPostSource: NewsPostSource.all,
                                context: context,
                                newsPostId: widget.newsPost.id.toString(),
                                newsCommentController:
                                    widget.newsCommentTextEditingController,
                                setLikeSaveCommentFollow: false,
                              );
                            }
                          },
                          borderRadius: SizeConfig.defaultSize * 1.5),
                    ),
                    SizedBox(
                      child: widget.allComments == null ||
                              (widget.allComments != null &&
                                  widget.allComments!.isEmpty)
                          ? SizedBox(
                              height: SizeConfig.defaultSize,
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 2),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount:
                                      widget.allComments!.length >= 2 ? 2 : 1,
                                  itemBuilder: (context, index) {
                                    widget.allComments!.sort((a, b) => a
                                        .attributes!.createdAt!
                                        .compareTo(b.attributes!.createdAt!));
                                    final commentData =
                                        widget.allComments!.length > 2
                                            ? widget.allComments![
                                                (widget.allComments!.length -
                                                        2) +
                                                    index]
                                            : widget.allComments![index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: SizeConfig.defaultSize * 0.6),
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
                                                              .attributes!
                                                              .commentBy!
                                                              .data!
                                                              .id !=
                                                          null) {
                                                        if (commentData
                                                                .attributes!
                                                                .commentBy!
                                                                .data!
                                                                .id !=
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
                                                                                commentData.attributes!.commentBy!.data!.id!,
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
                                                      color: Colors.transparent,
                                                      child: Text(
                                                        '${commentData.attributes!.commentBy!.data!.attributes!.username} : ',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                kHelveticaMedium,
                                                            fontSize: SizeConfig
                                                                    .defaultSize *
                                                                1.3,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        commentData
                                                            .attributes!.content
                                                            .toString(),
                                                        overflow: TextOverflow
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
                                                    width:
                                                        SizeConfig.defaultSize *
                                                            1)
                                              ],
                                            ),
                                          ),
                                          Text(
                                              data.mainScreenProvider
                                                  .convertDateTimeToAgo(
                                                      commentData.attributes!
                                                          .createdAt!,
                                                      context),
                                              style: TextStyle(
                                                  fontFamily: kHelveticaRegular,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.1)),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                    ),
                    widget.allComments!.length > 2
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
                                                newsPostId: widget.newsPost.id!,
                                                newsCommentTextEditingController:
                                                    widget
                                                        .newsCommentTextEditingController,
                                              )));
                                },
                                child: Text(
                                    widget.allComments != null &&
                                            widget.allComments!.length > 3
                                        ? "${AppLocalizations.of(context).seeOther} ${widget.allComments!.length - 2}\n${AppLocalizations.of(context).comments}\n..."
                                        : "${AppLocalizations.of(context).seeOther} ${widget.allComments!.length - 2}\n${AppLocalizations.of(context).comment}\n...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        color: const Color(0xFF5545CF),
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
  bool get wantKeepAlive => true;
}
