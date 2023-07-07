import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/paper_share/filter_paper_share_listview.dart';
import 'package:spa_app/presentation/components/paper_share/paper_share_filter_container.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/paper_share/paper_share_listview.dart';
import 'package:spa_app/presentation/components/paper_share/search_paper_share_listview.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/tabs/paper_share_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaperShareTab extends StatefulWidget {
  const PaperShareTab({Key? key}) : super(key: key);

  @override
  State<PaperShareTab> createState() => _PaperShareTabState();
}

class _PaperShareTabState extends State<PaperShareTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: paperShareAppBar(context: context),
      body: Consumer<PaperShareProvider>(
        builder: (context, data, child) {
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 1.5),
            child: Column(
              children: [
                Flexible(
                  child: Column(children: [
                    SizedBox(
                      height: SizeConfig.defaultSize * 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          data.paperShareSearchTextController.text != ''
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(
                                      right: SizeConfig.defaultSize),
                                  height: SizeConfig.defaultSize * 4.9,
                                  width: SizeConfig.defaultSize * 4.9,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFF9F9F9),
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: const Color(0xFFE6E6E6),
                                        width: 1,
                                      )),
                                  child: TextButton(
                                    onPressed: () {
                                      showPaperShareFilerContainer(
                                          context: context);
                                    },
                                    child: Center(
                                        child: SvgPicture.asset(
                                      "assets/svg/filter.svg",
                                      height: SizeConfig.defaultSize * 2.5,
                                      width: SizeConfig.defaultSize * 2.5,
                                      color: data.isFilterButtonClick == true
                                          ? const Color(0xFF5545CF)
                                          : const Color(0xFFA1A1A1),
                                    )),
                                  ),
                                ),
                          Expanded(
                            child: SizedBox(
                              height: SizeConfig.defaultSize * 5.0,
                              child: RoundedTextFormField(
                                onChanged: (value) => data.searchForPaperShares(
                                    context: context, query: value),
                                textEditingController:
                                    data.paperShareSearchTextController,
                                textInputType: TextInputType.text,
                                isEnable: true,
                                isReadOnly: false,
                                usePrefix: true,
                                useSuffix: false,
                                hintText: AppLocalizations.of(context)
                                    .searchContentKeyword,
                                prefixIcon: SvgPicture.asset(
                                  "assets/svg/search.svg",
                                  height: SizeConfig.defaultSize * 1.6,
                                  width: SizeConfig.defaultSize * 1.6,
                                ),
                                suffixOnPress: () {},
                                borderRadius: SizeConfig.defaultSize * 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize * 2,
                    ),
                    data.isFilterButtonClick == true
                        ? const FilterPaperShareListview()
                        : data.paperShareSearchTextController.text == ''
                            ? const PaperShareListview()
                            : const SearchPaperShareListview()
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
