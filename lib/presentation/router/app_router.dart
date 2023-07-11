import 'package:flutter/material.dart';
import 'package:spa_app/presentation/components/profile/password_change_screen.dart';
import 'package:spa_app/presentation/components/chat/chatroom_screen.dart';
import 'package:spa_app/presentation/views/discover_screen.dart';
import 'package:spa_app/presentation/views/edit_profile_screen.dart';
import 'package:spa_app/presentation/components/interest_class/bookmark_interest_classes.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/language_screen.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/privacy_policy_screen.dart';
import 'package:spa_app/presentation/views/login_screen.dart';
import 'package:spa_app/presentation/views/main_screen.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/new_post_screen.dart';
import 'package:spa_app/presentation/views/registration_screen.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/terms_and_conditions_screen.dart';

Route? onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MainScreen.id:
      return MaterialPageRoute(builder: (context) => const MainScreen());
    case LoginScreen.id:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case HomeScreen.id:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case RegistrationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const RegistrationScreen());
    case TermsAndConditionsScreen.id:
      return MaterialPageRoute(
          builder: (context) => const TermsAndConditionsScreen());
    case PrivacyPolicyScreen.id:
      return MaterialPageRoute(
          builder: (context) => const PrivacyPolicyScreen());
    case DiscoverScreen.id:
      return MaterialPageRoute(builder: (context) => const DiscoverScreen());
    case BookmarkInterestClassesScreen.id:
      return MaterialPageRoute(
          builder: (context) => const BookmarkInterestClassesScreen());

    case MyProfileScreen.id:
      return MaterialPageRoute(builder: (context) => const MyProfileScreen());
    case EditProfileScreen.id:
      return MaterialPageRoute(builder: (context) => const EditProfileScreen());
    case NewPostScreen.id:
      return MaterialPageRoute(builder: (context) => const NewPostScreen());
    case ChatroomScreen.id:
      return MaterialPageRoute(builder: (context) => const ChatroomScreen());
    case PasswordChangeScreen.id:
      return MaterialPageRoute(
          builder: (context) => const PasswordChangeScreen());
    case LanguageScreen.id:
      return MaterialPageRoute(builder: (context) => const LanguageScreen());
    default:
      return null;
  }
}
