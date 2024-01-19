import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:c_talent/logic/providers/bottom_nav_provider.dart';
import 'package:c_talent/presentation/components/all/bottom_nav_bar.dart';
import 'package:c_talent/presentation/helper/size_configuration.dart';
import 'package:c_talent/presentation/tabs/service_tab.dart';
import 'package:c_talent/presentation/tabs/news_tab.dart';
import 'package:c_talent/presentation/tabs/notification_and_promotion_tab.dart';
import 'package:c_talent/presentation/tabs/profile_tab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> _firebaseMessagingBackgroundTerminationHandler(
      RemoteMessage message) async {
    // making sure that the firebase is initialized before using firebase services in the background or terminated state
    await Firebase.initializeApp();
    await loadFCM();
    // showFlutterNotification(message);
  }

// setup flutter heads up notification
  Future<void> loadFCM() async {
    if (isFlutterLocalNotificationsInitialized == true) {
      return;
    }
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'ctalent', // id
          'High Importance Notifications', // title
          description:
              'This channel is used for important notifications.', // description
          importance: Importance.high,
          enableVibration: true);
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings('app_icon'),
          ),
        );
      }
      // Create an Android Notification Channel
      // This channel will be used in 'AndroidManifest.xml' file to override the default FCM channel to enable heads up notification
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      isFlutterLocalNotificationsInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initDynamicLinks();
    initFunctions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  initFunctions() async {
    await loadFCM();
    listenOnForegroundState();
    //listenOnBackgroundState();
    listenOnTerminatedState();
  }

  Future<void> initDynamicLinks() async {
    if (mounted) {
      // final mainProvider =
      //     Provider.of<MainScreenProvider>(context, listen: false);

      // // APP ON TERMINATED STATE
      // // Check if you received the link via `getInitialLink` first
      // final PendingDynamicLinkData? initialLink =
      //     await FirebaseDynamicLinks.instance.getInitialLink();

      // if (initialLink != null) {
      //   final Uri deepLink = initialLink.link;
      //   // ignore: use_build_context_synchronously
      //   mainProvider.navigateRouteFromDynamicLink(
      //       deepLink: deepLink, context: context);
      // }

      // // APP ON FOREGROUND AND BACKGROUND STATE
      // FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      //   Uri? appRunningDeepLink = dynamicLinkData.link;
      //   mainProvider.navigateRouteFromDynamicLink(
      //       deepLink: appRunningDeepLink, context: context);
      // });
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {}
  }

  // FOREGROUND STATE
  void listenOnForegroundState() async {
    // FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  // BACKGROUND ON NOTIFICATION CLICK
  // void listenOnBackgroundState() {
  //  FirebaseMessaging.onMessageOpenedApp.listen(backgroundNotificationOnTap);
  //}

  // TERMINATED STATE
  Future<void> listenOnTerminatedState() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _firebaseMessagingBackgroundTerminationHandler(initialMessage);
    }
  }

  final bodyTabs = [
    const NewsTab(),
    const InterestClassTab(),
    const NotificationAndPromotionTab(),
    const ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig.init(context);
    return Consumer<BottomNavProvider>(
      builder: (context, data, child) {
        return Scaffold(
            resizeToAvoidBottomInset: true,
            body: IndexedStack(
              index: data.selectedIndex,
              children: bodyTabs,
            ),
            bottomNavigationBar: const BottomNavBar());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
