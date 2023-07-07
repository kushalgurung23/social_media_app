import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/further_studies_provider.dart';
import 'package:spa_app/presentation/components/further_studies/news_board_list.dart';
import 'package:spa_app/presentation/components/further_studies/parent_ask_list_view.dart';
import 'package:spa_app/presentation/components/further_studies/student_ask_list_view.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/tabs/further_studies_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FurtherStudiesTab extends StatefulWidget {
  const FurtherStudiesTab({Key? key}) : super(key: key);

  @override
  State<FurtherStudiesTab> createState() => _FurtherStudiesTabState();
}

class _FurtherStudiesTabState extends State<FurtherStudiesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: furtherStudiesAppBar(context: context),
      body: Consumer<FurtherStudiesProvider>(
        builder: (context, data, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // News Board list
              const NewsBoardList(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.defaultSize * 2,
                      right: SizeConfig.defaultSize * 2,
                      top: SizeConfig.defaultSize * 2),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).discussUpperCase,
                            style: TextStyle(
                                fontFamily: kHelveticaMedium,
                                fontSize: SizeConfig.defaultSize * 1.8),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  data.goToParentAsk(context: context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize * 0.2),
                                  decoration: data.isParentAsk
                                      ? BoxDecoration(
                                          border: Border(
                                          bottom: BorderSide(
                                              color: const Color(0xFF5545CF),
                                              width:
                                                  SizeConfig.defaultSize * 0.2),
                                        ))
                                      : null,
                                  child: Text(
                                    AppLocalizations.of(context).parentAsk,
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.4,
                                        color: data.isParentAsk
                                            ? const Color(0xFF5545CF)
                                            : const Color(0xFF8897A7)),
                                  ),
                                ),
                              ),
                              SizedBox(width: SizeConfig.defaultSize * 2),
                              GestureDetector(
                                onTap: () {
                                  data.goToStudentAsk(context: context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.defaultSize * 0.2),
                                  decoration: data.isParentAsk
                                      ? null
                                      : BoxDecoration(
                                          border: Border(
                                          bottom: BorderSide(
                                              color: const Color(0xFF5545CF),
                                              width:
                                                  SizeConfig.defaultSize * 0.2),
                                        )),
                                  child: Text(
                                    AppLocalizations.of(context).studentAsk,
                                    style: TextStyle(
                                        fontFamily: kHelveticaMedium,
                                        fontSize: SizeConfig.defaultSize * 1.4,
                                        color: data.isParentAsk
                                            ? const Color(0xFF8897A7)
                                            : const Color(0xFF5545CF)),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: SizeConfig.defaultSize * 2),
                      data.isParentAsk
                          ? const Expanded(child: ParentAskListView())
                          : const Expanded(child: StudentAskListView())
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
