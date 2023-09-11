import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:c_talent/presentation/components/all/top_app_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/constant/font_constant.dart';

AppBar profileAppBar({required BuildContext context}) {
  return topAppBar(title: AppLocalizations.of(context).profile, widgetList: []);
}
