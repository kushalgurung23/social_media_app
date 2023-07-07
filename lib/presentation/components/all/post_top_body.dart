import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/post_type.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/presentation/components/all/post_options.dart';
import 'package:spa_app/presentation/components/all/post_staggered_grid_view.dart';
import 'package:spa_app/presentation/components/news/show_report_news_post_container.dart';
import 'package:spa_app/presentation/components/profile/profile_post_staggered_grid_view.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PostTopBody extends StatelessWidget {
  final Enum postType;
  final String title, userName, userType, postContent, totalLikes, postedTime;
  // postFromProfile = true denotes that the post is viewed from profile section. Two different image data type are made due to different result while fetching api from news post and user. If true, allPostImage will be used, else postImage will be used.
  final bool? postFromProfile;
  final List<AllImage?>? allPostImage;
  final List<MultiImageData?>? postImage;
  final String? userImage;
  final String newsPostId;
  final VoidCallback saveOnPress, likeOnPress, commentOnPress;
  final bool isSave,
      isLike,
      hasLikes,
      showLevel,
      isFromDescriptionScreen,
      isOtherUserProfile;
  final VoidCallback? seeLikesOnPress, postedByOnPress;
  final Widget likedAvtars;
  StreamController<User>? otherUserStreamController;
  final TextEditingController newsCommentTextEditingController;
  PostTopBody(
      {Key? key,
      this.otherUserStreamController,
      required this.isFromDescriptionScreen,
      required this.newsPostId,
      required this.isOtherUserProfile,
      this.postFromProfile = false,
      required this.commentOnPress,
      required this.postType,
      required this.showLevel,
      required this.totalLikes,
      required this.likedAvtars,
      required this.title,
      required this.userImage,
      required this.userName,
      required this.postedTime,
      required this.userType,
      required this.postContent,
      this.allPostImage,
      this.postImage,
      required this.saveOnPress,
      required this.likeOnPress,
      required this.isSave,
      required this.isLike,
      required this.hasLikes,
      required this.seeLikesOnPress,
      this.postedByOnPress,
      required this.newsCommentTextEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
      return Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.defaultSize,
                  bottom: SizeConfig.defaultSize * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: kHelveticaMedium,
                        fontSize: SizeConfig.defaultSize * 2,
                      ),
                    ),
                  ),
                  PopupMenuButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      position: PopupMenuPosition.under,
                      child: Icon(
                        Icons.more_vert,
                        color: const Color(0xFF8897A7),
                        size: SizeConfig.defaultSize * 2.1,
                      ),
                      onSelected: (value) {
                        if (value == AppLocalizations.of(context).report) {
                          data.resetNewsPostReportOption();
                          showReportNewsPostContainer(
                              newsCommentTextEditingController:
                                  newsCommentTextEditingController,
                              isOtherUserProfile: isOtherUserProfile,
                              otherUserStreamController:
                                  otherUserStreamController,
                              isFromDescriptionScreen: isFromDescriptionScreen,
                              context: context,
                              newsPostId: newsPostId);
                        }
                      },
                      itemBuilder: (context) {
                        return data
                            .getNewsPostReportList(context: context)
                            .map((e) => PopupMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5,
                                      color: Colors.red),
                                )))
                            .toList();
                      }),
                ],
              ),
            ),
            // Profile section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: postedByOnPress,
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userImage == null
                            ? Container(
                                height: SizeConfig.defaultSize * 4.7,
                                width: SizeConfig.defaultSize * 4.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.defaultSize * 1.5),
                                  color: Colors.white,
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/default_profile.jpg"),
                                      fit: BoxFit.cover),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: kIMAGEURL + userImage!,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: SizeConfig.defaultSize * 4.7,
                                  width: SizeConfig.defaultSize * 4.7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.defaultSize * 1.5),
                                    color: Colors.white,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  height: SizeConfig.defaultSize * 4.7,
                                  width: SizeConfig.defaultSize * 4.7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.defaultSize * 1.5),
                                    color: const Color(0xFFD0E0F0),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.defaultSize * 0.5),
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.defaultSize),
                                  child: Text(userName,
                                      style: TextStyle(
                                          fontFamily: kHelveticaMedium,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.4)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.defaultSize,
                                      top: SizeConfig.defaultSize * 0.5),
                                  child: Text(postedTime,
                                      style: TextStyle(
                                          color: const Color(0xFF8897A7),
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.2)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.defaultSize * 0.5),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 1.5,
                      vertical: SizeConfig.defaultSize),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: postType == PostType.newsPost
                          ? const Color(0xFFEFE9FF)
                          : postType == PostType.recentTopic
                              ? const Color(0xFFE9F7FF)
                              : postType == PostType.profileTopic
                                  ? const Color(0xFFE9FFEC)
                                  : const Color(0xFFEFE9FF),
                      border: Border.all(
                          color: postType == PostType.newsPost
                              ? const Color(0xFFEFE9FF)
                              : postType == PostType.recentTopic
                                  ? const Color(0xFFDFE6F3)
                                  : postType == PostType.profileTopic
                                      ? const Color(0xFFDFF3E9)
                                      : const Color(0xFFEFE9FF),
                          width: 0.5)),
                  child: Text(userType,
                      style: TextStyle(
                          color: postType == PostType.newsPost
                              ? const Color(0xFF5545CF)
                              : postType == PostType.recentTopic
                                  ? const Color(0xFF457ACF)
                                  : postType == PostType.profileTopic
                                      ? const Color(0xFF4ACF45)
                                      : const Color(0xFF5545CF),
                          fontFamily: kHelveticaMedium,
                          fontSize: SizeConfig.defaultSize * 1.25)),
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 1.5,
            ),
            //  content
            ExpandableText(
              postContent,
              expandText: AppLocalizations.of(context).showMore,
              collapseText: AppLocalizations.of(context).showLess,
              style: TextStyle(
                  color: const Color(0xFF00153B),
                  fontFamily: kHelveticaRegular,
                  fontSize: SizeConfig.defaultSize * 1.4),
              maxLines: 5,
              textAlign: TextAlign.justify,
              linkStyle: TextStyle(
                  color: const Color(0xFF5545CF),
                  fontFamily: kHelveticaMedium,
                  fontSize: SizeConfig.defaultSize * 1.3,
                  backgroundColor: Colors.transparent),
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 1.5,
            ),
            postFromProfile == false
                ? PostStaggeredGridView(postImage: postImage)
                : ProfilePostStaggeredGridView(postImage: allPostImage),
            SizedBox(
              height: SizeConfig.defaultSize * 1.5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.defaultSize * 0.7),
                        child: GestureDetector(
                          onTap: saveOnPress,
                          child: PostOptions(
                            child: Center(
                              child: Icon(Icons.bookmark,
                                  color: isSave
                                      ? const Color(0xFFFEB703)
                                      : const Color(0xFFD1D3D5),
                                  size: SizeConfig.defaultSize * 3.3),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.defaultSize * 0.7),
                        child: GestureDetector(
                          onTap: commentOnPress,
                          child: PostOptions(
                            child: Center(
                              child: SvgPicture.asset("assets/svg/comment.svg",
                                  color: const Color(0xFFD1D3D5),
                                  height: SizeConfig.defaultSize * 2.3,
                                  width: SizeConfig.defaultSize * 2.3),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.defaultSize * 0.7),
                        child: GestureDetector(
                          onTap: likeOnPress,
                          child: PostOptions(
                            child: Center(
                              child: Icon(Icons.favorite,
                                  color: isLike
                                      ? const Color(0xFFC1024F)
                                      : const Color(0xFFD1D3D5),
                                  size: SizeConfig.defaultSize * 3.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                hasLikes
                    ? GestureDetector(
                        onTap: seeLikesOnPress,
                        child: Container(
                          padding: EdgeInsets.all(SizeConfig.defaultSize * 0.3),
                          height: SizeConfig.defaultSize * 4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.defaultSize * 2),
                              color: const Color(0xFFF9F9F9),
                              border: Border.all(
                                  color: const Color(0xFFE6E6E6), width: 0.5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              likedAvtars,
                              Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.defaultSize * 0.5),
                                child: Text(
                                  totalLikes,
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.1,
                                      color: const Color(0xFF9D9D9D)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      );
    });
  }
}
