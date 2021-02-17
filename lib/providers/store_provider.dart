
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ndawana_app/screens/welcome_screen.dart';
import 'package:ndawana_app/services/user_services.dart';

class StoreProvider with ChangeNotifier {
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;


  Future<void>getUseLocationData(context)async{
    _userServices.getUserbyId(user.uid).then((result){
      if(user!=null){
        this.userLatitude = result.data()['latitude'];
        this.userLongitude = result.data()['longitude'];
        notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      }
    });
  }




}