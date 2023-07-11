import 'package:flutter/material.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/presentation/components/all/rounded_text_form_field.dart';
import 'package:spa_app/presentation/components/news/news_post_list.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/tabs/news_appbar.dart';
import 'package:spa_app/presentation/views/new_post_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:spa_app/presentation/components/all/custom_navigation_drawer.dart';

class NewsTab extends StatefulWidget {
  const NewsTab({Key? key}) : super(key: key);

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  @override
  void initState() {
    super.initState();
    final mainScreenProvider =
        Provider.of<MainScreenProvider>(context, listen: false);
    mainScreenProvider.initialSocketConnection();
    mainScreenProvider.connectToSocketServer(context: context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      drawerEnableOpenDragGesture: false, // Prevent user sliding open
      drawer: const CustomNavigationDrawer(),
      appBar: newsAppBar(context),
      body: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
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
                  padding: EdgeInsets.only(right: SizeConfig.defaultSize * 0.2),
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
          const NewsPostList(),
        ],
      ),
    );
  }
}
