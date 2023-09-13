import 'dart:convert';

import 'package:financeguru/auth/auth_controller.dart';
import 'package:financeguru/main.dart';
import 'package:financeguru/presentation/pages/introduction_page.dart';
import 'package:flutter/material.dart';
import 'package:financeguru/common/gap.dart';
import 'package:financeguru/presentation/pages/signup_page.dart';
import 'package:financeguru/presentation/widgets/navbar_widget.dart';
import 'package:financeguru/style/color.dart';
import 'package:financeguru/style/typography.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});
  static const routeName = '/signin-page';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _isPasswordHidden = true;
  final formKey = GlobalKey<FormState>();
  AuthController controller = AuthController();   
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> getSms() async {
    SmsQuery query = SmsQuery();
    var permission = await Permission.sms.status;

    if (permission.isGranted) {
      print('Permission is granted');
    } else {
      await Permission.sms.request();
    }

    List<SmsMessage> messages = await query.getAllSms;

    List<String> sendMessage = [];

    messages.forEach((element) {
      if (element.date!.isAfter(DateTime(2023, 7, 10))) {
        if (element.body!.contains("by IMPS") ||
            element.body!.contains("by Mob Bk") ||
            element.body!.contains("by Chq")) {
          // print(element.body);
          sendMessage.add(element.body!);
        }
      }
    });
    if (GetStorage().read('token') != null) {
      String token = GetStorage().read('token');
      Uri uri = Uri.parse('https://backend-r677breg7a-uc.a.run.app/api/bank/transactionmessage/');
      final res = await http.post(uri,
          body: jsonEncode({
            "messages": sendMessage,
          }),
          headers: {"Authorization": "Bearer $token", 'Content-Type': 'application/json'});
      final jsonData = jsonDecode(res.body);
    }

    // setState(() {
    //   print(jsonData);
    //   points = jsonData['points'].toInt();
    // });

    // print(messages[0].body);
    // print(messages.length);

    // List<SmsMessage> sms =
    //     await query.querySms(kinds: [SmsQueryKind.inbox], count: 10);

    // print('BBBBBB');
    // print(sms[0].body);
    // print(sms.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              'Sign In',
              style: poppinsH1.copyWith(color: buttonColor, fontSize: 36),
            ),
            Text(
              'Sign in to continue to FinanceGuru',
              style: poppinsBody1.copyWith(color: textColor),
            ),
            const VerticalGap20(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: poppinsBody1.copyWith(color: textColor.withOpacity(.5)),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: buttonColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                    ),
                    style: poppinsBody1.copyWith(color: textColor),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (value.contains('@.')) {
                        return 'Please enter a valid email address';
                      } else if (value.contains('.@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const VerticalGap20(),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: poppinsBody1.copyWith(color: textColor.withOpacity(.5)),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                        child: Icon(
                          _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                          color: textColor.withOpacity(.5),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: buttonColor,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                    ),
                    style: poppinsBody1.copyWith(color: textColor),
                    obscureText: _isPasswordHidden ? true : false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      } else if (value.contains(' ')) {
                        return 'Password must not contain spaces';
                      } else if (value.contains('..')) {
                        return 'Password must not contain double dots';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const VerticalGap20(),
            InkWell(
              onTap: () async {
                // Navigator.pushNamed(context, NavigationBarWidget.routeName);
                // if (!formKey.currentState!.validate()) return;
                // formKey.currentState!.save();

                print('Button pressed ...');

                getSms();

                Loader.show(context, progressIndicator: CircularProgressIndicator(color: Colors.blue));

                String status = '';
                // Loader.hide();
                try {
                  status = await controller.login(usernameController.text, passwordController.text);
                } on Exception catch (e) {
                  Loader.hide();
                }
                Loader.hide();
                flutterLocalNotificationsPlugin.show(
                    1,
                    "Hey There!",
                    "Continue your journey to a financially organised life",
                    NotificationDetails(
                        android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channelDescription: channel.description,
                      sound: channel.sound,
                      playSound: true,
                    )));

                if (status == "Success") {
                  Navigator.pushNamed(context, NavigationBarWidget.routeName);
                }

                if (status == "incorrect_user_details") {
                  setState(() {});
                }

                if (status == "other_issue") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("There seems to be some issue"),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Sign In',
                    style: poppinsH4.copyWith(color: text2Color),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupPage.routeName);
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}