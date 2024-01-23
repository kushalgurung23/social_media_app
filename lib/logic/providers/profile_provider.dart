import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  late final MainScreenProvider mainScreenProvider;

  ProfileProvider({required this.mainScreenProvider});
}
