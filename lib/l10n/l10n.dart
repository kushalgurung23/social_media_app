import 'package:flutter/cupertino.dart';

class L10n {
  static final all = [
    const Locale('en'), // English
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];
}
