import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/logic/providers/interest_class_provider.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/interest_class/all_interest_classes.dart';
import 'package:c_talent/presentation/components/interest_class/filter_interest_classes.dart';
import 'package:c_talent/presentation/components/interest_class/interest_class_filter_container.dart';
import 'package:c_talent/presentation/components/interest_class/search_interest_classes.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/tabs/interest_class_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InterestClassTab extends StatefulWidget {
  const InterestClassTab({Key? key}) : super(key: key);

  @override
  State<InterestClassTab> createState() => _InterestClassTabState();
}

class _InterestClassTabState extends State<InterestClassTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: interestAppBar(context: context),
      body: Consumer<InterestClassProvider>(builder: (context, data, child) {
        return Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: SizedBox(
                height: SizeConfig.defaultSize * 5.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    data.interestClassSearchTextController.text != ''
                        ? const SizedBox()
                        : Container(
                            margin:
                                EdgeInsets.only(right: SizeConfig.defaultSize),
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
                                showInterestClassFilerContainer(
                                    context: context);
                              },
                              child: Center(
                                  child: SvgPicture.asset(
                                "assets/svg/filter.svg",
                                height: SizeConfig.defaultSize * 2.5,
                                width: SizeConfig.defaultSize * 2.5,
                                color: data.isFilterButtonClick == true
                                    ? const Color(0xFFA08875)
                                    : const Color(0xFFA1A1A1),
                              )),
                            ),
                          ),
                    Expanded(
                      child: SizedBox(
                        height: SizeConfig.defaultSize * 5.0,
                        child: RoundedTextFormField(
                          onChanged: (value) =>
                              data.searchForInterestClassCourses(
                                  query: value, context: context),
                          textEditingController:
                              data.interestClassSearchTextController,
                          textInputType: TextInputType.text,
                          isEnable: true,
                          isReadOnly: false,
                          usePrefix: true,
                          useSuffix: false,
                          hintText:
                              AppLocalizations.of(context).searchTitleKeyword,
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
            ),
            SizedBox(height: SizeConfig.defaultSize * 2),
            // when user filters interest class
            data.isFilterButtonClick == true
                ? const Flexible(child: FilterInterestClasses())
                : data.interestClassSearchTextController.text == ''
                    // default view
                    ? const Flexible(child: AllInterestClasses())
                    // when user searches on search field
                    : const Flexible(child: SearchInterestClasses()),
          ],
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
