import 'package:c_talent/data/models/all_followings.dart';
import 'package:c_talent/logic/providers/profile_follow_provider.dart';
import 'package:c_talent/presentation/components/profile/profile_following_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/font_constant.dart';
import '../../helper/size_configuration.dart';

class ProfileFollowing extends StatefulWidget {
  const ProfileFollowing({Key? key}) : super(key: key);

  @override
  State<ProfileFollowing> createState() => _ProfileFollowingState();
}

class _ProfileFollowingState extends State<ProfileFollowing> {
  @override
  void initState() {
    Provider.of<ProfileFollowProvider>(context, listen: false)
        .loadInitialProfileFollowings(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileFollowProvider>(
      builder: (context, data, child) {
        return StreamBuilder<AllFollowings?>(
            stream: data.profileFollowingsStreamController.stream,
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
                    final profileFollowings = snapshot.data?.followings;

                    return profileFollowings == null ||
                            profileFollowings.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 3),
                              child: Text(
                                data.isLoadingFollowings == true ||
                                        data.isLoadingFollowings == true
                                    ? AppLocalizations.of(context).loading
                                    : AppLocalizations.of(context)
                                        .noUserFollowedYet,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5),
                              ),
                            ),
                          )
                        : ProfileFollowingBody(
                            profileFollowings: profileFollowings,
                            followingsCount: snapshot.data?.count,
                          );
                  }
              }
            });
      },
    );
  }
}
