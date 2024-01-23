import 'dart:async';
import 'package:c_talent/data/constant/color_constant.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/news_post_likes.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class NewsLikedScreen extends StatefulWidget {
  final int postId;

  const NewsLikedScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<NewsLikedScreen> createState() => _NewsLikedScreenState();
}

class _NewsLikedScreenState extends State<NewsLikedScreen> {
  StreamController<NewsPostLikes> newsPostLikesStreamController =
      BehaviorSubject();
  final scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<NewsAdProvider>(context, listen: false).loadInitialNewsLikes(
        allNewsLikeStreamController: newsPostLikesStreamController,
        newsPostId: widget.postId,
        context: context);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });

    super.initState();
  }

  void loadNextData() async {
    await Provider.of<NewsAdProvider>(context, listen: false).loadMoreNewsLikes(
        context: context,
        newsPostId: widget.postId,
        allNewsLikesStreamController: newsPostLikesStreamController);
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
            stream: newsPostLikesStreamController.stream,
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
                if (snapshot.data == null ||
                    snapshot.data?.likes == null ||
                    snapshot.data!.likes!.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).beTheFirstToLikeThePost,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else {
                  final likeList = snapshot.data!.likes!;
                  return ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      itemCount: likeList.length,
                      itemBuilder: (context, index) {
                        final likedBy = likeList[index].likedBy;
                        return likedBy == null
                            ? const SizedBox()
                            : GestureDetector(
                                onTap: () {},
                                child: Container(
                                  color: Colors.transparent,
                                  margin: index == 0
                                      ? EdgeInsets.only(
                                          top: SizeConfig.defaultSize * 2,
                                          bottom: SizeConfig.defaultSize * 2)
                                      : EdgeInsets.only(
                                          bottom: SizeConfig.defaultSize * 1.5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Row(
                                          children: [
                                            likedBy.profilePicture == null
                                                ? Container(
                                                    height:
                                                        SizeConfig.defaultSize *
                                                            4.7,
                                                    width:
                                                        SizeConfig.defaultSize *
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
                                                        likedBy.profilePicture
                                                            .toString(),
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
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
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
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
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(SizeConfig
                                                                    .defaultSize *
                                                                1.5),
                                                        color: const Color(
                                                            0xFFD0E0F0),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.defaultSize),
                                              child: Text(
                                                  likedBy.username.toString(),
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
                                      data.mainScreenProvider.loginSuccess
                                                      .user !=
                                                  null &&
                                              likedBy.id ==
                                                  int.parse(data
                                                      .mainScreenProvider
                                                      .loginSuccess
                                                      .user!
                                                      .id
                                                      .toString())
                                          ? const SizedBox()
                                          : RectangularButton(
                                              textPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      SizeConfig.defaultSize *
                                                          0.5),
                                              height:
                                                  SizeConfig.defaultSize * 3.5,
                                              width:
                                                  SizeConfig.defaultSize * 10,
                                              onPress: () async {},
                                              text: likedBy.isFollowed == 1
                                                  ? AppLocalizations.of(context)
                                                      .following
                                                  : AppLocalizations.of(context)
                                                      .follow,
                                              textColor: likedBy.isFollowed == 1
                                                  ? Colors.white
                                                  : const Color(0xFFA08875),
                                              buttonColor:
                                                  likedBy.isFollowed == 1
                                                      ? kPrimaryColor
                                                      : Colors.white,
                                              borderColor: kPrimaryColor,
                                              fontFamily: kHelveticaMedium,
                                              keepBoxShadow: false,
                                              borderRadius:
                                                  SizeConfig.defaultSize * 1.8,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.1,
                                            )
                                    ],
                                  ),
                                ),
                              );
                      });
                }
              }
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    newsPostLikesStreamController.close();
    scrollController.dispose();
    super.dispose();
  }
}
