import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void test() {
    notifyListeners();
  }

  void setBottomIndex({required int index, required BuildContext context}) {
    _selectedIndex = index;
    notifyListeners();
  }
}
