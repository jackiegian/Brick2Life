import 'package:Brick2Life/Screens/login_signup/create_house_screen.dart';
import 'package:Brick2Life/Screens/login_signup/join_house_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'Managers/data_manager.dart';
import 'Screens/login_signup/house_choice_screen.dart';
import 'Screens/login_signup/login_screen.dart';
import 'Screens/login_signup/signup_image.dart';
import 'Screens/login_signup/signup_screen.dart';
import 'Screens/main_screen.dart';
import 'Screens/welcome_screen.dart';
import 'Theme/app_theme.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(Brick2LifeApp()));
}

class Brick2LifeApp extends StatefulWidget {
  @override
  State<Brick2LifeApp> createState() => _MyAppState();
}

class _MyAppState extends State<Brick2LifeApp> {
  final DataManager _dataManager = DataManager();

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _dataManager,
        ),
      ],
      child: Consumer<DataManager>(
        builder: (context, manager, child) {
          ThemeData maintheme;
          if (manager.darkMode) {
            maintheme = EznestTheme.dark();
          } else {
            maintheme = EznestTheme.light();
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: maintheme,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''), 
              const Locale('it', ''),
            ],
            locale: const Locale('it', ''),
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                      builder: (context) => WelcomeScreen());
                case '/home':
                  return MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  );
                case '/signup_image':
                  return MaterialPageRoute(
                      builder: (context) => SignUpImageScreen());
                case '/house_choice':
                  return MaterialPageRoute(
                      builder: (context) => HouseChoiceScreen());
                case '/choice_house':
                  return MaterialPageRoute(
                      builder: (context) => HouseChoiceScreen());
                case '/create_house':
                  return MaterialPageRoute(
                      builder: (context) => CreateHouseScreen());
                case '/join_house':
                  return MaterialPageRoute(
                      builder: (context) => JoinHouseScreen());

                default:
                  return null;
              }
            },
          );
        },
      ),
    );
  }
}
