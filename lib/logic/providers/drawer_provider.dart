import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:c_talent/data/enum/navigation_items.dart';
import 'package:c_talent/logic/providers/bottom_nav_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/language_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/privacy_policy_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/terms_and_conditions_screen.dart';
import 'package:c_talent/presentation/views/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerProvider extends ChangeNotifier {
  late SharedPreferences sharedPreferences;
  late MainScreenProvider mainScreenProvider;
  DrawerProvider({required this.mainScreenProvider}) {
    initial();
  }

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  NavigationItems _navigationItem = NavigationItems.home;

  NavigationItems get navigationItem => _navigationItem;

  void setNavigationOnly({required NavigationItems navigationItems}) {
    if (navigationItems == NavigationItems.home) {
      _navigationItem = navigationItems;
      notifyListeners();
    }
  }

  void setAndNavigateToDrawerItem(
      {required NavigationItems navigationItem,
      required BuildContext context}) {
    _navigationItem = navigationItem;
    notifyListeners();
    if (navigationItem == NavigationItems.home) {
      Navigator.of(context).pop();
    } else if (navigationItem == NavigationItems.termsAndConditions) {
      Navigator.of(context).pushNamed(TermsAndConditionsScreen.id);
    } else if (navigationItem == NavigationItems.privacyPolicy) {
      Navigator.of(context).pushNamed(PrivacyPolicyScreen.id);
    } else if (navigationItem == NavigationItems.language) {
      Navigator.of(context).pushNamed(LanguageScreen.id);
    } else {
      Navigator.of(context).pushNamed(HomeScreen.id);
    }
  }

  Future<void> removeCredentials({required BuildContext context}) async {
    Provider.of<BottomNavProvider>(context, listen: false)
        .setBottomIndex(index: 0, context: context);

    final fln = FlutterLocalNotificationsPlugin();
    fln.cancelAll();

    final mainScreenProvider =
        Provider.of<MainScreenProvider>(context, listen: false);
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('isLogin', false);
    mainScreenProvider.isLogin = sharedPreferences.getBool('isLogin') ?? false;
    sharedPreferences.remove('id');
    sharedPreferences.remove('user_name');
    sharedPreferences.remove('user_type');
    sharedPreferences.remove('jwt');
    sharedPreferences.remove('current_password');
    sharedPreferences.remove('device_token');
    sharedPreferences.setBool('follow_push_notification', false);
    sharedPreferences.setBool("notification_tab_active_status", false);
    sharedPreferences.setBool("chatroom_active_status", false);
    if (mainScreenProvider.rememberMeCheckBox == false) {
      sharedPreferences.remove('login_identifier');
      sharedPreferences.remove('login_password');
    }

    await mainScreenProvider.removeUser();

    mainScreenProvider.followerIdList.clear();
    mainScreenProvider.followingIdList.clear();
    mainScreenProvider.likedPostIdList.clear();
    mainScreenProvider.savedNewsPostIdList.clear();
    mainScreenProvider.savedInterestClassIdList.clear();
    if (context.mounted) {
      final newsAdProvider =
          Provider.of<NewsAdProvider>(context, listen: false);
      newsAdProvider.newsCommentControllerList.clear();
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.id, (route) => false);
    }
  }

  Future<void> logOut({required BuildContext context}) async {
    EasyLoading.show(
        status: AppLocalizations.of(context).loggingOut, dismissOnTap: false);
    Provider.of<MainScreenProvider>(context, listen: false).socket.close();
    Provider.of<MainScreenProvider>(context, listen: false).socket.dispose();
    setNavigationOnly(navigationItems: NavigationItems.home);
    await removeCredentials(context: context);
    EasyLoading.dismiss();
  }
}
