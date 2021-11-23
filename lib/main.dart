import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translator/flutter_translator.dart';
import 'package:provider/provider.dart';
import 'package:tourapp/core/managers/dialog_manager.dart';
import 'package:tourapp/core/models/user_loaction.dart';
import 'package:tourapp/core/services/route_middleware.dart';
import 'package:tourapp/core/utils/exceptions.dart';
import 'package:tourapp/core/viewmodels/location_services.dart';
import 'package:tourapp/core/viewmodels/screens/home/home_viewmodel.dart';
import 'package:tourapp/core/viewmodels/screens/location/like_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/location/location_details_viewmodel.dart';
import 'package:tourapp/core/viewmodels/screens/location/near_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/location/rating_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/map/map_view_model.dart';
import 'package:tourapp/core/viewmodels/screens/user/user_vieemodel.dart';
import 'package:tourapp/core/viewmodels/translation_provider.dart';
import 'package:tourapp/routes.dart';
import 'package:tourapp/services/exceptions/exceptions.dart';
import 'package:tourapp/ui/shared/app.dart';
import 'package:tourapp/ui/shared/app_builder.dart';
import 'package:tourapp/services/shared_prefs.dart';
import 'package:tourapp/ui/views/error_page.dart';
import 'package:tourapp/ui/views/home/home.dart';
import 'package:tourapp/ui/views/user/login.dart';
import 'package:tourapp/viewmodels/Weather_Map_ViewModel.dart';
import 'package:tourapp/viewmodels/comment_view_model.dart';
import 'package:tourapp/views/home/providers/location_provider.dart';
import 'package:tourapp/ui/shared/intro.dart';
import 'package:tourapp/views/user/providers/sign_up_provider.dart';

import 'locator.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
NavigatorMiddleware<PageRoute> middleware = NavigatorMiddleware<PageRoute>(
  onPush: (route, previousRoute) {
    log('we have push event');

    ///if route is Y we should have some API call
  },
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  await sharedPrefs.init();
  AwesomeNotifications().initialize(
      'resource://drawable/logo',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
            channelKey: 'scheduled_channel',
            channelName: 'Scheduled Notifications',
            defaultColor: Colors.teal,
            // locked: true,
            importance: NotificationImportance.High,
            defaultRingtoneType: DefaultRingtoneType.Alarm
            // soundSource: 'resource://raw/res_custom_notification',
            ),
      ],
      debug: true);



  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => LocationProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => MapViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => LocationDetailsViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => TranslationProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => LikeViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => CommentViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => WeatherMapViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => NearViewmdel(),
    ),
    ChangeNotifierProvider(
      create: (_) => UserViewmodel(),
    ),
    ChangeNotifierProvider(
      create: (_) => RatingViewmodel(),
    ),
    ChangeNotifierProvider(
      create: (_) => LikeViewModel(),
    ),
    StreamProvider<UserLocation>(
  initialData: null ,
      create : (context) => LocationService().locationStream,
    )
  ], child: MyApp()));
  
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TranslatorGenerator translator = TranslatorGenerator.instance;

  @override
  void initState() {
    super.initState();

    translator.init(
      supportedLanguageCodes: ['en', 'ar'],
      initLanguageCode: 'ar',
    );

    translator.onTranslatedLanguage = _onTranslatedLanguage;
  }

  void _onTranslatedLanguage(Locale locale) {
    setState(() {});
  }

  String theme;
  getThemeData() async {
    var data = await sharedPrefs.getCurrentTheme();

    setState(() {
      theme = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBuilder(
      builder: (context) => MaterialApp(
        title: 'الدليل السياحي',
        //   builder: (context, widget) => Navigator(
        //   onGenerateRoute: (settings) => MaterialPageRoute(
        //     builder: (context) => DialogManager(
        //       child: widget,
        //     ),
        //   ),
        // ),
        
        //       // routes: appRoutes,
       // navigatorObservers: [routeObserver, middleware],
        debugShowCheckedModeBanner: false,
        supportedLocales: translator.supportedLocales,
        localizationsDelegates: translator.localizationsDelegates,
        navigatorKey: App.navigatorKey,
        //  darkTheme: ThemeData.dark(), // Provide dark theme.
        themeMode: theme == "light" ? ThemeMode.light : ThemeMode.dark,

        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.teal,
        ),
        home: getHome()
        //Intro(),
      ),
    );
  }


  Widget getHome(){
    if (!sharedPrefs.isShownBefore()  && !sharedPrefs.isLoggedIn()) {
      return Intro();
    }else if (sharedPrefs.isShownBefore()  &&sharedPrefs.isLoggedIn()){
      return HomeView();
    } else if(sharedPrefs.isShownBefore() && !sharedPrefs.isLoggedIn()){
      return LoginPage();
    }else {
      return Intro();
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold();
  }
}

AppException getException(int code) {
  switch (code) {
    case 403:
      return UnauthorisedException();
    case 500:
    case 501:
    case 503:
      return ServerException();
      case 404:
      case 401:
      return NotFoundException(
        
      );
    case 303:
      return ConnectionException();
  case 302:
      return MyTimeoutConnection();
      break;
    default:
      return UnknownException();
  }
}

Widget getErrorWidget(
  AppException error ,
  
  String msg, String asset, VoidCallback onPress) {
  return ErrorPage(
    error: error,
    asset: asset,
    onPress: onPress,
    msg: msg,
  );
}
