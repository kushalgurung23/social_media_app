import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/paper_share_enum.dart';
import 'package:spa_app/data/models/paper_share_model.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/paper_share/paper_share_container.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaperShareListview extends StatefulWidget {
  const PaperShareListview({Key? key}) : super(key: key);

  @override
  State<PaperShareListview> createState() => _PaperShareListviewState();
}

class _PaperShareListviewState extends State<PaperShareListview> {
  final scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<PaperShareProvider>(context, listen: false)
        .refresh(context: context);

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
        .loadMorePaperShare(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaperShareProvider>(
      builder: (context, data, child) {
        return StreamBuilder<AllPaperShare>(
            stream: data.paperShareStreamController.stream,
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
                      child: Text(AppLocalizations.of(context).refreshPage,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(AppLocalizations.of(context).dataCouldNotLoad,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else {
                    if (snapshot.data!.data.isEmpty &&
                        data.isRefresh == false) {
                      Center(
                        child: Text(
                          AppLocalizations.of(context).noPaperShareFound,
                          style: TextStyle(
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5),
                        ),
                      );
                    }
                    return snapshot.data!.data.isEmpty &&
                            data.isRefresh == false
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
                                      fontSize: SizeConfig.defaultSize * 1.5),
                                ),
                              ),
                            ),
                          )
                        : snapshot.data!.data.isEmpty && data.isRefresh == true
                            ? Flexible(
                                child: Center(
                                    child: Text(
                                        AppLocalizations.of(context).reloading,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: kHelveticaRegular,
                                            fontSize:
                                                SizeConfig.defaultSize * 1.5))),
                              )
                            : Flexible(
                                child: RefreshIndicator(
                                  onRefresh: () =>
                                      data.refresh(context: context),
                                  child: ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    controller: scrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(
                                            parent: BouncingScrollPhysics()),
                                    itemCount: snapshot.data!.data.length >=
                                            data.totalInitialPaperShareList
                                        ? snapshot.data!.data.length + 1
                                        : snapshot.data!.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index < snapshot.data!.data.length) {
                                        return PaperShareContainer(
                                            // paperShareSaveId is provided if available while toggling save button
                                            paperShareSaveId: null,
                                            source: PaperShareSourceType.all,
                                            paperShare:
                                                snapshot.data!.data[index]);
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  SizeConfig.defaultSize * 3),
                                          child: Center(
                                              child: data.hasMore
                                                  ? const CircularProgressIndicator(
                                                      color: Color(0xFF5545CF))
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
