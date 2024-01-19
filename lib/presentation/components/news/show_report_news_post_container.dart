import 'package:c_talent/data/enum/all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/components/all/custom_dropdown_button.dart';
import 'package:c_talent/presentation/components/all/rectangular_button.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

showReportNewsPostContainer(
    {required BuildContext context,
    required String newsPostId,
    required NewsPostFrom newsPostFrom}) {
  return showModalBottomSheet(
    enableDrag: false,
    isDismissible: false,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
      top: Radius.circular(20),
      bottom: Radius.circular(0),
    )),
    isScrollControlled: true,
    context: context,
    builder: (bottomSheetContext) => Consumer<NewsAdProvider>(
      builder: (context, data, child) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: SizedBox(
              height: 350 + MediaQuery.of(context).viewInsets.bottom,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.defaultSize * 2),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Text(
                          AppLocalizations.of(context).report,
                          style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 2,
                              fontFamily: kHelveticaMedium,
                              color: Colors.black),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            splashRadius: SizeConfig.defaultSize * 2.5,
                            icon: Icon(
                              Icons.close,
                              color: const Color(0xFF8897A7),
                              size: SizeConfig.defaultSize * 3,
                            ))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.defaultSize * 2,
                          bottom: SizeConfig.defaultSize * 1.5),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                              child: Text(
                                  '${AppLocalizations.of(context).reason}:',
                                  style: TextStyle(
                                      fontSize: SizeConfig.defaultSize * 1.7,
                                      fontFamily: kHelveticaRegular,
                                      color: Colors.black)),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFD0E0F0),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: CustomDropdownButton(
                                  iconSize: SizeConfig.defaultSize * 4.5,
                                  hintText:
                                      '-${AppLocalizations.of(context).pleaseSelect}-',
                                  value: data.mainScreenProvider
                                      .getReportOptionList(context: context)
                                      .map((key, value) => MapEntry(value,
                                          key))[data.reportNewsPostReasonType],
                                  listItems: data.mainScreenProvider
                                      .getReportOptionList(context: context)
                                      .keys
                                      .toList(),
                                  onChanged: (newKey) {
                                    data.setNewsPostReportReasonType(
                                        context: context,
                                        newsPostReportReason: data
                                            .mainScreenProvider
                                            .getReportOptionList(
                                                context: context)[newKey]
                                            .toString());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data.reportNewsPostReasonType != 'Other'
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.zero,
                            child: SizedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: SizeConfig.defaultSize * 10,
                                    child: Text(
                                        '${AppLocalizations.of(context).otherReason}:',
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 1.7,
                                            fontFamily: kHelveticaRegular,
                                            color: Colors.black)),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xFFD0E0F0),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.defaultSize,
                                              vertical: 0),
                                          border: InputBorder.none,
                                          hintText:
                                              ((data.reportNewsPostReasonType ??
                                                          '') ==
                                                      AppLocalizations.of(
                                                              context)
                                                          .other)
                                                  ? '-${AppLocalizations.of(context).pleaseEnter}-'
                                                  : '',
                                          hintStyle: TextStyle(
                                              color: const Color(0xFF707070),
                                              fontFamily: kHelveticaRegular,
                                              fontSize:
                                                  SizeConfig.defaultSize * 1.7),
                                        ),
                                        enabled: ((data
                                                    .reportNewsPostReasonType ??
                                                '') ==
                                            AppLocalizations.of(context).other),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                SizeConfig.defaultSize * 2.1,
                                            fontFamily: kHelveticaRegular),
                                        onChanged: (newText) {
                                          data.setNewsPostReportOtherReason(
                                              newsPostReportOtherReason:
                                                  newText);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.defaultSize * 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: RectangularButton(
                                textPadding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize * 1.5),
                                height: SizeConfig.defaultSize * 4.2,
                                onPress: () {
                                  data.resetNewsPostReportOption(
                                      context: context);
                                },
                                text: AppLocalizations.of(context).reset,
                                textColor: Colors.white,
                                buttonColor: const Color(0xFFA0A0A0),
                                borderColor: const Color(0xFFFFFFFF),
                                fontFamily: kHelveticaMedium,
                                keepBoxShadow: true,
                                offset: const Offset(0, 3),
                                borderRadius: 4,
                                blurRadius: 6,
                                fontSize: SizeConfig.defaultSize * 1.5,
                              ),
                            ),
                            SizedBox(width: SizeConfig.defaultSize * 2),
                            Expanded(
                              child: RectangularButton(
                                textPadding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize * 1.5),
                                height: SizeConfig.defaultSize * 4.2,
                                onPress: () {
                                  if (data.reportNewsPostReasonType != null) {
                                    if ((data.reportNewsPostReasonType
                                                    .toString() ==
                                                AppLocalizations.of(context)
                                                    .other &&
                                            data.reportNewsPostOtherReason !=
                                                null &&
                                            data.reportNewsPostOtherReason
                                                .toString()
                                                .isNotEmpty) ||
                                        data.reportNewsPostReasonType
                                                .toString() !=
                                            AppLocalizations.of(context)
                                                .other) {
                                      data.reportNewsPost(
                                          newsPostFrom: newsPostFrom,
                                          postId: newsPostId,
                                          context: context);
                                    } else {
                                      data.mainScreenProvider.showSnackBar(
                                          context: bottomSheetContext,
                                          content: AppLocalizations.of(context)
                                              .pleaseEnterOtherReason,
                                          contentColor: Colors.white,
                                          backgroundColor: Colors.red);
                                    }
                                  } else {
                                    data.mainScreenProvider.showSnackBar(
                                        context: bottomSheetContext,
                                        content: AppLocalizations.of(context)
                                            .pleaseSelectReason,
                                        contentColor: Colors.white,
                                        backgroundColor: Colors.red);
                                  }
                                },
                                text: AppLocalizations.of(context).buttonReport,
                                textColor: Colors.white,
                                buttonColor: const Color(0xFFA08875),
                                borderColor: const Color(0xFFFFFFFF),
                                fontFamily: kHelveticaMedium,
                                keepBoxShadow: true,
                                offset: const Offset(0, 3),
                                borderRadius: 4,
                                blurRadius: 6,
                                fontSize: SizeConfig.defaultSize * 1.5,
                              ),
                            ),
                          ],
                        )),
                  ]),
                ),
              )),
        );
      },
    ),
    // enableDrag: false,
  );
}
