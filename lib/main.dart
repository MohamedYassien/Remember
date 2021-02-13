import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:remember/AppLocalizations.dart';
import 'package:remember/ui/home.dart';
import 'package:remember/ui/splash.dart';

import 'AppLanguage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();

  await appLanguage.fetchLocale();

  await runZoned<Future<void>>(() async {
    runApp(MyApp(
      appLanguage: appLanguage,
    ));
  }, onError: (error, stackTrace) {
    print("=================== CAUGHT FLUTTER ERROR\n");
    print('Caught error: $error');
    if (isInDebugMode) {
      print(stackTrace);
    }
  });
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
        create: (_) => widget.appLanguage,
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            locale: model.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              '/Home': (BuildContext context) => Home(),
//        '/LiveIncident': (BuildContext context) =>
//            LiveIncident(LiveIncidentChartResponse()),
//        '/TechnologyEvents': (BuildContext context) =>
//            ChangeManagement(),
//        '/SearchResults': (BuildContext context) => SearchResults(
//          /*isLast24Hours: false,*/
//        ),
//        '/IncidentManagementDashboard': (BuildContext context) =>
//            IncidentManagement(),
//        '/LiveNWIncidents': (BuildContext context) => LiveNWIncidents(),
//        '/RO': (BuildContext context) => RO(),
//        '/NWAndIT': (BuildContext context) => NWAndIT(),
//        '/ClosedChanges': (BuildContext context) => ClosedChanges(),
//        '/ClosedIncident': (BuildContext context) => CloseIncident(),
//        '/Notification': (BuildContext context) => NotificationScreen(),
//        '/NotificationDetails': (BuildContext context) =>
//            NotificationDetails(),
//        '/HomeDtSMS': (BuildContext context) => MyHomeDTSMSPage(),
//        '/HubScreen': (BuildContext context) => HubScreen(),
//        '/PowerNotificationScreen': (BuildContext context) =>
//            PowerNotificationScreen(),
            },
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
          );
        }));
  }
}
