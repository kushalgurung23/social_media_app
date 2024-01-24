import 'package:c_talent/presentation/components/profile/bookmark_topic.dart';
import 'package:c_talent/presentation/tabs/profile_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/profile_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: profileAppBar(context: context),
      body: Consumer<ProfileProvider>(builder: (context, data, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
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
              // // Following
              // FollowingContainer(
              //   userId: snapshot.data!.id.toString(),
              // ),
              SizedBox(height: SizeConfig.defaultSize * 5)
            ]),
          ),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
