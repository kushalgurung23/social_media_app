import 'package:c_talent/logic/providers/profile_follow_provider.dart';
import 'package:c_talent/presentation/components/profile/following_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../data/constant/connection_url.dart';
import '../../../data/constant/font_constant.dart';
import '../../../data/models/all_followings.dart';
import '../../components/all/rectangular_button.dart';
import '../../components/all/top_app_bar.dart';
import '../../helper/size_configuration.dart';

class FollowingScreen extends StatefulWidget {
  static const String id = 'following_screen';

  const FollowingScreen({Key? key}) : super(key: key);

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of followings
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMoreFollowings();
      }
    });

    final profileFollowProvider =
        Provider.of<ProfileFollowProvider>(context, listen: false);

    if (profileFollowProvider.profileFollowings?.followings != null &&
        profileFollowProvider.profileFollowings!.followings!.isNotEmpty) {
      return;
    } else {
      profileFollowProvider.loadInitialProfileFollowings(context: context);
    }

    super.initState();
  }

  Future<void> loadMoreFollowings() async {
    await Provider.of<ProfileFollowProvider>(context, listen: false)
        .loadMoreProfileFollowings(context: context);
  }

// provide key
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topAppBar(
        leadingWidget: IconButton(
          splashRadius: SizeConfig.defaultSize * 2.5,
          icon: Icon(CupertinoIcons.back,
              color: const Color(0xFF8897A7),
              size: SizeConfig.defaultSize * 2.7),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: AppLocalizations.of(context).following,
      ),
      body: Consumer<ProfileFollowProvider>(builder: (context, data, child) {
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
                          AppLocalizations.of(context).noUserFollowedYet,
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
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.defaultSize * 2),
                            child: ListView.builder(
                                controller: scrollController,
                                // If more profile icon is clicked, only show additional profiles
                                itemCount: profileFollowings.length >= 10
                                    ? profileFollowings.length + 1
                                    : profileFollowings.length,
                                itemBuilder: (context, index) {
                                  if (index < profileFollowings.length) {
                                    final followingUser =
                                        profileFollowings[index];
                                    return FollowingContainer(
                                        index: index,
                                        isMe: followingUser.id ==
                                            data.mainScreenProvider.loginSuccess
                                                .user?.id,
                                        followingUser: followingUser);
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.defaultSize * 3),
                                      child: Center(
                                          child: data.hasMoreFollowings
                                              ? const CircularProgressIndicator(
                                                  color: Color(0xFFA08875))
                                              : Text(
                                                  AppLocalizations.of(context)
                                                      .caughtUp,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          kHelveticaMedium,
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          1.5),
                                                )),
                                    );
                                  }
                                }),
                          );
                  }
              }
            });
      }),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
