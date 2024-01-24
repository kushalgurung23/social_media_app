import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/models/profile_news.dart';
import 'package:c_talent/presentation/components/profile/profile_topic_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../data/constant/font_constant.dart';
import '../../../logic/providers/profile_provider.dart';
import '../../helper/size_configuration.dart';

class MyTopic extends StatefulWidget {
  const MyTopic({Key? key}) : super(key: key);

  @override
  State<MyTopic> createState() => _MyTopicState();
}

class _MyTopicState extends State<MyTopic> {
  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false)
        .loadMyInitialProfileNews(context: context);
    super.initState();
  }

  final GlobalKey<FormState> lastTopicKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Container(
        key: lastTopicKey,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFA08875).withOpacity(0.22),
                  offset: const Offset(0, 1),
                  blurRadius: 3)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.defaultSize * 2),
              child: Text(
                AppLocalizations.of(context).myTopic,
                style: TextStyle(
                    color: const Color(0xFFA08875),
                    fontFamily: kHelveticaMedium,
                    fontSize: SizeConfig.defaultSize * 2),
              ),
            ),
            StreamBuilder<AllProfileNews?>(
                stream: data.myProfileNewsStreamController.stream,
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
                          child: Text(
                              AppLocalizations.of(context)
                                  .promotionCouldNotBeLoaded,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.5)),
                        );
                      } else {
                        return snapshot.data?.news == null ||
                                snapshot.data!.news!.isEmpty ||
                                snapshot.data!.count == null ||
                                snapshot.data!.count == 0
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.defaultSize * 3),
                                  child: Text(
                                    data.myProfileNewsIsLoading == true ||
                                            data.isRefreshingMyProfileNews ==
                                                true
                                        ? AppLocalizations.of(context).loading
                                        // translate
                                        : 'You haven\'t created any post yet.',
                                    style: TextStyle(
                                        fontFamily: kHelveticaRegular,
                                        fontSize: SizeConfig.defaultSize * 1.6),
                                  ),
                                ),
                              )
                            : ProfileTopicBody(
                                profileTopicType: ProfileTopicType.myTopic,
                                allProfileNews: snapshot.data!,
                                selectedTopicIndex:
                                    data.selectedMyProfileTopicIndex,
                                goBack: () {
                                  // Value of 0 index is 1
                                  // Value of 1 index is 2
                                  if (data.selectedMyProfileTopicIndex >= 1) {
                                    data.changeMySelectedProfileTopic(
                                        isAdd: false,
                                        context: lastTopicKey.currentContext!);
                                  }
                                },
                                goInfront: () {
                                  // If we our current page number is less than total pages in the list view. [Ex: if (0+1) = 1 < 2]
                                  if (snapshot.data!.count != null &&
                                      data.selectedMyProfileTopicIndex + 1 <
                                          (snapshot.data!.count! / 6).ceil()) {
                                    data.changeMySelectedProfileTopic(
                                        isAdd: true,
                                        context: lastTopicKey.currentContext!);
                                  }
                                },
                              );
                      }
                  }
                })
          ],
        ),
      );
    });
  }
}
