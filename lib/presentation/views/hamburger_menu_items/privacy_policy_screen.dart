import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/connection_url.dart';
import 'package:c_talent/data/enum/navigation_items.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/presentation/components/all/custom_navigation_drawer.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  static const String id = '/privacy_policy_screen';

  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
    String ppUrl = '$webUrl/PrivacyPolicy/';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String languageLocale =
        sharedPreferences.getString("language_locale") ?? 'zh_Hant';
    if (languageLocale == 'zh_Hant') {
      ppUrl = '$webUrl/PrivacyPolicy/tc.html';
    } else if (languageLocale == 'zh_Hans') {
      ppUrl = '$webUrl/PrivacyPolicy/sc.html';
    } else if (languageLocale == 'en') {
      ppUrl = '$webUrl/PrivacyPolicy/en.html';
    }
    _controller.loadRequest(Uri.parse(ppUrl));
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
        title: AppLocalizations.of(context).privacyPolicy,
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
