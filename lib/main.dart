import 'dart:io' show Platform;
import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/network_status_enum.dart';
import 'package:spa_app/data/service/network_service.dart';
import 'package:spa_app/l10n/l10n.dart';
import 'package:spa_app/logic/providers/bottom_nav_provider.dart';
import 'package:spa_app/logic/providers/chat_message_provider.dart';
import 'package:spa_app/logic/providers/discover_provider.dart';
import 'package:spa_app/logic/providers/drawer_provider.dart';
import 'package:spa_app/logic/providers/email_verification_provider.dart';
import 'package:spa_app/logic/providers/interest_class_provider.dart';
import 'package:spa_app/logic/providers/locale_provider.dart';
import 'package:spa_app/logic/providers/login_screen_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/logic/providers/notification_provider.dart';
import 'package:spa_app/logic/providers/profile_provider.dart';
import 'package:spa_app/logic/providers/registration_provider.dart';
import 'package:spa_app/logic/providers/terms_and_conditions_provider.dart';

import 'package:spa_app/presentation/router/app_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.reload();
  // if it is a chat message notification
  if ((message.notification != null && message.notification!.body != null) &&
          message.notification!.body!.contains("has sent you a message.") ||
      message.notification!.body!.contains("已向您发送消息。") ||
      message.notification!.body!.contains("已向您發送消息。")) {
    final bodyList =
        message.notification!.body!.split(" has sent you a message.");

    // if we are currently on chat screen with otheruser, no need to show notification
    if (sharedPreferences.getString('active_chat_username') == bodyList[0] ||
        sharedPreferences.getBool("chatroom_active_status") == true) {
      // print('no need to set chat message push notification');
    } else {
      // print('set chat message push notification');
      await sharedPreferences.setBool('chat_message_push_notification', true);
    }
  }
  // else if it is a follow/unfollow notification
  else if ((message.notification != null &&
              message.notification!.body != null) &&
          message.notification!.body!.contains("started following you.") ||
      message.notification!.body!.contains("开始关注你。") ||
      message.notification!.body!.contains("開始關注你。") ||
      message.notification!.body!.contains("unfollowed you.") ||
      message.notification!.body!.contains("未关注您。") ||
      message.notification!.body!.contains("未關注您。")) {
    // only when we are not in notification tab, show notification badge
    if (sharedPreferences.getBool("notification_tab_active_status") == false) {
      await sharedPreferences.setBool('follow_push_notification', true);
      // print('set follow notification');
    } else {
      // print('no need to set follow notification');
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // REQUESTS FOR PUSH NOTIFICATION PERMISSION IN ANDROID
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  easyLoading();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (Platform.isIOS) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String locateName = sharedPreferences.getString('language_locale') ?? '';

  Locale locate =
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
  if (locateName.isEmpty) {
    Locale deviceLocate = ui.window.locale;
    if (deviceLocate.languageCode == 'zh' &&
        deviceLocate.scriptCode == 'Hant') {
      locate = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    } else if (deviceLocate.languageCode == 'zh' &&
        deviceLocate.scriptCode == 'Hans') {
      locate = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    } else if (deviceLocate.languageCode == 'en') {
      locate = const Locale("en");
    } else {
      locate = const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
    }
    await sharedPreferences.setString('language_locale', locate.toString());
  }

  runApp(const MyApp());
}

void easyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 30.0
    ..textStyle = const TextStyle(
        fontFamily: kHelveticaMedium, fontSize: 14, color: Colors.white)
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        StreamProvider(
            create: ((context) =>
                NetworkService().networkServiceController.stream),
            initialData: NetworkStatus.online),
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(
            create: (context) => LoginScreenProvider(
                mainScreenProvider:
                    Provider.of<MainScreenProvider>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
        ChangeNotifierProvider(
            create: (context) => TermsAndConditionsProvider()),
        ChangeNotifierProvider(
            create: (context) => NewsAdProvider(
                  mainScreenProvider:
                      Provider.of<MainScreenProvider>(context, listen: false),
                  bottomNavProvider:
                      Provider.of<BottomNavProvider>(context, listen: false),
                )),
        ChangeNotifierProvider(
            create: (context) => NotificationProvider(
                mainScreenProvider:
                    Provider.of<MainScreenProvider>(context, listen: false))),
        ChangeNotifierProvider(
            create: (context) => DrawerProvider(
                  mainScreenProvider:
                      Provider.of<MainScreenProvider>(context, listen: false),
                )),
        ChangeNotifierProvider(
            create: (context) => DiscoverProvider(
                  mainScreenProvider:
                      Provider.of<MainScreenProvider>(context, listen: false),
                )),
        ChangeNotifierProvider(
            create: (context) => EmailVerificationProvider()),
        ChangeNotifierProvider(
            create: (context) => InterestClassProvider(
                mainScreenProvider:
                    Provider.of<MainScreenProvider>(context, listen: false))),
        ChangeNotifierProvider(
            create: (context) => ProfileProvider(
                mainScreenProvider:
                    Provider.of<MainScreenProvider>(context, listen: false))),
        ChangeNotifierProvider(
            create: (context) => ChatMessageProvider(
                mainScreenProvider:
                    Provider.of<MainScreenProvider>(context, listen: false))),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, data, child) {
          return MaterialApp(
            builder: EasyLoading.init(),
            navigatorKey: navigatorKey,
            title: 'YuYu Spa',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFFFFFFF),
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
              }),
              primaryColor: Colors.white,
            ),
            onGenerateRoute: onGenerateRoute,
            supportedLocales: L10n.all,
            locale: data.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
