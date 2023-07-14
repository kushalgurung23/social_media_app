import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/enum/navigation_items.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/presentation/components/all/custom_navigation_drawer.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  static const String id = '/terms_and_conditions_screen';

  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late final WebViewController _controller;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      );
    setWeb();
  }

  void setWeb() async {
    String tncUrl = '$webUrl/TermsAndConditions/';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String languageLocale =
        sharedPreferences.getString("language_locale") ?? 'zh_Hant';
    if (languageLocale == 'zh_Hant') {
      tncUrl = '$webUrl/TermsAndConditions/tc.html';
    } else if (languageLocale == 'zh_Hans') {
      tncUrl = '$webUrl/TermsAndConditions/sc.html';
    } else if (languageLocale == 'en') {
      tncUrl = '$webUrl/TermsAndConditions/en.html';
    }

    _controller.loadRequest(Uri.parse(tncUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomNavigationDrawer(),
      appBar: topAppBar(
        leadingWidget: IconButton(
          splashRadius: SizeConfig.defaultSize * 2.5,
          icon: Icon(CupertinoIcons.back,
              color: const Color(0xFF8897A7),
              size: SizeConfig.defaultSize * 2.7),
          onPressed: () {
            final drawerProvider =
                Provider.of<DrawerProvider>(context, listen: false);
            if (drawerProvider.navigationItem != NavigationItems.home) {
              drawerProvider.setNavigationOnly(
                  navigationItems: NavigationItems.home);
            }
            Navigator.of(context).pop();
          },
        ),
        title: AppLocalizations.of(context).termsAndConditions,
      ),
      body: Stack(
        children: <Widget>[
          WebViewWidget(controller: _controller),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
    );
  }
}
