import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/api/users/database_repository.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_bloc.dart';
import 'package:ovx_style/bloc/notifications_bloc/notifications_events.dart';
import 'package:provider/src/provider.dart';
import '../main.dart';

class NotificationsHelper {
  static final FirebaseMessaging fcm = FirebaseMessaging.instance;

  static void saveDeviceTokenToDatabase() async {
    DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();

    String token = await fcm.getToken() ?? '';

    await databaseRepositoryImpl.saveDeviceToken(token, SharedPref.getUser().id!);
    print('saved');
  }

  static void deleteDeviceTokenFromDatabase() async {
    DatabaseRepositoryImpl databaseRepositoryImpl = DatabaseRepositoryImpl();
    String token = await fcm.getToken() ?? '';

    await databaseRepositoryImpl.deleteDeviceToken(token, SharedPref.getUser().id!);
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  static void listenToNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      print('event message is ${message.toString()}');
      RemoteNotification? notification = message.notification;
      //AndroidNotification? android = message.notification?.android;

      //get the current context to re fetch notifications
      BuildContext ctx = NamedNavigatorImpl.navigatorState.currentContext!;
      ctx.read<NotificationsBloc>().add(FetchNotifications());

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('event open app is ${message.toString()}');
      RemoteNotification? notification = message.notification;
      //AndroidNotification? android = message.notification?.android;

      //get the current context to re fetch notifications
      BuildContext ctx = NamedNavigatorImpl.navigatorState.currentContext!;
      ctx.read<NotificationsBloc>().add(FetchNotifications());

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
