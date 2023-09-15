import 'package:c_talent/presentation/views/auth/forgot_password_email_screen.dart';
import 'package:c_talent/presentation/views/auth/registration_screen.dart';
import 'package:c_talent/presentation/views/chat/chatroom_screen.dart';
import 'package:c_talent/presentation/views/news_posts/new_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/language_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/home_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/privacy_policy_screen.dart';
import 'package:c_talent/presentation/views/main_screen.dart';
import 'package:c_talent/presentation/views/hamburger_menu_items/terms_and_conditions_screen.dart';

import '../views/auth/login_screen.dart';

Route? onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MainScreen.id:
      return MaterialPageRoute(builder: (context) => const MainScreen());
    case LoginScreen.id:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case RegistrationScreen.id:
      return MaterialPageRoute(
          builder: (context) => const RegistrationScreen());
    case ForgotPasswordEmailScreen.id:
      return MaterialPageRoute(
          builder: (context) => const ForgotPasswordEmailScreen());
    case HomeScreen.id:
      return MaterialPageRoute(builder: (context) => const HomeScreen());

    case TermsAndConditionsScreen.id:
      return MaterialPageRoute(
          builder: (context) => const TermsAndConditionsScreen());
    case PrivacyPolicyScreen.id:
      return MaterialPageRoute(
          builder: (context) => const PrivacyPolicyScreen());
    case NewPostScreen.id:
      return MaterialPageRoute(builder: (context) => const NewPostScreen());
    case LanguageScreen.id:
      return MaterialPageRoute(builder: (context) => const LanguageScreen());
    case ChatroomScreen.id:
      return MaterialPageRoute(builder: (context) => const ChatroomScreen());
    default:
      return null;
  }
}
