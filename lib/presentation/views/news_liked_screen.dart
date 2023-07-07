import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/user_follow_enum.dart';
import 'package:spa_app/data/models/news_post_likes_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/other_user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class NewsLikedScreen extends StatefulWidget {
  final int postId;

  const NewsLikedScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<NewsLikedScreen> createState() => _NewsLikedScreenState();
}

class _NewsLikedScreenState extends State<NewsLikedScreen> {
  @override
  void initState() {
    Provider.of<NewsAdProvider>(context, listen: false).getNewsPostLikes(
        newsPostId: widget.postId.toString(), context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsAdProvider>(builder: (context, data, child) {
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
          title: AppLocalizations.of(context).usersWhoLikedThePost,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
          child: StreamBuilder<NewsPostLikes>(
            stream: data.newsPostLikesStreamController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).loading,
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
                final newsPost = snapshot.data!.data!.attributes;

                final likedUserList = newsPost!.newsPostLikes!.data;

                return likedUserList!.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context).beTheFirstToLikeThePost,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: likedUserList.length,
                        itemBuilder: (context, index) {
                          int? likedByUserId =
                              likedUserList[index]!.attributes!.likedBy!.data ==
                                      null
                                  ? null
                                  : likedUserList[index]!
                                      .attributes!
                                      .likedBy!
                                      .data!
                                      .id!;
                          final likedByUser =
                              likedUserList[index]!.attributes!.likedBy!.data ==
                                      null
                                  ? null
                                  : likedUserList[index]!
                                      .attributes!
                                      .likedBy!
                                      .data!
                                      .attributes;
                          final userFollowData = likedUserList[index]!
                                      .attributes!
                                      .likedBy!
                                      .data ==
                                  null
                              ? null
                              : likedByUser != null &&
                                      likedByUser.userFollower != null
                                  ? likedByUser.userFollower!.data!
                                      .firstWhereOrNull((element) =>
                                          element!.attributes!.followedBy !=
                                              null &&
                                          element.attributes!.followedBy!
                                                  .data !=
                                              null &&
                                          element.attributes!.followedBy!.data!
                                                  .id
                                                  .toString() ==
                                              data.mainScreenProvider.userId
                                                  .toString())
                                  : null;

                          return data.mainScreenProvider.blockedUsersIdList
                                      .contains(likedByUserId) ||
                                  likedByUserId == null
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    if (likedByUserId !=
                                        int.parse(
                                            data.mainScreenProvider.userId!)) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherUserProfileScreen(
                                                    otherUserId: likedByUserId,
                                                  )));
                                    } else {
                                      Navigator.pushNamed(
                                          context, MyProfileScreen.id);
                                    }
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    margin: index == 0
                                        ? EdgeInsets.only(
                                            top: SizeConfig.defaultSize * 2,
                                            bottom: SizeConfig.defaultSize * 2)
                                        : EdgeInsets.only(
                                            bottom:
                                                SizeConfig.defaultSize * 1.5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              likedByUser!.profileImage!.data ==
                                                      null
                                                  ? Container(
                                                      height: SizeConfig
                                                              .defaultSize *
                                                          4.7,
                                                      width: SizeConfig
                                                              .defaultSize *
                                                          4.7,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(SizeConfig
                                                                    .defaultSize *
                                                                1.5),
                                                        color: Colors.white,
                                                        image: const DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/default_profile.jpg"),
                                                            fit: BoxFit.cover),
                                                      ))
                                                  : CachedNetworkImage(
                                                      imageUrl: kIMAGEURL +
                                                          likedByUser
                                                              .profileImage!
                                                              .data!
                                                              .attributes!
                                                              .url!,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(SizeConfig
                                                                      .defaultSize *
                                                                  1.5),
                                                          color: Colors.white,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            4.7,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(SizeConfig
                                                                      .defaultSize *
                                                                  1.5),
                                                          color: const Color(
                                                              0xFFD0E0F0),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.defaultSize),
                                                child: Text(
                                                    likedByUser.username!,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            kHelveticaMedium,
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            1.4)),
                                              )
                                            ],
                                          ),
                                        ),
                                        //  button
                                        likedByUserId ==
                                                int.parse(data
                                                    .mainScreenProvider.userId!)
                                            ? const SizedBox()
                                            : RectangularButton(
                                                textPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: SizeConfig
                                                                .defaultSize *
                                                            0.5),
                                                height: SizeConfig.defaultSize *
                                                    3.5,
                                                width:
                                                    SizeConfig.defaultSize * 10,
                                                onPress: () async {
                                                  await Provider.of<
                                                              ProfileProvider>(
                                                          context,
                                                          listen: false)
                                                      .toggleUserFollow(
                                                    userFollowSource:
                                                        UserFollowSource
                                                            .newsLikedScreen,
                                                    newsPostId: widget.postId
                                                        .toString(),
                                                    userFollowId: data
                                                                .mainScreenProvider
                                                                .followingIdList
                                                                .contains(
                                                                    likedByUserId) &&
                                                            likedByUser
                                                                    .userFollower !=
                                                                null
                                                        ? userFollowData?.id
                                                            .toString()
                                                        : null,
                                                    otherUserDeviceToken:
                                                        likedByUser.deviceToken,
                                                    otherUserId: likedByUserId,
                                                    context: context,
                                                    setLikeSaveCommentFollow:
                                                        false,
                                                  );
                                                },
                                                text: data.mainScreenProvider
                                                        .followingIdList
                                                        .contains(likedByUserId)
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .followed
                                                    : AppLocalizations.of(
                                                            context)
                                                        .follow,
                                                textColor: data
                                                        .mainScreenProvider
                                                        .followingIdList
                                                        .contains(likedByUserId)
                                                    ? Colors.white
                                                    : const Color(0xFF5545CF),
                                                buttonColor: data
                                                        .mainScreenProvider
                                                        .followingIdList
                                                        .contains(likedByUserId)
                                                    ? const Color(0xFF5545CF)
                                                    : Colors.white,
                                                borderColor: data
                                                        .mainScreenProvider
                                                        .followingIdList
                                                        .contains(likedByUserId)
                                                    ? const Color(0xFF5545CF)
                                                    : const Color(0xFF5349C7),
                                                fontFamily: kHelveticaMedium,
                                                keepBoxShadow: false,
                                                borderRadius:
                                                    SizeConfig.defaultSize *
                                                        1.8,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.1,
                                              )
                                      ],
                                    ),
                                  ),
                                );
                        });
              }
            },
          ),
        ),
      );
    });
  }
}
