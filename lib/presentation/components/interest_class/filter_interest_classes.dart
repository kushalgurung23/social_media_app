import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/interest_class_enum.dart';
import 'package:spa_app/data/models/interest_class_model.dart';
import 'package:spa_app/logic/providers/interest_class_provider.dart';
import 'package:spa_app/presentation/components/interest_class/interest_course_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterInterestClasses extends StatefulWidget {
  const FilterInterestClasses({Key? key}) : super(key: key);

  @override
  State<FilterInterestClasses> createState() => _FilterInterestClassesState();
}

class _FilterInterestClassesState extends State<FilterInterestClasses> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of filtered interest classes
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
    await interestClassProvider.loadMoreFilterResults(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterestClassProvider>(builder: (context, data, child) {
      return StreamBuilder<InterestClass?>(
          stream: data.filterInterestClassStreamController.stream,
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
                      data.filterNoRecord == true
                          ? Flexible(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.defaultSize * 3),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .noInterestClassFound,
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          :
                          // filter interest class
                          Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize),
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  controller: scrollController,
                                  itemCount: data
                                          .filterInterestClassList.isEmpty
                                      ? data.getFilterInterestClassCount(
                                          interestClassList:
                                              snapshot.data!.data!)
                                      : data.filterInterestClassList.length >=
                                              15
                                          ? data.filterInterestClassList
                                                  .length +
                                              1
                                          : data.filterInterestClassList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index <
                                        data.filterInterestClassList.length) {
                                      List<InterestClassData?>
                                          allInterestClass =
                                          data.filterInterestClassList;

                                      InterestClassData? interestClassData =
                                          allInterestClass[index];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.defaultSize),
                                        child: InterestCourseContainer(
                                          // interestClassBookmarkId will be provided if any when toggling save button
                                          interestClassBookmarkId: null,
                                          source:
                                              InterestClassSourceType.filter,
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
                                            child: data.filterHasMore
                                                ? const CircularProgressIndicator(
                                                    color: Color(0xFFA08875))
                                                : Text(
                                                    AppLocalizations.of(context)
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
