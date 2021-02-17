import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndawana_app/screens/home_screen.dart';
import 'package:ndawana_app/screens/landing_screen.dart';
import 'package:ndawana_app/screens/welcome_screen.dart';
import 'package:ndawana_app/services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState(){
    Timer(
        Duration(
          seconds: 3,
        ), (){
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if(user == null){
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        } else {
          //Navigator.pushReplacementNamed(context, LandingScreen.id);
          //if user has data
          getUserData();
        }
      });
    }
    );
  }

  getUserData()async{
    UserServices _userServices = UserServices();
    _userServices.getUserbyId(user.uid).then((result){
      //check location data
      if(result!=null){
        if(result.data()['latitude']!=null){
          //if address exist
          updatePrefs(result);
        }
      }
      // if address does not exist
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void>updatePrefs(result)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);

    //after updating preferences navigate to home screen
    Navigator.pushReplacementNamed(context, HomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
            tag: 'logo',
            child: Image.asset('images/logo.png')),
      ),
    );
  }
}

