import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/further_studies_provider.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiscussTopBody extends StatelessWidget {
  final String title,
      userImage,
      userLevel,
      userName,
      postedTime,
      userType,
      discussContent;
  final int postedByUserId;
  final bool showLevel;

  const DiscussTopBody({
    Key? key,
    required this.postedByUserId,
    required this.showLevel,
    required this.title,
    required this.userImage,
    required this.userLevel,
    required this.userName,
    required this.postedTime,
    required this.userType,
    required this.discussContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FurtherStudiesProvider>(builder: (context, data, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.defaultSize,
                bottom: SizeConfig.defaultSize * 3),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: kHelveticaMedium,
                fontSize: SizeConfig.defaultSize * 2,
              ),
            ),
          ),
          // Profile section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        data.viewUserProfile(
                            userId: postedByUserId,
                            context: context,
                            fromIndex: 2,
                            goToindex: 4);
                      },
                      child: userImage == 'null'
                          ? Container(
                              height: SizeConfig.defaultSize * 4.7,
                              width: SizeConfig.defaultSize * 4.7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.defaultSize * 1.5),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/default_profile.jpg"),
                                      fit: BoxFit.cover)),
                            )
                          : CachedNetworkImage(
                              imageUrl: kIMAGEURL + userImage,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: SizeConfig.defaultSize * 4.7,
                                width: SizeConfig.defaultSize * 4.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.defaultSize * 1.5),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: SizeConfig.defaultSize * 4.7,
                                width: SizeConfig.defaultSize * 4.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.defaultSize * 1.5),
                                  color: const Color(0xFFD0E0F0),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.defaultSize * 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              data.viewUserProfile(
                                  userId: postedByUserId,
                                  context: context,
                                  fromIndex: 2,
                                  goToindex: 4);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  showLevel
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.defaultSize * 0.3),
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.defaultSize,
                                              right:
                                                  SizeConfig.defaultSize * 0.8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: const Color(0xFFC1024F),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFFF722E))),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                    AppLocalizations.of(context)
                                                        .lv,
                                                style: TextStyle(
                                                  fontFamily: kHelveticaMedium,
                                                  fontSize:
                                                      SizeConfig.defaultSize *
                                                          0.8,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: userLevel,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              kHelveticaMedium,
                                                          fontSize: SizeConfig
                                                                  .defaultSize *
                                                              1.1)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(width: SizeConfig.defaultSize),
                                  Text(userName,
                                      style: TextStyle(
                                          fontFamily: kHelveticaMedium,
                                          fontSize:
                                              SizeConfig.defaultSize * 1.4))
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.defaultSize,
                                top: SizeConfig.defaultSize * 0.5),
                            child: Text(postedTime,
                                style: TextStyle(
                                    color: const Color(0xFF8897A7),
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.2)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: SizeConfig.defaultSize * 0.5),
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 1.5,
                    vertical: SizeConfig.defaultSize),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: showLevel
                        ? const Color(0xFFEFE9FF)
                        : const Color(0xFFE9F7FF),
                    border: Border.all(
                        color: showLevel
                            ? const Color(0xFFEFE9FF)
                            : const Color(0xFFDFE6F3),
                        width: 0.5)),
                child: Text(userType,
                    style: TextStyle(
                        color: showLevel
                            ? const Color(0xFF5545CF)
                            : const Color(0xFF457ACF),
                        fontFamily: kHelveticaMedium,
                        fontSize: SizeConfig.defaultSize * 1.25)),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 1.5,
          ),
          //  content
          ExpandableText(
            discussContent,
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
    });
  }
}
