
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ndawana_app/providers/auth_provider.dart';
import 'package:ndawana_app/providers/location_provider.dart';
import 'package:ndawana_app/providers/store_provider.dart';
import 'package:ndawana_app/screens/home_screen.dart';
import 'package:ndawana_app/screens/landing_screen.dart';
import 'package:ndawana_app/screens/login_screen.dart';
import 'package:ndawana_app/screens/map_screen.dart';
import 'package:ndawana_app/screens/splash_screen.dart';
import 'package:ndawana_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_)=>AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_)=>LocationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_)=>StoreProvider(),
      )
    ],
    child: MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueAccent
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        MapScreen.id:(context)=>MapScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        LandingScreen.id:(context)=>LandingScreen(),
      },
    );
  }
}

