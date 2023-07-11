import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/interest_class_enum.dart';
import 'package:spa_app/data/models/bookmark_interest_class_model.dart';
import 'package:spa_app/logic/providers/interest_class_provider.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/components/interest_class/interest_course_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarkInterestClassesScreen extends StatefulWidget {
  static const String id = '/bookmark_interest_classes';

  const BookmarkInterestClassesScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkInterestClassesScreen> createState() =>
      _BookmarkInterestClassesScreenState();
}

class _BookmarkInterestClassesScreenState
    extends State<BookmarkInterestClassesScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<InterestClassProvider>(context, listen: false)
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
    await Provider.of<InterestClassProvider>(context, listen: false)
        .loadMoreBookmarkInterestClasses(context: context);
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
          title: AppLocalizations.of(context).favoriteCourse),
      body: Consumer<InterestClassProvider>(
        builder: (context, data, child) {
          return Padding(
            padding: EdgeInsets.fromLTRB(SizeConfig.defaultSize,
                SizeConfig.defaultSize * 1, SizeConfig.defaultSize, 0),
            child: data.mainScreenProvider.savedInterestClassIdList.isEmpty
                ? Center(
                    child: Text(
                        AppLocalizations.of(context).noInterestClassBookmarked,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.6)),
                  )
                : StreamBuilder<BookmarkInterestClass?>(
                    stream: data.bookmarkInterestClassStreamController.stream,
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
                            if (snapshot.data!.data!.isEmpty &&
                                data.isBookmarkRefresh == false) {
                              data.bookmarkRefresh(context: context);
                            }
                            return snapshot.data!.data!.isEmpty &&
                                    data.isBookmarkRefresh == false
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.defaultSize * 3),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .noInterestClassBookmarked,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.7),
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
                                          controller: scrollController,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(
                                                  parent:
                                                      BouncingScrollPhysics()),
                                          itemCount: snapshot
                                                      .data!.data!.length >=
                                                  15
                                              ? snapshot.data!.data!.length + 1
                                              : snapshot.data!.data!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index <
                                                snapshot.data!.data!.length) {
                                              final bookmarkInterestClassData =
                                                  snapshot.data!.data![index];

                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.defaultSize),
                                                child: InterestCourseContainer(
                                                  interestClassBookmarkId:
                                                      bookmarkInterestClassData!
                                                          .id
                                                          .toString(),
                                                  source:
                                                      InterestClassSourceType
                                                          .bookmark,
                                                  interestClassData:
                                                      bookmarkInterestClassData
                                                          .attributes!
                                                          .interestClass!
                                                          .data!,
                                                ),
                                              );
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
                                                                0xFFA08875))
                                                        : Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .caughtUp,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    kHelveticaRegular,
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
