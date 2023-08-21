import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/logic/providers/discover_provider.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/discover/discover_part_one.dart';
import 'package:c_talent/presentation/components/discover/discover_part_two.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscoverScreen extends StatefulWidget {
  static const String id = '/discover_screen';

  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: topAppBar(
        leadingWidget: IconButton(
          splashRadius: SizeConfig.defaultSize * 2.5,
          icon: Icon(CupertinoIcons.back,
              color: const Color(0xFF8897A7),
              size: SizeConfig.defaultSize * 2.7),
          onPressed: () {
            if (Provider.of<DiscoverProvider>(context, listen: false)
                    .isSearchClick ==
                false) {
              Navigator.pop(context);
            } else {
              Provider.of<DiscoverProvider>(context, listen: false)
                  .backArrowClick(context: context);
            }
          },
        ),
        title: AppLocalizations.of(context).discover,
      ),
      body: Consumer<DiscoverProvider>(
        builder: (context, data, child) {
          return Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize * 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: SizeConfig.defaultSize * 5.5,
                              child: RoundedTextFormField(
                                onChanged: (value) => data.searchUser(
                                    query: value, context: context),
                                textInputType: TextInputType.text,
                                isEnable: true,
                                isReadOnly: false,
                                textEditingController:
                                    data.searchUserTextController,
                                onTap: () {
                                  data.textFieldToggle();
                                },
                                usePrefix: true,
                                useSuffix: false,
                                hintText:
                                    AppLocalizations.of(context).searchUser,
                                prefixIcon: SvgPicture.asset(
                                  "assets/svg/search.svg",
                                  height: SizeConfig.defaultSize * 1.4,
                                  width: SizeConfig.defaultSize * 1.4,
                                ),
                                suffixOnPress: () {},
                                borderRadius: SizeConfig.defaultSize * 0.5,
                              ),
                            ),
                          ),
                          data.isSearchClick == false
                              ? const SizedBox()
                              : SizedBox(
                                  height: SizeConfig.defaultSize * 5.5,
                                  width: SizeConfig.defaultSize * 8,
                                  child: TextButton(
                                    onPressed: () {
                                      data.cancelSearch(context: context);
                                    },
                                    child: Text(
                                      AppLocalizations.of(context).cancel,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kHelveticaRegular,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.5),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.defaultSize * 2),
                    data.isSearchClick
                        ? const DiscoverPartTwo()
                        : const DiscoverPartOne()
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
