import 'package:flutter/material.dart';
import 'package:spa_app/presentation/components/profile/password_change_screen.dart';
import 'package:spa_app/presentation/components/paper_share/bookmark_paper_share_listview.dart';
import 'package:spa_app/presentation/views/center_register_screen_one.dart';
import 'package:spa_app/presentation/views/center_register_screen_two.dart';
import 'package:spa_app/presentation/components/chat/chatroom_screen.dart';
import 'package:spa_app/presentation/views/discover_screen.dart';
import 'package:spa_app/presentation/views/edit_profile_screen.dart';
import 'package:spa_app/presentation/components/interest_class/bookmark_interest_classes.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/language_screen.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/privacy_policy_screen.dart';
import 'package:spa_app/presentation/views/login_screen.dart';
import 'package:spa_app/presentation/views/main_screen.dart';
import 'package:spa_app/presentation/views/notification_screen.dart';
import 'package:spa_app/presentation/views/my_profile_screen.dart';
import 'package:spa_app/presentation/views/new_post_screen.dart';
import 'package:spa_app/presentation/views/paper_share_new_post.dart';
import 'package:spa_app/presentation/views/parent_register_screen.dart';
import 'package:spa_app/presentation/views/register_screen.dart';
import 'package:spa_app/presentation/views/student_register_screen.dart';
import 'package:spa_app/presentation/views/hamburger_menu_items/terms_and_conditions_screen.dart';
import 'package:spa_app/presentation/views/tutor_register_screen_one.dart';
import 'package:spa_app/presentation/views/tutor_register_screen_two.dart';

Route? onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MainScreen.id:
      return MaterialPageRoute(builder: (context) => const MainScreen());
    case LoginScreen.id:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case HomeScreen.id:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    case RegisterScreen.id:
      return MaterialPageRoute(builder: (context) => const RegisterScreen());
    case ParentRegistrationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const ParentRegistrationScreen());
    case TutorRegisterScreenOne.id:
      return MaterialPageRoute(
          builder: (context) => const TutorRegisterScreenOne());
    case TutorRegisterScreenTwo.id:
      return MaterialPageRoute(
          builder: (context) => const TutorRegisterScreenTwo());
    case StudentRegistrationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const StudentRegistrationScreen());
    case CenterRegisterScreenOne.id:
      return MaterialPageRoute(
          builder: (context) => const CenterRegisterScreenOne());
    case CenterRegisterScreenTwo.id:
      return MaterialPageRoute(
          builder: (context) => const CenterRegisterScreenTwo());
    case TermsAndConditionsScreen.id:
      return MaterialPageRoute(
          builder: (context) => const TermsAndConditionsScreen());
    case PrivacyPolicyScreen.id:
      return MaterialPageRoute(
          builder: (context) => const PrivacyPolicyScreen());
    case NotificationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const NotificationScreen());
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
    case PaperShareNewPost.id:
      return MaterialPageRoute(builder: (context) => const PaperShareNewPost());
    case BookmarkPaperShareListview.id:
      return MaterialPageRoute(
          builder: (context) => const BookmarkPaperShareListview());
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
