import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../presentation/helper/size_configuration.dart';

class NotificationAndPromotionProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;

  NotificationAndPromotionProvider({required this.mainScreenProvider});

  String returnMessage({required String type, required BuildContext context}) {
    if (type == 'follow') {
      return AppLocalizations.of(context).startedFollowingYou;
    } else {
      return AppLocalizations.of(context).unfollowedYou;
    }
  }

  Widget returnIcon({required String type}) {
    if (type == 'reply') {
      return SvgPicture.asset(
        "assets/svg/comment.svg",
        width: SizeConfig.defaultSize * 1.3,
        height: SizeConfig.defaultSize * 1.3,
      );
    } else if (type == 'follow' || type == 'unfollow') {
      return Transform.translate(
        offset: const Offset(-2, 0),
        child: SvgPicture.asset(
          "assets/svg/person_follow.svg",
          width: SizeConfig.defaultSize * 1.2,
          height: SizeConfig.defaultSize * 1.3,
        ),
      );
    } else {
      return SvgPicture.asset(
        "assets/svg/heart.svg",
        width: SizeConfig.defaultSize * 1.3,
        height: SizeConfig.defaultSize * 1.3,
      );
    }
  }

  String getMessageTabHeading(
      {required int index, required BuildContext context}) {
    if (index == 0) {
      return AppLocalizations.of(context).followNotifications;
    } else {
      return AppLocalizations.of(context).promotions;
    }
  }
}
