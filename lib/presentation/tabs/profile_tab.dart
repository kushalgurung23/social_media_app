import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/logic/providers/profile_follow_provider.dart';
import 'package:c_talent/presentation/components/profile/bookmark_topic.dart';
import 'package:c_talent/presentation/components/profile/profile_following.dart';
import 'package:c_talent/presentation/tabs/profile_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/profile_news_provider.dart';
import '../components/profile/my_topic.dart';
import '../components/profile/profile_top_container.dart';
import '../components/profile/topic_follow_follower.dart';
import '../helper/size_configuration.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with AutomaticKeepAliveClientMixin {
  Future<void> refreshProfileTab() async {
    final profileNewsProvider =
        Provider.of<ProfileNewsProvider>(context, listen: false);
    await Future.wait([
      Provider.of<MainScreenProvider>(context, listen: false).getMyDetails(),
      profileNewsProvider.refreshMyProfileNews(context: context),
      profileNewsProvider.refreshBookmarkProfileNews(context: context),
      Provider.of<ProfileFollowProvider>(context, listen: false)
          .refreshProfileFollowings(context: context)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: profileAppBar(context: context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
        child: RefreshIndicator(
          onRefresh: refreshProfileTab,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Column(children: [
              SizedBox(height: SizeConfig.defaultSize * 2),
              // Top Container
              const ProfileTopContainer(),
              SizedBox(
                height: SizeConfig.defaultSize * 2.5,
              ),
              const TopicFollowFollower(isOtherUser: false),
              SizedBox(
                height: SizeConfig.defaultSize * 2.5,
              ),
              // My Topic
              const MyTopic(),
              SizedBox(
                height: SizeConfig.defaultSize * 2.5,
              ),
              // Bookmarked Topic
              const BookmarkTopic(),
              SizedBox(
                height: SizeConfig.defaultSize * 2.5,
              ),
              // Following
              const ProfileFollowing(),
              SizedBox(height: SizeConfig.defaultSize * 5)
            ]),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
