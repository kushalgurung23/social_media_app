import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppBar profileAppBar({required BuildContext context}) {
  return topAppBar(title: AppLocalizations.of(context).profile, widgetList: []);
}
