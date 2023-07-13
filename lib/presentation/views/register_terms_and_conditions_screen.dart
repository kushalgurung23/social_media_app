import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spa_app/data/constant/color_constant.dart';
import 'package:spa_app/data/constant/connection_url.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/logic/providers/terms_and_conditions_provider.dart';
import 'package:spa_app/presentation/components/all/custom_checkbox.dart';
import 'package:spa_app/presentation/components/all/rectangular_button.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterTermsAndConditionsScreen extends StatefulWidget {
  final bool? isParent, isStudent, isTutor, isCenter;
  final String emailAddress;

  const RegisterTermsAndConditionsScreen(
      {Key? key,
      this.isParent,
      this.isStudent,
      this.isTutor,
      this.isCenter,
      required this.emailAddress})
      : super(key: key);

  @override
  State<RegisterTermsAndConditionsScreen> createState() =>
      _RegisterTermsAndConditionsScreenState();
}

class _RegisterTermsAndConditionsScreenState
    extends State<RegisterTermsAndConditionsScreen>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  bool _isLoading = true;

  int _selectedTabIndex = 0;

  String _tncUrl = '';
  String _ppUrl = '';

  @override
  void initState() {
    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      );
    setWeb();
    super.initState();
  }

  void setWeb() async {
    _tncUrl = '$webUrl/TermsAndConditions/';
    _ppUrl = '$webUrl/PrivacyPolicy/';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String languageLocale =
        sharedPreferences.getString("language_locale") ?? 'zh_Hant';
    if (languageLocale == 'zh_Hant') {
      _tncUrl = '$webUrl/TermsAndConditions/tc.html';
      _ppUrl = '$webUrl/PrivacyPolicy/tc.html';
    } else if (languageLocale == 'zh_Hans') {
      _tncUrl = '$webUrl/TermsAndConditions/sc.html';
      _ppUrl = '$webUrl/PrivacyPolicy/sc.html';
    } else if (languageLocale == 'en') {
      _tncUrl = '$webUrl/TermsAndConditions/en.html';
      _ppUrl = '$webUrl/PrivacyPolicy/en.html';
    }
    _controller
        .loadRequest(Uri.parse((_selectedTabIndex == 0) ? _tncUrl : _ppUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TermsAndConditionsProvider>(
        builder: (context, data, child) {
      return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              appBar: topAppBar(
                  leadingWidget: IconButton(
                    splashRadius: SizeConfig.defaultSize * 2.5,
                    icon: Icon(CupertinoIcons.back,
                        color: const Color(0xFF8897A7),
                        size: SizeConfig.defaultSize * 2.7),
                    onPressed: () {
                      data.undoCheckBox();

                      Navigator.pop(context);
                    },
                  ),
                  title: AppLocalizations.of(context).register),
              body: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.defaultSize * 2,
                    right: SizeConfig.defaultSize * 1.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.defaultSize),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: RectangularButton(
                                textPadding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.defaultSize * 0.1),
                                height: SizeConfig.defaultSize * 4.2,
                                onPress: () async {
                                  if (!_isLoading) {
                                    _controller.loadRequest(Uri.parse(_tncUrl));
                                    setState(() {
                                      _selectedTabIndex = 0;
                                    });
                                  }
                                },
                                text: AppLocalizations.of(context)
                                    .termsAndConditions,
                                textColor: (_selectedTabIndex == 0)
                                    ? Colors.white
                                    : const Color(0xFFA08875),
                                buttonColor: (_selectedTabIndex == 0)
                                    ? const Color(0xFFA08875)
                                    : Colors.white,
                                borderColor: (_selectedTabIndex == 0)
                                    ? const Color(0xFFA08875)
                                    : const Color(0xFF5349C7),
                                fontFamily: kHelveticaMedium,
                                keepBoxShadow: false,
                                borderRadius: 6,
                                fontSize: SizeConfig.defaultSize * 1.1,
                              ),
                            ),
                            const SizedBox(width: 5, height: 3),
                            Expanded(
                                child: RectangularButton(
                              textPadding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.defaultSize * 0.1),
                              height: SizeConfig.defaultSize * 4.2,
                              onPress: () async {
                                if (!_isLoading) {
                                  _controller.loadRequest(Uri.parse(_ppUrl));
                                  setState(() {
                                    _selectedTabIndex = 1;
                                  });
                                }
                              },
                              text: AppLocalizations.of(context).privacyPolicy,
                              textColor: (_selectedTabIndex == 1)
                                  ? Colors.white
                                  : const Color(0xFFA08875),
                              buttonColor: (_selectedTabIndex == 1)
                                  ? const Color(0xFFA08875)
                                  : Colors.white,
                              borderColor: (_selectedTabIndex == 1)
                                  ? const Color(0xFFA08875)
                                  : const Color(0xFF5349C7),
                              fontFamily: kHelveticaMedium,
                              keepBoxShadow: false,
                              borderRadius: 6,
                              fontSize: SizeConfig.defaultSize * 1.1,
                            ))
                          ]),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          WebViewWidget(controller: _controller),
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                )
                              : Stack(),
                        ],
                      ),
                    ),
                    Center(
                      child: CustomCheckbox(
                        checkboxValue: data.returnCheckBoxValue(),
                        onChanged: (value) {
                          data.setCheckBoxValue(newValue: value!);
                        },
                        title: RichText(
                          maxLines: 3,
                          text: TextSpan(
                            text: AppLocalizations.of(context).iAgreeWith,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: kHelveticaRegular,
                              fontSize: SizeConfig.defaultSize * 1.5,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)
                                    .termsAndConditions,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5,
                                    color: const Color(0xFF3F6D89),
                                    decoration: TextDecoration.underline),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context).and,
                                style: TextStyle(
                                  fontFamily: kHelveticaRegular,
                                  fontSize: SizeConfig.defaultSize * 1.5,
                                ),
                              ),
                              TextSpan(
                                text:
                                    AppLocalizations.of(context).privacyPolicy,
                                style: TextStyle(
                                    fontFamily: kHelveticaRegular,
                                    fontSize: SizeConfig.defaultSize * 1.5,
                                    color: const Color(0xFF3F6D89),
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                        inCenter: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.defaultSize * 2,
                          bottom: SizeConfig.defaultSize * 2),
                      child: RectangularButton(
                          textPadding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 1.5),
                          offset: const Offset(0, 3),
                          borderRadius: 6,
                          blurRadius: 6,
                          fontSize: SizeConfig.defaultSize * 1.5,
                          keepBoxShadow: true,
                          height: SizeConfig.defaultSize * 4.2,
                          width: SizeConfig.defaultSize * 21.4,
                          onPress: () async {
                            await data.sendEmail(
                              context: context,
                              recipientEmailAddress: widget.emailAddress,
                            );
                            data.undoCheckBox();
                          },
                          text: AppLocalizations.of(context).nextButton,
                          textColor: Colors.white,
                          buttonColor: const Color(0xFFA08875),
                          borderColor: const Color(0xFFC5966F),
                          fontFamily: kHelveticaRegular),
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
