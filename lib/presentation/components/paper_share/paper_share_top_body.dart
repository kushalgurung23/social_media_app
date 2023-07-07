import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/paper_share_enum.dart';
import 'package:spa_app/data/models/paper_share_model.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/components/all/post_staggered_grid_view.dart';
import 'package:spa_app/presentation/components/paper_share/paper_topic.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

class PaperShareTopBody extends StatelessWidget {
  final PaperShare paperShare;
  final PaperShareSourceType source;
  final String? paperShareSaveId;

  const PaperShareTopBody(
      {Key? key,
      required this.paperShare,
      required this.source,
      required this.paperShareSaveId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaperShareProvider>(
      builder: (context, data, child) {
        final paperShareSaveData =
            paperShare.attributes!.savedPaperShare != null
                ? paperShare.attributes!.savedPaperShare!.data!
                    .firstWhereOrNull((element) =>
                        element != null &&
                        element.attributes!.savedBy!.data!.id.toString() ==
                            data.mainScreenProvider.userId)
                : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.defaultSize,
                  bottom: SizeConfig.defaultSize * 2),
              child: paperShare.attributes!.image!.data == null
                  ? Container(
                      margin: EdgeInsets.only(right: SizeConfig.defaultSize),
                      height: SizeConfig.defaultSize * 28,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/no_image.png"),
                              fit: BoxFit.fitHeight)),
                    )
                  : PostStaggeredGridView(
                      postImage: paperShare.attributes!.image!.data),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PaperTopic(
                  category: AppLocalizations.of(context).subject,
                  categoryValue: data
                              .getSubjectList(context: context)
                              .map((key, value) => MapEntry(value, key))[
                          paperShare.attributes!.subject.toString()] ??
                      paperShare.attributes!.subject.toString(),
                  categoryFontSize: SizeConfig.defaultSize * 1.4,
                  categoryValueFontSize: SizeConfig.defaultSize * 1.5,
                ),
                PaperTopic(
                  category: AppLocalizations.of(context).level,
                  categoryValue: data
                              .getLevelList(context: context)
                              .map((key, value) => MapEntry(value, key))[
                          paperShare.attributes!.level.toString()] ??
                      paperShare.attributes!.level.toString(),
                  categoryFontSize: SizeConfig.defaultSize * 1.4,
                  categoryValueFontSize: SizeConfig.defaultSize * 1.5,
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PaperTopic(
                    category: AppLocalizations.of(context).semester,
                    categoryValue: data
                                .getSemesterList(context: context)
                                .map((key, value) => MapEntry(value, key))[
                            paperShare.attributes!.semester.toString()] ??
                        paperShare.attributes!.semester.toString(),
                    categoryFontSize: SizeConfig.defaultSize * 1.4,
                    categoryValueFontSize: SizeConfig.defaultSize * 1.5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      data.togglePaperShareSave(
                          savedPaperShareId: source ==
                                  PaperShareSourceType.bookmark
                              ? (data.mainScreenProvider.savedPaperShareIdList
                                          .contains(paperShare.id) &&
                                      paperShareSaveId != null
                                  ? paperShareSaveId.toString()
                                  : null)
                              : paperShare.attributes!.savedPaperShare!.data ==
                                      null
                                  ? null
                                  : (data.mainScreenProvider
                                          .savedPaperShareIdList
                                          .contains(paperShare.id)
                                      ? paperShareSaveData?.id.toString()
                                      : null),
                          source: source,
                          context: context,
                          paperShareId: paperShare.id.toString());
                    } catch (e) {
                      throw Exception(e);
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF9F9F9),
                          border: Border.all(
                              color: const Color(0xFFE6E6E6), width: 0.3)),
                      height: SizeConfig.defaultSize * 4.5,
                      width: SizeConfig.defaultSize * 4.5,
                      child: Icon(
                        Icons.bookmark,
                        size: SizeConfig.defaultSize * 3,
                        color: data.mainScreenProvider.savedPaperShareIdList
                                .contains(paperShare.id)
                            ? const Color(0xFF5545CF)
                            : const Color(0xFFA0A0A0),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 2,
            ),
            ExpandableText(
              paperShare.attributes!.content.toString(),
              expandText: AppLocalizations.of(context).showMore,
              collapseText: AppLocalizations.of(context).showLess,
              style: TextStyle(
                  color: const Color(0xFF00153B),
                  fontFamily: kHelveticaRegular,
                  fontSize: SizeConfig.defaultSize * 1.4),
              maxLines: 5,
              textAlign: TextAlign.justify,
              linkStyle: TextStyle(
                  color: const Color(0xFF5545CF),
                  fontFamily: kHelveticaMedium,
                  fontSize: SizeConfig.defaultSize * 1.3),
            ),
          ],
        );
      },
    );
  }
}
