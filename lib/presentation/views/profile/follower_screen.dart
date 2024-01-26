import 'package:c_talent/data/models/all_followers.dart';
import 'package:c_talent/logic/providers/profile_follow_provider.dart';
import 'package:c_talent/presentation/components/profile/follower_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/font_constant.dart';
import '../../components/all/top_app_bar.dart';
import '../../helper/size_configuration.dart';

class FollowerScreen extends StatefulWidget {
  static const String id = 'follower_screen';

  const FollowerScreen({Key? key}) : super(key: key);

  @override
  State<FollowerScreen> createState() => _FollowerScreenState();
}

class _FollowerScreenState extends State<FollowerScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    // this will load more data when we reach the end of followers
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMoreFollowers();
      }
    });

    final profileFollowProvider =
        Provider.of<ProfileFollowProvider>(context, listen: false);

    if (profileFollowProvider.profileFollowers?.followers != null &&
        profileFollowProvider.profileFollowers!.followers!.isNotEmpty) {
      return;
    } else {
      profileFollowProvider.loadInitialProfileFollowers(context: context);
    }

    super.initState();
  }

  Future<void> loadMoreFollowers() async {
    await Provider.of<ProfileFollowProvider>(context, listen: false)
        .loadMoreProfileFollowers(context: context);
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
        title: AppLocalizations.of(context).follower,
      ),
      body: Consumer<ProfileFollowProvider>(builder: (context, data, child) {
        return StreamBuilder<AllFollowers?>(
            stream: data.profileFollowersStreamController.stream,
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
                      child: Text(AppLocalizations.of(context).noFollower,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5)),
                    );
                  } else {
                    final profileFollowers = snapshot.data?.followers;

                    return profileFollowers == null || profileFollowers.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 3),
                              child: Text(
                                data.isLoadingFollowers == true ||
                                        data.isLoadingFollowers == true
                                    ? AppLocalizations.of(context).loading
                                    : AppLocalizations.of(context).noFollower,
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
                                itemCount: profileFollowers.length >= 10
                                    ? profileFollowers.length + 1
                                    : profileFollowers.length,
                                itemBuilder: (context, index) {
                                  if (index < profileFollowers.length) {
                                    final follower = profileFollowers[index];
                                    return FollowerContainer(
                                        index: index,
                                        isMe: follower.id ==
                                            data.mainScreenProvider.loginSuccess
                                                .user?.id,
                                        followerUser: follower);
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.defaultSize * 3),
                                      child: Center(
                                          child: data.hasMoreFollowers
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
