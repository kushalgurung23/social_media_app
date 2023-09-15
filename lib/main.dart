import 'dart:io' show Platform;
import 'package:c_talent/logic/providers/auth_provider.dart';
import 'package:c_talent/logic/providers/chat_message_provider.dart';
import 'package:c_talent/logic/providers/registration_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:c_talent/data/constant/font_constant.dart';
import 'package:c_talent/l10n/l10n.dart';
import 'package:c_talent/logic/providers/bottom_nav_provider.dart';
import 'package:c_talent/logic/providers/drawer_provider.dart';
import 'package:c_talent/logic/providers/login_screen_provider.dart';
import 'package:c_talent/logic/providers/main_screen_provider.dart';
import 'package:c_talent/logic/providers/news_ad_provider.dart';
import 'package:c_talent/presentation/router/app_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(
            create: (context) => RegistrationProvider(
                  mainScreenProvider:
                      Provider.of<MainScreenProvider>(context, listen: false),
                )),
        ChangeNotifierProvider(
            create: (context) => LoginScreenProvider(
                mainScreenProvider:
                    Provider.of<MainScreenProvider>(context, listen: false))),
        ChangeNotifierProvider(
            create: (context) => AuthProvider(
                mainScreenProvider:
                    Provider.of<MainScreenProvider>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
        ChangeNotifierProvider(
            create: (context) => NewsAdProvider(
                  authProvider:
                      Provider.of<AuthProvider>(context, listen: false),
                  mainScreenProvider:
                      Provider.of<MainScreenProvider>(context, listen: false),
                  bottomNavProvider:
                      Provider.of<BottomNavProvider>(context, listen: false),
                )),
        ChangeNotifierProvider(
            create: (context) => DrawerProvider(
                  mainScreenProvider:
                      Provider.of<MainScreenProvider>(context, listen: false),
                )),
        ChangeNotifierProvider(
            create: (context) => ChatMessageProvider(
                  mainScreenProvider:
                      Provider.of<MainScreenProvider>(context, listen: false),
                )),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        navigatorKey: navigatorKey,
        title: 'C Talent',
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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
