import 'package:flutter/material.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String id = '/';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    Provider.of<MainScreenProvider>(context, listen: false)
        .loadAppPackageInfo();
    if (mounted) {
      Provider.of<MainScreenProvider>(context, listen: false).initial();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(body: Consumer<MainScreenProvider>(
      builder: (context, data, child) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: SizeConfig.defaultSize * 2),
            child: Text(
              'Welcome to\n C Talent Mobile Application',
              style: TextStyle(
                  color: const Color(0xFFA08875),
                  fontFamily: kHelveticaMedium,
                  fontSize: SizeConfig.defaultSize * 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    ));
  }
}
