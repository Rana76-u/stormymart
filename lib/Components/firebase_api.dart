import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'stormymart',
    'stormymart Notifications',
    description: 'This channel is used for stormymart notifications',
    importance: Importance.defaultImportance
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if(message == null) return;

    print('${message.notification?.title}');
    print('${message.notification?.body}');
    print('${message.data}');
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
        handleMessage(message);
      },
    );

    final  platform = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    
    FirebaseMessaging.instance.getInitialMessage().then((value) {  //-----------(value) => handleMessage
      handleMessage;

      final screen = value?.data['screen'];
      if(screen != 'null') {
        Get.to(
            screen,
          transition: Transition.fade
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage;

      final screen = message.data['screen'];
      if(screen != null){
        //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
        Get.to(
            screen,
            transition: Transition.fade
        );
      }
    },);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if(notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
           _androidChannel.id,
           _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher'
          )
        ),
        payload: jsonEncode(message.toMap())
      );


    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcMToken = await _firebaseMessaging.getToken();
    print('Token: $fcMToken');
    initPushNotifications();
    initLocalNotifications();
  }
}