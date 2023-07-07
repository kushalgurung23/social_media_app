import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/paper_share_model.dart';
import 'package:spa_app/logic/providers/paper_share_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaperDiscussions extends StatelessWidget {
  final List<PaperShareDiscussesData?>? paperShareDiscussionList;

  const PaperDiscussions({Key? key, required this.paperShareDiscussionList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PaperShareProvider>(builder: (context, data, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 2),
        child: SizedBox(
          child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: paperShareDiscussionList!.length,
              itemBuilder: (context, index) {
                paperShareDiscussionList!.sort((a, b) => a!
                    .attributes!.createdAt!
                    .compareTo(b!.attributes!.createdAt!));
                final discussionData = paperShareDiscussionList![index];

                int? discussedById;
                DiscussedByAttributes? discussedBy;
                if (discussionData!.attributes!.discussedBy != null &&
                    discussionData.attributes!.discussedBy!.data != null) {
                  discussedById =
                      discussionData.attributes!.discussedBy!.data!.id;
                  discussedBy =
                      discussionData.attributes!.discussedBy!.data!.attributes!;
                } else {
                  discussedBy = DiscussedByAttributes(
                      username: "(" +
                          AppLocalizations.of(context).deletedAccount +
                          ")",
                      email: null,
                      provider: null,
                      confirmed: null,
                      blocked: null,
                      createdAt: null,
                      updatedAt: null,
                      userType: null,
                      grade: null,
                      teachingType: null,
                      collegeType: null,
                      teachingArea: null,
                      region: null,
                      category: null,
                      profileImage: null,
                      centerName: null,
                      deviceToken: null);
                }

                return data.mainScreenProvider.blockedUsersIdList
                        .contains(discussedById)
                    ? const SizedBox()
                    : Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.defaultSize * 1.5),
                        child: SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image
                              GestureDetector(
                                onTap: () {
                                  if (discussedById != null) {
                                    data.viewUserProfile(
                                        discussedById: discussedById,
                                        context: context,
                                        fromIndex: 1,
                                        goToindex: 4);
                                  }
                                },
                                child: (discussedBy.profileImage == null ||
                                        discussedBy.profileImage!.data == null)
                                    ? CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            "assets/images/default_profile.jpg"),
                                        radius: SizeConfig.defaultSize * 1.5)
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            kIMAGEURL +
                                                discussedBy.profileImage!.data!
                                                    .attributes!.url!),
                                        radius: SizeConfig.defaultSize * 1.5),
                              ),
                              Flexible(
                                child: Column(
                                  // (username, discuss) and (time ago)
                                  children: [
                                    Row(
                                      // username and discuss
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.defaultSize),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (discussedById != null) {
                                                      data.viewUserProfile(
                                                          discussedById:
                                                              discussedById,
                                                          context: context,
                                                          fromIndex: 1,
                                                          goToindex: 4);
                                                    }
                                                  },
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      discussedBy.username
                                                              .toString() +
                                                          " : ",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              kHelveticaMedium,
                                                          fontSize: SizeConfig
                                                                  .defaultSize *
                                                              1.2,
                                                          color: Colors.black,
                                                          height: 1.3),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                    discussionData
                                                        .attributes!.content
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily:
                                                            kHelveticaRegular,
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            1.2,
                                                        color: Colors.black,
                                                        height: 1.3)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.defaultSize * 0.1,
                                          bottom:
                                              SizeConfig.defaultSize * 0.35),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              data.mainScreenProvider
                                                  .convertDateTimeToAgo(
                                                      discussionData.attributes!
                                                          .updatedAt!,
                                                      context),
                                              style: TextStyle(
                                                fontFamily: kHelveticaRegular,
                                                fontSize:
                                                    SizeConfig.defaultSize *
                                                        1.05,
                                                color: const Color(0xFF8897A7),
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              }),
        ),
      );
    });
  }
}
