import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:social_media/src/controller/myProvider.dart';
import 'package:social_media/src/controller/pushNotificationViaRestApi.dart';
import 'package:social_media/src/controller/themeProvider.dart';
import 'package:social_media/src/screen/home_page_screen.dart';
import 'package:social_media/src/screen/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging.onBackgroundMessage((_) async {
    await Fluttertoast.showToast(
        msg: "You have new Message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  });
  FirebaseMessaging.onMessage.listen((event) async {
    await Fluttertoast.showToast(
        msg: " You have new Message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) async {
    print("opened");

    await Fluttertoast.showToast(
        msg: "You have new Message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        /* dark theme settings */
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[900],
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null ? HomePage() : SignIn(),
    );
  }
}
