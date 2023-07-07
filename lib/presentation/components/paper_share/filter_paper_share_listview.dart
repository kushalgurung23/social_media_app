import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/paper_share_enum.dart';
import 'package:spa_app/data/models/paper_share_model.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/paper_share/paper_share_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterPaperShareListview extends StatefulWidget {
  const FilterPaperShareListview({Key? key}) : super(key: key);

  @override
  State<FilterPaperShareListview> createState() =>
      _FilterPaperShareListviewState();
}

class _FilterPaperShareListviewState extends State<FilterPaperShareListview> {
  final scrollController = ScrollController();
  @override
  void initState() {
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
    final paperShareProvider =
        Provider.of<PaperShareProvider>(context, listen: false);
    await paperShareProvider.loadMoreFilterResults(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaperShareProvider>(
      builder: (context, data, child) {
        return StreamBuilder<AllPaperShare>(
            stream: data.filterShareStreamController.stream,
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
                    return
                        // If user has filtered for paper share
                        data.filterNoRecord == true
                            ? Flexible(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.defaultSize * 3),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .noPaperShareFound,
                                      style: TextStyle(
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5),
                                    ),
                                  ),
                                ),
                              )
                            :
                            // filter paper share
                            Flexible(
                                child: ListView.builder(
                                  addAutomaticKeepAlives: true,
                                  physics: const AlwaysScrollableScrollPhysics(
                                      parent: BouncingScrollPhysics()),
                                  controller: scrollController,
                                  itemCount: data.filterPaperShareList.isEmpty
                                      ? data.getFilterPaperShareCount(
                                          paperShareList: snapshot.data!.data)
                                      : data.filterPaperShareList.length >=
                                              data.totalInitialFilterPaperShare
                                          ? data.filterPaperShareList.length + 1
                                          : data.filterPaperShareList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index <
                                        data.filterPaperShareList.length) {
                                      List<PaperShare?> allPaperShare =
                                          data.filterPaperShareList;

                                      PaperShare paperData =
                                          allPaperShare[index]!;

                                      return PaperShareContainer(
                                          // paperShareSaveId is provided if available while toggling save button
                                          paperShareSaveId: null,
                                          source: PaperShareSourceType.filter,
                                          paperShare: paperData);
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
                              );
                  }
              }
            });
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
