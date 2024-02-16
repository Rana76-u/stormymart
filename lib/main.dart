import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart/Blocks/Bottom%20Navigation%20Bloc/bottom_navigation_bloc.dart';
import 'package:stormymart/Blocks/Cart%20Bloc/cart_bloc.dart';
import 'package:stormymart/Components/firebase_api.dart';
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

  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BottomBarBloc(),),
          BlocProvider(create: (context) => CartBloc(),),
        ],
        child: GetMaterialApp(
          title: 'StormyMart',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Urbanist'
          ),
          //home: BottomBar(bottomIndex: 0),
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashFuturePage(),
            // '/': (context) => SplashFuturePage(),
            '/home': (context) => BottomBar(bottomIndex: 0),
          },
          debugShowCheckedModeBanner: false,
        )
    );
  }
}


