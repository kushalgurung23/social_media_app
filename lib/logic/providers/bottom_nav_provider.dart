import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/logic/providers/notification_provider.dart';

class BottomNavProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void test() {
    notifyListeners();
  }

  void setBottomIndex(
      {required int index, required BuildContext context}) async {
    // When notification bottom tab is clicked
    if (index == 2) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // the following two sharedPreferences are set to false, because if it is true notification badge won't be popped
      sharedPreferences.setBool("notification_tab_active_status", true);
      notifyListeners();
      if (context.mounted) {
        Provider.of<NewsAdProvider>(context, listen: false)
            .setUnreadNotificationBadge(context: context);
        Provider.of<NotificationProvider>(context, listen: false)
            .refreshPushNotification(context: context);
      }
    }

    _selectedIndex = index;
    notifyListeners();
  }
}
