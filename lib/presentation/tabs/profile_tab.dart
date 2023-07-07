import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/models/user_model.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/presentation/components/profile/bookmarked_topic.dart';
import 'package:spa_app/presentation/components/profile/following_container.dart';
import 'package:spa_app/presentation/components/profile/my_topic.dart';
import 'package:spa_app/presentation/components/profile/profile_top_container.dart';
import 'package:spa_app/presentation/components/profile/topic_follow_follower.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/tabs/profile_appbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: profileAppBar(context: context),
      body: Consumer<ProfileProvider>(builder: (context, data, child) {
        return StreamBuilder<User>(
            initialData: data.mainScreenProvider.currentUser,
            stream: data.mainScreenProvider.currentUserController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).loading,
                      style: TextStyle(
                          fontFamily: kHelveticaRegular,
                          fontSize: SizeConfig.defaultSize * 1.5),
                    ),
                  );
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).refreshPage,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context).dataCouldNotLoad,
                        style: TextStyle(
                            fontFamily: kHelveticaRegular,
                            fontSize: SizeConfig.defaultSize * 1.5),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize * 2),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        child: Column(children: [
                          SizedBox(height: SizeConfig.defaultSize * 2),
                          // Top Container
                          ProfileTopContainer(user: snapshot.data!),
                          SizedBox(
                            height: SizeConfig.defaultSize * 2.5,
                          ),
                          TopicFollowFollower(
                              user: snapshot.data!, isOtherUser: false),
                          SizedBox(
                            height: SizeConfig.defaultSize * 2.5,
                          ),
                          // My Topic
                          MyTopic(createdPost: snapshot.data!.createdPost),
                          SizedBox(
                            height: SizeConfig.defaultSize * 2.5,
                          ),
                          // Bookmarked Topic
                          BookmarkedTopic(
                              bookMarkedTopic: snapshot.data!.newsPostSaves),
                          SizedBox(
                            height: SizeConfig.defaultSize * 2.5,
                          ),
                          // Following
                          FollowingContainer(
                            userId: snapshot.data!.id.toString(),
                          ),
                          SizedBox(height: SizeConfig.defaultSize * 5)
                        ]),
                      ),
                    );
                  }
              }
            });
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
