import 'package:c_talent/data/constant/font_constant.dart';
// ignore: depend_on_referenced_packages
import 'package:c_talent/data/new_models/all_news_posts.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/components/news/news_post_container.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    newsAdProvider.refreshNewsPosts(context: context);

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
            child: StreamBuilder<AllNewsPosts>(
              initialData: data.allNewsPosts,
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
                      return snapshot.data == null ||
                              snapshot.data?.posts == null
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context).newsCouldNotLoad,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () =>
                                  data.refreshNewsPosts(context: context),
                              child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  controller: scrollController,
                                  addAutomaticKeepAlives: true,
                                  itemCount: snapshot.data!.posts!.length >=
                                          data.totalInitialNewsList
                                      ? snapshot.data!.posts!.length + 1
                                      : snapshot.data!.posts!.length,
                                  itemBuilder: (context, index) {
                                    if (index < snapshot.data!.posts!.length) {
                                      // News post
                                      final newsPost =
                                          snapshot.data!.posts![index].newsPost;

                                      return newsPost == null
                                          ? const SizedBox()
                                          : NewsPostContainer(
                                              index: index,
                                              newsPost: newsPost,
                                            );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.defaultSize * 3),
                                        child: Center(
                                            child: data.hasMore
                                                ? const CircularProgressIndicator(
                                                    color: Color(0xFFA08875))
                                                : Text(
                                                    AppLocalizations.of(context)
                                                        .caughtUp,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            kHelveticaMedium,
                                                        fontSize: SizeConfig
                                                                .defaultSize *
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
