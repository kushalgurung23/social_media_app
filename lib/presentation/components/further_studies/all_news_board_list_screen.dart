import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/news_board_enum.dart';
import 'package:spa_app/data/models/all_news_boards_model.dart';
import 'package:spa_app/logic/providers/further_studies_provider.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/components/further_studies/news_board_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AllNewsBoardListScreen extends StatefulWidget {
  const AllNewsBoardListScreen({Key? key}) : super(key: key);

  @override
  State<AllNewsBoardListScreen> createState() => _AllNewsBoardListScreenState();
}

class _AllNewsBoardListScreenState extends State<AllNewsBoardListScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of news board list
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
    super.initState();
  }

  void loadNextData() async {
    await Provider.of<FurtherStudiesProvider>(context, listen: false)
        .loadMoreNewsBoards(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FurtherStudiesProvider>(builder: (context, data, child) {
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
            title: AppLocalizations.of(context).newsBoard,
          ),
          body: StreamBuilder<AllNewsBoards?>(
              stream: data.allNewsBoardsStreamController.stream,
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
                          AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context).newsBoardCouldNotLoad,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.defaultSize * 2),
                        child: data.isRefresh == true
                            ? Center(
                                child: Text(
                                  AppLocalizations.of(context).reloading,
                                  style: TextStyle(
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ),
                              )
                            : snapshot.data!.data == null ||
                                    snapshot.data!.data!.isEmpty
                                ? Center(
                                    child: Text(
                                      AppLocalizations.of(context).noNewsBoard,
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: SizeConfig.defaultSize,
                                      ),
                                      Expanded(
                                        child: RefreshIndicator(
                                          onRefresh: () =>
                                              data.refresh(context: context),
                                          child: GridView.builder(
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(
                                                      parent:
                                                          BouncingScrollPhysics()),
                                              controller: scrollController,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      crossAxisSpacing: 4,
                                                      mainAxisSpacing: 4),
                                              itemCount: snapshot
                                                          .data!.data!.length >=
                                                      15
                                                  ? snapshot
                                                          .data!.data!.length +
                                                      1
                                                  : snapshot.data!.data!.length,
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    snapshot
                                                        .data!.data!.length) {
                                                  final newsBoard = snapshot
                                                      .data!.data![index];
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => NewsBoardDetailScreen(
                                                                  source:
                                                                      NewsBoardSourceType
                                                                          .all,
                                                                  newsBoardId:
                                                                      newsBoard
                                                                          .id
                                                                          .toString())));
                                                    },
                                                    child: Container(
                                                      color: Colors.transparent,
                                                      child: Column(children: [
                                                        newsBoard
                                                                    .attributes!
                                                                    .leadingImage!
                                                                    .data ==
                                                                null
                                                            ? Container(
                                                                height: SizeConfig
                                                                        .defaultSize *
                                                                    14,
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          "assets/images/no_image.png"),
                                                                      fit: BoxFit
                                                                          .cover),
                                                                ))
                                                            : CachedNetworkImage(
                                                                imageUrl: kIMAGEURL +
                                                                    newsBoard
                                                                        .attributes!
                                                                        .leadingImage!
                                                                        .data!
                                                                        .attributes!
                                                                        .url!,
                                                                height: SizeConfig
                                                                        .defaultSize *
                                                                    14,
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                                placeholder:
                                                                    (context,
                                                                            url) =>
                                                                        Container(
                                                                  height: SizeConfig
                                                                          .defaultSize *
                                                                      14,
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFD0E0F0),
                                                                  ),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: SizeConfig
                                                                    .defaultSize *
                                                                0.5,
                                                          ),
                                                          child: Text(
                                                            newsBoard
                                                                .attributes!
                                                                .title
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    kHelveticaMedium,
                                                                fontSize: SizeConfig
                                                                        .defaultSize *
                                                                    1.3),
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                  );
                                                } else {
                                                  return Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: SizeConfig
                                                                  .defaultSize *
                                                              3),
                                                      child: data.hasMore
                                                          ? const Center(
                                                              child: CircularProgressIndicator(
                                                                  color: Color(
                                                                      0xFF5545CF)))
                                                          : Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .caughtUp,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      kHelveticaRegular,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .defaultSize *
                                                                          1.7),
                                                            ));
                                                }
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                      );
                    }
                }
              }));
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
