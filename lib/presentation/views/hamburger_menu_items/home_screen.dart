import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spa_app/data/constant/font_constant.dart';
import 'package:spa_app/data/enum/network_status_enum.dart';
import 'package:spa_app/logic/providers/bottom_nav_provider.dart';
import 'package:spa_app/logic/providers/chat_message_provider.dart';
import 'package:spa_app/logic/providers/locale_provider.dart';
import 'package:spa_app/logic/providers/main_screen_provider.dart';
import 'package:spa_app/logic/providers/news_ad_provider.dart';
import 'package:spa_app/logic/providers/notification_provider.dart';
import 'package:spa_app/presentation/components/all/bottom_nav_bar.dart';
import 'package:spa_app/presentation/helper/size_configuration.dart';
import 'package:spa_app/presentation/tabs/further_studies_tab.dart';
import 'package:spa_app/presentation/tabs/interest_class_tab.dart';
import 'package:spa_app/presentation/tabs/news_tab.dart';
import 'package:spa_app/presentation/tabs/paper_share_tab.dart';
import 'package:spa_app/presentation/tabs/profile_tab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late SharedPreferences sharedPreferences;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool isFlutterLocalNotificationsInitialized = false;

  Future<void> _firebaseMessagingBackgroundTerminationHandler(
      RemoteMessage message) async {
    // making sure that the firebase is initialized before using firebase services in the background or terminated state
    await Firebase.initializeApp();
    await loadFCM();
    showFlutterNotification(message);
  }

