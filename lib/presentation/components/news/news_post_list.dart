// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/all_news_post_model.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/presentation/components/news/news_post_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

class NewsPostList extends StatefulWidget {
  const NewsPostList({Key? key}) : super(key: key);

  @override
  State<NewsPostList> createState() => _NewsPostListState();
}

class _NewsPostListState extends State<NewsPostList>
    with AutomaticKeepAliveClientMixin {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final newsAdProvider = Provider.of<NewsAdProvider>(context, listen: false);

    // this will load initial 15 news posts in the news posts tab
    newsAdProvider.refresh(context: context);

    // this will load more data when we reach the end of news posts

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
  }

  void loadNextData() async {
    await Provider.of<NewsAdProvider>(context, listen: false)
        .loadMoreNewsPosts(context: context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<NewsAdProvider>(
      builder: (context, data, child) {
        return Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize),
            child: StreamBuilder<AllNewsPost>(
              initialData: data.allNewsPost,
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
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context).errorOccured,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context).newsCouldNotLoad,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return RefreshIndicator(
                        onRefresh: () => data.refresh(context: context),
                        child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            controller: scrollController,
                            addAutomaticKeepAlives: true,
                            itemCount: snapshot.data!.data!.length >=
                                    data.totalInitialNewsList
                                ? snapshot.data!.data!.length + 1
                                : snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              if (index < snapshot.data!.data!.length) {
                                // News post
                                final newsPost = snapshot.data!.data![index];

                                UserAttributes? postedBy;
                                int? postedById;
                                if (newsPost.attributes!.postedBy != null &&
                                    newsPost.attributes!.postedBy!.data !=
                                        null) {
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

                                List<CommentsData>? allComments = snapshot.data!
                                    .data![index].attributes!.comments!.data!;
                                if (data.newsCommentControllerList.length !=
                                    snapshot.data!.data!.length) {
                                  if (data.newsCommentControllerList.length <
                                      snapshot.data!.data!.length) {
                                    data.newsCommentControllerList
                                        .add(TextEditingController());
                                  } else if (data
                                          .newsCommentControllerList.length >
                                      snapshot.data!.data!.length) {
                                    data.newsCommentControllerList.clear();
                                    data.newsCommentControllerList
                                        .add(TextEditingController());
                                  }
                                }
                                final checkNewsPostSave = data
                                            .mainScreenProvider
                                            .savedNewsPostIdList
                                            .contains(newsPost.id!) &&
                                        newsPost.attributes!.newsPostSaves!
                                                .data !=
                                            null
                                    ? newsPost
                                        .attributes!.newsPostSaves!.data!
                                        .firstWhereOrNull(
                                            (element) =>
                                                element!
                                                        .attributes!.savedBy !=
                                                    null &&
                                                element.attributes!.savedBy!
                                                        .data !=
                                                    null &&
                                                element.attributes!.savedBy!
                                                        .data!.id
                                                        .toString() ==
                                                    data.mainScreenProvider
                                                        .userId
                                                        .toString())
                                    : null;
                                final checkNewsPostLike = data
                                            .mainScreenProvider.likedPostIdList
                                            .contains(newsPost.id!) &&
                                        newsPost.attributes!.newsPostLikes !=
                                            null
                                    ? newsPost.attributes!.newsPostLikes!.data!
                                        .firstWhereOrNull((element) =>
                                            element!.attributes!.likedBy !=
                                                null &&
                                            element.attributes!.likedBy!.data !=
                                                null &&
                                            element.attributes!.likedBy!.data!
                                                    .id
                                                    .toString() ==
                                                data.mainScreenProvider.userId
                                                    .toString())
                                    : null;
                                return newsPost.attributes!.postedBy == null ||
                                        (newsPost.attributes!.postedBy != null &&
                                            newsPost.attributes!.postedBy!
                                                    .data ==
                                                null)
                                    ? const SizedBox()
                                    : NewsPostContainer(
                                        newsPost: newsPost,
                                        postedBy: postedBy,
                                        postedById: postedById,
                                        checkNewsPostLike: checkNewsPostLike,
                                        // ignore: unnecessary_null_comparison, prefer_null_aware_operators
                                        allComments: allComments == null
                                            ? null
                                            : allComments
                                                .where((element) =>
                                                    element.attributes != null &&
                                                    element.attributes!
                                                            .commentBy !=
                                                        null &&
                                                    element.attributes!
                                                            .commentBy!.data !=
                                                        null &&
                                                    !data.mainScreenProvider
                                                        .blockedUsersIdList
                                                        .contains(element
                                                            .attributes!
                                                            .commentBy!
                                                            .data!
                                                            .id))
                                                .toList(),
                                        index: index,
                                        newsCommentTextEditingController: data
                                            .newsCommentControllerList[index],
                                        checkNewsPostSave: checkNewsPostSave);
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.defaultSize * 3),
                                  child: Center(
                                      child: data.hasMore
                                          ? const CircularProgressIndicator(
                                              color: Color(0xFFA08875))
                                          : Text(
                                              AppLocalizations.of(context)
                                                  .caughtUp,
                                              style: TextStyle(
                                                  fontFamily: kHelveticaMedium,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          1.5),
                                            )),
                                );
                              }
                            }),
                      );
                    } else {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context).noNewsPosts,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    }
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
