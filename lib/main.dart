import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/authentication_wrapper.dart';
import 'locator.dart';
import 'l18n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GoogleProvider(
      clientId:
          '1071410777644-qmis8u6herq999po7pkvfs4qhrntmpf4.apps.googleusercontent.com');

  setupServices();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MeinApp(prefs));
}

class MeinApp extends StatelessWidget {
  final SharedPreferences prefs;

  MeinApp(this.prefs);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selfie',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      supportedLocales: [Locale('en', 'US'), Locale('pt', 'PT')],
      localizationsDelegates: [
        const AppLocalizationsDelegate(defaultLocale: Locale('pt')),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AuthenticationWrapper(this.prefs),
    );
  }
}
