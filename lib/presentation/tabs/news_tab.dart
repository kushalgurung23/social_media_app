import 'dart:async';
import 'package:c_talent/data/models/all_news_posts.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/logic/providers/socketio_provider.dart';
import 'package:c_talent/presentation/views/news_posts/new_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/presentation/components/all/rounded_text_form_field.dart';
import 'package:c_talent/presentation/components/news/news_post_list.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/tabs/news_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:c_talent/presentation/components/all/custom_navigation_drawer.dart';
import 'package:rxdart/subjects.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  final scrollController = ScrollController();
  // All news are added to sink of this controller
  StreamController<AllNewsPosts> allNewsPostStreamController =
      BehaviorSubject();

  @override
  void initState() {
    super.initState();
    final SocketIoProvider socketIoProvider =
        Provider.of<SocketIoProvider>(context, listen: false);
    socketIoProvider.initialSocketConnection();
    socketIoProvider.handleSocketEvents(context: context);
    final newsAdProvider = Provider.of<NewsAdProvider>(context, listen: false);

    // this will load initial news posts in the news posts tab
    newsAdProvider.refreshNewsPosts(
        context: context, allNewsPostController: allNewsPostStreamController);

    // this will load more data when we reach the end of news posts

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadNextData();
      }
    });
  }

  void loadNextData() async {
    await Provider.of<NewsAdProvider>(context, listen: false).loadMoreNewsPosts(
        context: context, allNewsPostController: allNewsPostStreamController);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      drawerEnableOpenDragGesture: false, // Prevent user sliding open
      drawer: const CustomNavigationDrawer(),
      appBar: newsAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<NewsAdProvider>(context, listen: false)
            .refreshNewsPosts(
                context: context,
                allNewsPostController: allNewsPostStreamController),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize * 2),
                child: RoundedTextFormField(
                    donotFocus: true,
                    onTap: () {
                      Navigator.pushNamed(context, NewPostScreen.id);
                    },
                    textInputType: TextInputType.text,
                    isEnable: true,
                    isReadOnly: true,
                    usePrefix: false,
                    useSuffix: true,
                    hintText: AppLocalizations.of(context).createANewPost,
                    suffixIcon: Padding(
                      padding:
                          EdgeInsets.only(right: SizeConfig.defaultSize * 0.2),
                      child: Icon(
                        Icons.add_circle,
                        color: const Color(0xFFA08875),
                        size: SizeConfig.defaultSize * 3.5,
                      ),
                    ),
                    suffixOnPress: () {
                      Navigator.pushNamed(context, NewPostScreen.id);
                    },
                    borderRadius: SizeConfig.defaultSize * 4),
              ),
              SizedBox(height: SizeConfig.defaultSize * 1.5),
              NewsPostList(
                  allNewsPostStreamController: allNewsPostStreamController),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    allNewsPostStreamController.close();
    super.dispose();
  }
}
