import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/interest_class_enum.dart';
import 'package:spa_app/data/models/interest_class_model.dart';
import 'package:spa_app/logic/providers/interest_class_provider.dart';
import 'package:spa_app/presentation/components/interest_class/interest_course_container.dart';
import 'package:spa_app/presentation/components/interest_class/recommend_class_list.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllInterestClasses extends StatefulWidget {
  const AllInterestClasses({Key? key}) : super(key: key);

  @override
  State<AllInterestClasses> createState() => _AllInterestClassesState();
}

class _AllInterestClassesState extends State<AllInterestClasses> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // Loading initial interest classes
    Provider.of<InterestClassProvider>(context, listen: false)
        .interestClassRefresh(context: context);

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
    await Provider.of<InterestClassProvider>(context, listen: false)
        .loadMoreInterestClass(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InterestClassProvider>(builder: (context, data, child) {
      return StreamBuilder<InterestClass?>(
          stream: data.allInterestClassStreamController.stream,
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
                  return Column(children: [
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () =>
                            data.interestClassRefresh(context: context),
                        child: SingleChildScrollView(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Recommend section
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.defaultSize * 2),
                                  child: Text(
                                    AppLocalizations.of(context).recommend,
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.8),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.defaultSize * 2),
                                // Recommend class list
                                const RecommendClassList(),
                                SizedBox(height: SizeConfig.defaultSize * 3),
                                // All course section
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.defaultSize * 2),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).allCourse,
                                        style: TextStyle(
                                            fontFamily: kHelveticaMedium,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.8),
                                      ),
                                      SizedBox(
                                          height: SizeConfig.defaultSize * 3),
                                      snapshot.data!.data!.isEmpty
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      SizeConfig.defaultSize *
                                                          3),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)
                                                      .noInterestClassAvailable,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaRegular,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.5),
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              child: ListView.builder(
                                                primary: false,
                                                shrinkWrap: true,
                                                itemCount: snapshot.data!.data!
                                                            .length >=
                                                        15
                                                    ? snapshot.data!.data!
                                                            .length +
                                                        1
                                                    : snapshot
                                                        .data!.data!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (index <
                                                      snapshot
                                                          .data!.data!.length) {
                                                    final interestClassData =
                                                        snapshot.data!
                                                            .data![index]!;
                                                    return InterestCourseContainer(
                                                      // interestClassBookmarkId will be provided if any when toggling save button
                                                      interestClassBookmarkId:
                                                          null,
                                                      source:
                                                          InterestClassSourceType
                                                              .all,
                                                      interestClassData:
                                                          interestClassData,
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: SizeConfig
                                                                  .defaultSize *
                                                              3),
                                                      child: Center(
                                                          child: data
                                                                  .interestClassHasMore
                                                              ? const CircularProgressIndicator(
                                                                  color: Color(
                                                                      0xFFA08875))
                                                              : Text(
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .caughtUp,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          kHelveticaMedium,
                                                                      fontSize:
                                                                          SizeConfig.defaultSize *
                                                                              1.5),
                                                                )),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    )
                  ]);
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
