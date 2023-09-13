import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:financeguru/presentation/pages/history_page.dart';
import 'package:financeguru/presentation/pages/home_page.dart';
import 'package:financeguru/presentation/pages/introduction_page.dart';
import 'package:financeguru/presentation/pages/signin_page.dart';
import 'package:financeguru/presentation/pages/pocket_page.dart';
import 'package:financeguru/presentation/pages/qr_scanner_page.dart';
import 'package:financeguru/presentation/pages/settings_page.dart';
import 'package:financeguru/presentation/pages/signup_page.dart';
import 'package:financeguru/presentation/pages/splash_page.dart';
import 'package:financeguru/presentation/widgets/navbar_widget.dart';
import 'package:financeguru/style/color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  // await GetStorage.init();
  runApp(const MyApp());
  
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high importance channel', 'High Importance Notifications',
    description: 'This channel is used for important Notifications', importance: Importance.high);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings('logo'));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Future<void> getSms() async {
  //   SmsQuery query = SmsQuery();
  //   var permission = await Permission.sms.status;

  //   if (permission.isGranted) {
  //     print('Permission is granted');
  //   } else {
  //     await Permission.sms.request();
  //   }

  //   List<SmsMessage> messages = await query.getAllSms;

  //   List<String> sendMessage = [];

  //   messages.forEach((element) {
  //     if (element.date!.isAfter(DateTime(2023, 7, 10))) {
  //       if (element.body!.contains("by IMPS") ||
  //           element.body!.contains("by Mob Bk") ||
  //           element.body!.contains("by Chq")) {
  //         // print(element.body);
  //         sendMessage.add(element.body!);
  //       }
  //     }
  //   });
  //   if (GetStorage().read('token') != null) {
  //     String token = GetStorage().read('token');
  //     Uri uri = Uri.parse('https://backend-r677breg7a-uc.a.run.app/api/bank/transactionmessage/');
  //     final res = await http.post(uri,
  //         body: jsonEncode({
  //           "messages": sendMessage,
  //         }),
  //         headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'});
  //     final jsonData = jsonDecode(res.body);
  //   }

  //   // setState(() {
  //   //   print(jsonData);
  //   //   points = jsonData['points'].toInt();
  //   // });

  //   // print(messages[0].body);
  //   // print(messages.length);

  //   // List<SmsMessage> sms =
  //   //     await query.querySms(kinds: [SmsQueryKind.inbox], count: 10);

  //   // print('BBBBBB');
  //   // print(sms[0].body);
  //   // print(sms.length);
  // }

  @override
  void initState() {
    // TODO: implement initState
    // getSms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: primaryColor,
      ),
      initialRoute: SplashPage.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case NavigationBarWidget.routeName:
            return MaterialPageRoute(builder: (_) => const NavigationBarWidget());
          case SplashPage.routeName:
            return MaterialPageRoute(builder: (_) => const SplashPage());
          case IntroductionPage.routeName:
            return MaterialPageRoute(builder: (_) => const IntroductionPage());
          case SigninPage.routeName:
            return MaterialPageRoute(builder: (_) => const SigninPage());
          case SignupPage.routeName:
            return MaterialPageRoute(builder: (_) => const SignupPage());
          case HomePage.routeName:
            return MaterialPageRoute(builder: (_) => const HomePage());
          case PocketPage.routeName:
            return MaterialPageRoute(builder: (_) => const PocketPage());
          case QRScannerPage.routeName:
            return MaterialPageRoute(builder: (_) => const QRScannerPage());
          case HistoryPage.routeName:
            return MaterialPageRoute(builder: (_) => const HistoryPage());
          case SettingsPage.routeName:
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          default:
            return null;
        }
      },
    );
  }
}
