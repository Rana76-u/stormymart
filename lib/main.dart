import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stormymart/firebase_options.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';
import 'package:stormymart/utility/splash_screen.dart';
import 'package:get/get.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  /*await Firebase.initializeApp(
    name: "StormyMart",
    options: const FirebaseOptions(
        apiKey: "AIzaSyDep-c3PKJCs7HZqS-_Y9GlkfWbKV0ZdXQ",
        appId: "1:608528534677:web:c52bc67632d43a14535f9c",
        messagingSenderId: "608528534677",
        projectId: "stormymart-43ea8"
    )
  );*/
  /*await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);*/

  //await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StormyMart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Urbanist'
      ),
      //home: BottomBar(bottomIndex: 0),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashFuturePage(),
        // '/': (context) => SplashFuturePage(),
        '/home': (context) => BottomBar(bottomIndex: 0),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


