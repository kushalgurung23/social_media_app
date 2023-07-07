import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/bookmark_paper_share_model.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/paper_share/bookmark_paper_share_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarkPaperShareListview extends StatefulWidget {
  static const String id = '/bookmark_paper_share_screen';
  const BookmarkPaperShareListview({Key? key}) : super(key: key);

  @override
  State<BookmarkPaperShareListview> createState() =>
      _BookmarkPaperShareListviewState();
}

class _BookmarkPaperShareListviewState
    extends State<BookmarkPaperShareListview> {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<PaperShareProvider>(context, listen: false)
        .bookmarkRefresh(context: context);

    // this will load more data when we reach the end of paper share
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
    super.initState();
  }

  void loadNextData() async {
    await Provider.of<PaperShareProvider>(context, listen: false)
        .loadMoreBookmarkPaperShare(context: context);
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
          title: AppLocalizations.of(context).bookmark),
      body: Consumer<PaperShareProvider>(
        builder: (context, data, child) {
          return Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.defaultSize * 2,
                SizeConfig.defaultSize * 1, SizeConfig.defaultSize * 2, 0),
            child: data.mainScreenProvider.savedPaperShareIdList.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).noBookmarkPaperShares,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5)),
                  )
                : StreamBuilder<BookmarkPaperShare>(
                    stream: data.bookmarkShareStreamController.stream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: Text(AppLocalizations.of(context).loading,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5)),
                          );
                        case ConnectionState.done:
                        default:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  AppLocalizations.of(context).refreshPage,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5)),
                            );
                          } else if (!snapshot.hasData) {
                            return Center(
                              child: Text(
                                  AppLocalizations.of(context).dataCouldNotLoad,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: kHelveticaRegular,
                                      fontSize: SizeConfig.defaultSize * 1.5)),
                            );
                          } else {
                            return snapshot.data!.data!.isEmpty &&
                                    data.isBookmarkRefresh == false
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.defaultSize * 3),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .noBookmarkPaperShares,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.5),
                                      ),
                                    ),
                                  )
                                : snapshot.data!.data!.isEmpty &&
                                        data.isBookmarkRefresh == true
                                    ? Center(
                                        child: Text(
                                            AppLocalizations.of(context)
                                                .loading,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: kHelveticaRegular,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.5)))
                                    : RefreshIndicator(
                                        onRefresh: () => data.bookmarkRefresh(
                                            context: context),
                                        child: ListView.builder(
                                          addAutomaticKeepAlives: true,
                                          controller: scrollController,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          itemCount: snapshot
                                                      .data!.data!.length >=
                                                  data.totalInitialBookmarkPaperShare
                                              ? snapshot.data!.data!.length + 1
                                              : snapshot.data!.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index <
                                                snapshot.data!.data!.length) {
                                              final bookmarkPaperShareData =
                                                  snapshot.data!.data![index];

                                              return BookmarkPaperShareContainer(
                                                  paperShareSaveId:
                                                      bookmarkPaperShareData!.id
                                                          .toString(),
                                                  paperShare:
                                                      bookmarkPaperShareData
                                                          .attributes!
                                                          .paperShare!
                                                          .data!);
                                            } else {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        SizeConfig.defaultSize *
                                                            3),
                                                child: Center(
                                                    child: data.bookmarkHasMore
                                                        ? const CircularProgressIndicator(
                                                            color: Color(
                                                                0xFF5545CF))
                                                        : Text(
                                                            AppLocalizations.of(
                                                                    context)
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
                                          },
                                        ),
                                      );
                          }
                      }
                    }),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