// setup flutter heads up notification
  Future<void> loadFCM() async {
    if (isFlutterLocalNotificationsInitialized == true) {
      return;
    }
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'spa', // id
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

  void showFlutterNotification(RemoteMessage message) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();

    // Provider.of<NewsAdProvider>(context, listen: false)
    //     .setUnreadNotificationBadge();

    // if is a chat message notification
    if ((message.notification != null && message.notification!.body != null) &&
            message.notification!.body!.contains("has sent you a message.") ||
        message.notification!.body!.contains("已向您发送消息。") ||
        message.notification!.body!.contains("已向您發送消息。")) {
      final bodyList =
          message.notification!.body!.split(" has sent you a message.");
      // if current user is not in chat screen with another user that has sent chat notification,
      // then only notification will be displayed
      if (sharedPreferences.getString('active_chat_username') == bodyList[0] &&
          Platform.isIOS) {
        // print('no need to show ios notification');
        return;
      }

      if (sharedPreferences.getString('active_chat_username') != bodyList[0]) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null && !kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                priority: Priority.high,
                channelShowBadge: true,
                icon: 'app_icon',
              ),
            ),
          );
        }

        // If currently on chat room screen do not show notification badge on news app bar
        if (sharedPreferences.getBool("chatroom_active_status") == false) {
          sharedPreferences.setBool('chat_message_push_notification', true);
          if (mounted) {
            Provider.of<ChatMessageProvider>(context, listen: false)
                .setChatMessageNotification();
          }
        } else {
          // print(' do not set chat notification');
        }
      } else {
        // print('currently chatting with user');
      }
    }
    // if it is a follow/unfollow notification
    else if ((message.notification != null &&
                message.notification!.body != null) &&
            message.notification!.body!.contains("started following you.") ||
        message.notification!.body!.contains("开始关注你。") ||
        message.notification!.body!.contains("開始關注你。") ||
        message.notification!.body!.contains("unfollowed you.") ||
        message.notification!.body!.contains("未关注您。") ||
        message.notification!.body!.contains("未關注您。")) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'app_icon',
            ),
          ),
        );
      }
      // only show notification badge when user is not in the notification tab
      if (sharedPreferences.getBool("notification_tab_active_status") ==
          false) {
        sharedPreferences.setBool('follow_push_notification', true);

        if (mounted) {
          Provider.of<NewsAdProvider>(context, listen: false)
              .setFollowNotification();
        }
      } else if (sharedPreferences.getBool("notification_tab_active_status") ==
          true) {
        if (mounted) {
          Provider.of<NotificationProvider>(context, listen: false)
              .updateCurrentUserLatestNotification(context: context);
        }
      }
      // to update user details including follow/follower when notification is received
      if (mounted) {
        Provider.of<MainScreenProvider>(context, listen: false)
            .updateAndSetUserDetails(
          setLikeSaveCommentFollow: false,
          context: context,
        );
      }
    }
  }

  void setLanguageCode() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String languageLocale =
        sharedPreferences.getString("language_locale") ?? 'zh_Hant';
    if (languageLocale == 'zh_Hant') {
      Provider.of<LocaleProvider>(context, listen: false).setLocale(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
    } else if (languageLocale == 'zh_Hans') {
      Provider.of<LocaleProvider>(context, listen: false).setLocale(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'));
    } else if (languageLocale == 'en') {
      Provider.of<LocaleProvider>(context, listen: false)
          .setLocale(const Locale("en"));
    }
  }

  @override
  void initState() {
    super.initState();
    setLanguageCode();
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
    sharedPreferences = await SharedPreferences.getInstance();
    await loadFCM();
    listenOnForegroundState();
    //listenOnBackgroundState();
    listenOnTerminatedState();
  }

  Future<void> initDynamicLinks() async {
    if (mounted) {
      final mainProvider =
          Provider.of<MainScreenProvider>(context, listen: false);

      // APP ON TERMINATED STATE
      // Check if you received the link via `getInitialLink` first
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (initialLink != null) {
        final Uri deepLink = initialLink.link;
        // ignore: use_build_context_synchronously
        mainProvider.navigateRouteFromDynamicLink(
            deepLink: deepLink, context: context);
      }

      // APP ON FOREGROUND AND BACKGROUND STATE
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        Uri? appRunningDeepLink = dynamicLinkData.link;
        mainProvider.navigateRouteFromDynamicLink(
            deepLink: appRunningDeepLink, context: context);
      });
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.reload();

      // Provider.of<NewsAdProvider>(context, listen: false)
      //     .setUnreadNotificationBadge();

      // FOLLOW NOTIFICATION
      bool followPushNotification =
          (sharedPreferences.getBool('follow_push_notification') == true);
      bool notificationTabActiveStatus =
          (sharedPreferences.getBool("notification_tab_active_status") == true);

      if (followPushNotification &&
          mounted &&
          notificationTabActiveStatus == false) {
        Provider.of<NewsAdProvider>(context, listen: false)
            .setFollowNotification();
        Provider.of<MainScreenProvider>(context, listen: false)
            .updateAndSetUserDetails(
          setLikeSaveCommentFollow: false,
          context: context,
        );
      } else if (mounted && notificationTabActiveStatus) {
        // print('currently in notification tab');
        Provider.of<NotificationProvider>(context, listen: false)
            .updateCurrentUserLatestNotification(context: context);

        Provider.of<MainScreenProvider>(context, listen: false)
            .updateAndSetUserDetails(
          setLikeSaveCommentFollow: false,
          context: context,
        );
      }

      // CHAT NOTIFICATION
      bool chatMessagePushNotification =
          (sharedPreferences.getBool('chat_message_push_notification') == true);
      if (chatMessagePushNotification &&
          mounted &&
          sharedPreferences.getBool("chatroom_active_status") == false) {
        Provider.of<ChatMessageProvider>(context, listen: false)
            .setChatMessageNotification();
      }
    }
  }

  // FOREGROUND STATE
  void listenOnForegroundState() async {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
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
    const PaperShareTab(),
    const FurtherStudiesTab(),
    const InterestClassTab(),
    const ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig.init(context);
    var networkStatus = Provider.of<NetworkStatus>(context);
    return Consumer<BottomNavProvider>(
      builder: (context, data, child) {
        return networkStatus == NetworkStatus.offline
            ? Scaffold(
                body: Center(
                  child: Text(
                    AppLocalizations.of(context)
                        .youDoNotHaveAnyInternetConnection,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: kHelveticaRegular,
                        fontSize: SizeConfig.defaultSize * 1.5),
                  ),
                ),
              )
            : Scaffold(
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
