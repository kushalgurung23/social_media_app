import 'package:flutter/material.dart';
import 'package:spa_app/presentation/components/all/top_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppBar furtherStudiesAppBar({required BuildContext context}) {
  return topAppBar(
    title: AppLocalizations.of(context).furtherStudies,
  );
}
