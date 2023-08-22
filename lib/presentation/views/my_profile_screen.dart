import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/data/models/user_model.dart';
import 'package:c_talent/logic/providers/profile_provider.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/components/profile/bookmarked_topic.dart';
import 'package:c_talent/presentation/components/profile/following_container.dart';
import 'package:c_talent/presentation/components/profile/my_topic.dart';
import 'package:c_talent/presentation/components/profile/profile_top_container.dart';
import 'package:c_talent/presentation/components/profile/topic_follow_follower.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/views/edit_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyProfileScreen extends StatelessWidget {
  static const String id = '/my_profile_screen';
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, data, child) {
      final mainProviderData = data.mainScreenProvider;
      return Scaffold(
        appBar: topAppBar(
            title: AppLocalizations.of(context).profile,
            leadingWidget: IconButton(
              splashRadius: SizeConfig.defaultSize * 2.5,
              icon: Icon(CupertinoIcons.back,
                  color: const Color(0xFF8897A7),
                  size: SizeConfig.defaultSize * 2.7),
              onPressed: () {
                data.resetTopicSelectedIndex();
                Navigator.pop(context);
              },
            ),
            widgetList: [
              Builder(builder: (context) {
                return Consumer<ProfileProvider>(
                    builder: (context, data, child) {
                  return Padding(
                    padding:
                        EdgeInsets.only(right: SizeConfig.defaultSize * 0.5),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          if (data.image != null) {
                            data.image = null;
                          }
                          Navigator.pushReplacementNamed(
                              context, EditProfileScreen.id);
                        },
                        icon: SvgPicture.asset(
                          'assets/svg/edit.svg',
                          color: const Color(0xFF8897A7),
                          height: SizeConfig.defaultSize * 2.5,
                          width: SizeConfig.defaultSize * 2.5,
                        ),
                        splashRadius: SizeConfig.defaultSize * 2.5,
                      ),
                    ),
                  );
                });
              })
            ]),
        body: StreamBuilder<User>(
          stream: mainProviderData.currentUserController.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    AppLocalizations.of(context).loading,
                    style: TextStyle(
                      fontFamily: kHelveticaRegular,
                      fontSize: SizeConfig.defaultSize * 1.5,
                    ),
                  ),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.defaultSize * 2),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(height: SizeConfig.defaultSize * 2),
                        // Top Container
                        // ProfileTopContainer(
                        //     user: mainProviderData.currentUser!),
                        SizedBox(
                          height: SizeConfig.defaultSize * 2.5,
                        ),
                        TopicFollowFollower(
                            user: snapshot.data!, isOtherUser: false),
                        SizedBox(
                          height: SizeConfig.defaultSize * 2.5,
                        ),
                        // Last Topic
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
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).refreshPage,
                      style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).dataCouldNotLoad,
                      style: TextStyle(
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5,
                      ),
                    ),
                  );
                }
            }
          },
        ),
      );
    });
  }
}
