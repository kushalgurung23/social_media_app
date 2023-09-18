import 'dart:async';
import 'package:c_talent/data/enum/all.dart';
import 'package:c_talent/data/service/user_secure_storage.dart';
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/bottom_nav_provider.dart';
import 'package:c_talent/logic/providers/login_screen_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/views/auth/login_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/language_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/privacy_policy_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/terms_and_conditions_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class DrawerProvider extends ChangeNotifier {
  late MainScreenProvider mainScreenProvider;
  DrawerProvider({required this.mainScreenProvider});

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
    Provider.of<MainScreenProvider>(context, listen: false)
        .removeUserLoginDetails();
    // THIS WILL ALLOW USER TO REFRESH ACCESS TOKEN WHEN THEY RE-LOGIN
    Provider.of<AuthProvider>(context, listen: false)
        .setCanRefreshToken(canRefreshingToken: true);

    final fln = FlutterLocalNotificationsPlugin();
    fln.cancelAll();
    await UserSecureStorage.removeSecuredUserDetails();
    if (context.mounted) {
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.id, (route) => false);
    }
  }

  Future<void> logOut(
      {required BuildContext context, bool isShowLoggingOut = false}) async {
    if (isShowLoggingOut == true) {
      EasyLoading.show(
          status: AppLocalizations.of(context).loggingOut, dismissOnTap: false);
    }
    Provider.of<LoginScreenProvider>(context, listen: false)
        .toggleKeepUserLoggedIn(newValue: false);
    setNavigationOnly(navigationItems: NavigationItems.home);
    await removeCredentials(context: context);
    if (isShowLoggingOut == true) {
      EasyLoading.dismiss();
    }
  }
}
