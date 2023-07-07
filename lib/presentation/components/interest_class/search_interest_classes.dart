import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/interest_class_enum.dart';
import 'package:spa_app/data/models/interest_class_model.dart';
import 'package:spa_app/logic/providers/interest_class_provider.dart';
import 'package:spa_app/presentation/components/interest_class/interest_course_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchInterestClasses extends StatefulWidget {
  const SearchInterestClasses({Key? key}) : super(key: key);

  @override
  State<SearchInterestClasses> createState() => _SearchInterestClassesState();
}

class _SearchInterestClassesState extends State<SearchInterestClasses> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of interest class
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
    super.initState();
  }

  void loadNextData() async {
    final interestClassProvider =
        Provider.of<InterestClassProvider>(context, listen: false);
    await interestClassProvider.loadMoreSearchResults(
        context: context,
        query: interestClassProvider.interestClassSearchTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterestClassProvider>(builder: (context, data, child) {
      return StreamBuilder<InterestClass?>(
          stream: data.searchInterestClassStreamController.stream,
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
                      AppLocalizations.of(context).dataCouldNotLoad,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      data.noRecord == true &&
                              data.searchInterestClassList.isEmpty
                          ? Flexible(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.defaultSize * 3),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .noInterestClassFound,
                                    style: TextStyle(
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.7),
                                  ),
                                ),
                              ),
                            )
                          :
                          // search interest class
                          Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize),
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  controller: scrollController,
                                  itemCount: data
                                          .searchInterestClassList.isEmpty
                                      ? data.getInterestClassSearchCount(
                                          interestClassList:
                                              snapshot.data!.data!)
                                      : data.searchInterestClassList.length >=
                                              15
                                          ? data.searchInterestClassList
                                                  .length +
                                              1
                                          : data.searchInterestClassList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index <
                                        data.searchInterestClassList.length) {
                                      List<InterestClassData?>
                                          allInterestClass =
                                          data.searchInterestClassList;

                                      InterestClassData? interestClassData =
                                          allInterestClass[index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.defaultSize),
                                        child: InterestCourseContainer(
                                          // interestClassBookmarkId will be provided if any when toggling save button
                                          interestClassBookmarkId: null,

                                          source:
                                              InterestClassSourceType.search,
                                          interestClassData: interestClassData!,
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            SizeConfig.defaultSize,
                                            0,
                                            SizeConfig.defaultSize,
                                            SizeConfig.defaultSize * 2),
                                        child: Center(
                                            child: data.searchHasMore
                                                ? const CircularProgressIndicator(
                                                    color: Color(0xFF5545CF))
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
                                  },
                                ),
                              ),
                            ),
                    ],
                  );
                }
            }
          });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
