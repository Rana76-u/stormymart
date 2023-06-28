import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stormymart/utility/bottom_nav_bar.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App for university Students',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomBar(bottomIndex: 3),
      debugShowCheckedModeBanner: false,
    );
  }
}


