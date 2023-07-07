import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/profile/other_user_last_topic_list.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class OtherUserTopic extends StatelessWidget {
  final int otherUserId;
  final List<UserPost?>? allCreatedPost;
  StreamController<User>? otherUserStreamController;
  final GlobalKey<FormState> otherLastTopicKey = GlobalKey<FormState>();
  OtherUserTopic(
      {Key? key,
      required this.allCreatedPost,
      required this.otherUserId,
      this.otherUserStreamController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      return Container(
        key: otherLastTopicKey,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF5545CF).withOpacity(0.22),
                  offset: const Offset(0, 1),
                  blurRadius: 3)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.defaultSize * 2),
              child: Text(
                AppLocalizations.of(context).userTopic,
                style: TextStyle(
                    color: const Color(0xFF5545CF),
                    fontFamily: kHelveticaMedium,
                    fontSize: SizeConfig.defaultSize * 2),
              ),
            ),
            allCreatedPost!.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.defaultSize * 5,
                          bottom: SizeConfig.defaultSize * 7),
                      child: Text(
                        AppLocalizations.of(context).thisUserHasNotCreatedTopic,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    ),
                  )
                : OtherUserLastTopicList(
                    otherUserStreamController: otherUserStreamController!,
                    allCreatedPost: allCreatedPost,
                    otherUserId: otherUserId),
            // Only show bottom left, right button if listview has length equal or greater than 6
            allCreatedPost!.length <= 6
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.defaultSize,
                        bottom: SizeConfig.defaultSize * 2.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Value of 0 index is 1
                            // Value of 1 index is 2
                            if (data.selectedOtherProfileTopicIndex >= 1) {
                              data.changeSelectedOtherProfileTopic(
                                  isAdd: false,
                                  context: otherLastTopicKey.currentContext!);
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFFF9F9F9),
                                  border: Border.all(
                                      color:
                                          data.selectedOtherProfileTopicIndex ==
                                                  0
                                              ? const Color(0xFFE6E6E6)
                                              : const Color(0xFF8897A7),
                                      width: 0.6)),
                              height: SizeConfig.defaultSize * 3.5,
                              width: SizeConfig.defaultSize * 3.5,
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: data.selectedOtherProfileTopicIndex == 0
                                    ? const Color(0xFFD1D3D5)
                                    : const Color(0xFF8897A7),
                                size: SizeConfig.defaultSize * 2.5,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 2),
                          child: Text(
                              '${data.selectedOtherProfileTopicIndex + 1}/${(allCreatedPost!.length / 6).ceil()}',
                              style: TextStyle(
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.7,
                                  color: const Color(0xFF8897A7))),
                        ),
                        GestureDetector(
                          onTap: () {
                            // If we our current page number is less than total pages in the list view. [Ex: if (0+1) = 1 < 2]
                            if (data.selectedOtherProfileTopicIndex + 1 <
                                (allCreatedPost!.length / 6).ceil()) {
                              data.changeSelectedOtherProfileTopic(
                                  isAdd: true,
                                  context: otherLastTopicKey.currentContext!);
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xFFF9F9F9),
                                  border: Border.all(
                                      color:
                                          data.selectedOtherProfileTopicIndex +
                                                      1 >=
                                                  (allCreatedPost!.length / 6)
                                                      .ceil()
                                              ? const Color(0xFFD1D3D5)
                                              : const Color(0xFF8897A7),
                                      width: 0.6)),
                              height: SizeConfig.defaultSize * 3.5,
                              width: SizeConfig.defaultSize * 3.5,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    data.selectedOtherProfileTopicIndex + 1 >=
                                            (allCreatedPost!.length / 6).ceil()
                                        ? const Color(0xFFD1D3D5)
                                        : const Color(0xFF8897A7),
                                size: SizeConfig.defaultSize * 2.5,
                              )),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      );
    });
  }
}
