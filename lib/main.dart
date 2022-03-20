import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/Utiles/navigation/named_routes.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/shared_pref.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_bloc.dart';
import 'package:ovx_style/bloc/bills_bloc/bills_bloc.dart';
import 'package:ovx_style/bloc/currencies_bloc/currencies_bloc.dart';
import 'package:ovx_style/bloc/login_bloc/login_events.dart';
import 'package:ovx_style/bloc/offer_bloc/offer_bloc.dart';
import 'package:ovx_style/bloc/stories_bloc/bloc.dart';
import 'Utiles/navigation/named_navigator_impl.dart';
import 'bloc/chat_bloc/chat_bloc.dart';
import 'bloc/comment_bloc/comment_bloc.dart';
import 'bloc/gifts_bloc/gifts_bloc.dart';
import 'bloc/login_bloc/login_bloc.dart';
import 'bloc/notifications_bloc/notifications_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

// last point>>> sending voice
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize firebase
  await Firebase.initializeApp();

  //initialize translator
  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/lang/',
  );
  //initialize shared pref
  await SharedPref.init();

  //set status bar to transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // //systemNavigationBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    LocalizedApp(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc()..add(AppStarted()),
          ),
          BlocProvider<CommentBloc>(
            create: (context) => CommentBloc(),
          ),
          BlocProvider<OfferBloc>(
            create: (context) => OfferBloc(),
          ),
          BlocProvider<AddOfferBloc>(
            create: (context) => AddOfferBloc(),
          ),
          BlocProvider<BasketBloc>(
            create: (context) => BasketBloc(),
          ),
          BlocProvider<BillsBloc>(
            create: (context) => BillsBloc(),
          ),
          BlocProvider<NotificationsBloc>(
            create: (context) => NotificationsBloc(),
          ),
          BlocProvider<CurrencyBloc>(
            create: (context) => CurrencyBloc(),
          ),
          BlocProvider<GiftsBloc>(
            create: (context) => GiftsBloc(),
          ),
          BlocProvider<StoriesBloc>(
            create: (context) => StoriesBloc(),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(),
          ),
        ],
        child: const MarketingApp(),
      ),
    ),
  );
}

class MarketingApp extends StatelessWidget {
  const MarketingApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: translator.delegates, // Android + iOS Delegates
      locale: translator.activeLocale, // Active locale
      supportedLocales: translator.locals(), // Local
      theme: ThemeData(
        primaryColor: MyColors.primaryColor,
        scaffoldBackgroundColor: MyColors.primaryColor,
        fontFamily: translator.activeLanguageCode == 'ar'
            ? 'NotoKufiArabic'
            : 'Poppins',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: MyColors.primaryColor,
          actionsIconTheme: IconThemeData(
            color: MyColors.secondaryColor,
          ),
          titleTextStyle: TextStyle(
              fontSize: 18,
              fontFamily: translator.activeLanguageCode == 'ar'
                  ? 'NotoKufiArabic'
                  : 'Poppins',
              fontWeight: FontWeight.w400,
              color: MyColors.secondaryColor,
              letterSpacing: 0.5),
          iconTheme: IconThemeData(
            color: MyColors.secondaryColor,
          ),
        ),
      ),
      builder: EasyLoading.init(),
      navigatorKey: NamedNavigatorImpl.navigatorState,
      onGenerateRoute: NamedNavigatorImpl.onGenerateRoute,
      initialRoute: NamedRoutes.SPLASH_SCREEN,
    );
  }
}
