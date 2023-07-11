import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void test() {
    notifyListeners();
  }

  void setBottomIndex({required int index, required BuildContext context}) {
    // When notification bottom tab is clicked
    if (index == 2) {
      Provider.of<NewsAdProvider>(context, listen: false)
          .setUnreadNotificationBadge(context: context);
    }
    _selectedIndex = index;
    notifyListeners();
  }
}
