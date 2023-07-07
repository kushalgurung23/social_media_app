import 'package:flutter/material.dart';
import 'package:spa_app/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;
  late SharedPreferences sharedPreferences;
  bool isLanguageChangeButtonClick = false;

  void initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  LocaleProvider() {
    initial();
  }
  void setLocale(Locale newLanguageLocale) async {
    isLanguageChangeButtonClick = true;
    notifyListeners();
    if (!L10n.all.contains(newLanguageLocale)) return;

    _locale = newLanguageLocale;
    await sharedPreferences.setString(
        'language_locale', newLanguageLocale.toString());
    isLanguageChangeButtonClick = false;
    notifyListeners();
  }
}
