

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndawana_app/providers/location_provider.dart';
import 'package:ndawana_app/screens/home_screen.dart';
import 'package:ndawana_app/screens/landing_screen.dart';
import 'package:ndawana_app/services/user_services.dart';

class AuthProvider with ChangeNotifier{

  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String error = '';
  UserServices _userServices = UserServices();

  bool loading = false;

  LocationProvider locationData = LocationProvider();
  String screen;
  double latitude;
  double longitude;
  String address;
  String location;



  Future<void>verifyPhone({BuildContext context, String number}) async{

    this.loading=true;
    notifyListeners();

    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async{
      this.loading=false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e){
      this.loading=false;
      print(e.code);
      this.error=e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtp = (String verId, int resendToken) async{
      this.verificationId = verId;

      //dialog box

      smsOtpDialog(context, number, latitude, longitude, address);
    };

    try{
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtp,
          codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
          },
      );
    } catch (e) {
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<dynamic>smsOtpDialog(BuildContext context, String number, double latitude, double longitude, String address){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Column(
            children: [
              Text('Verification Code'),
              SizedBox(height: 10,),
              Text('Enter OTP received as SMS', style: TextStyle(color: Colors.grey),),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value){
                this.smsOtp = value;
              },
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () async {
                  try{
                    PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsOtp);

                   final User user =  (await _auth.signInWithCredential(phoneAuthCredential)).user;

                   if(user!=null){
                     this.loading = false;
                     notifyListeners();

                     _userServices.getUserbyId(user.uid).then((snapshot){
                       if(snapshot.exists){
                         // user already exist

                         if(this.screen=='Login'){
                           // need to check if user data already exist in the db or not
                           // if its login no nw data so no need to update

                          if(snapshot.data()['address']!=null){
                            Navigator.pushReplacementNamed(context, HomeScreen.id);
                          }
                           Navigator.pushReplacementNamed(context, LandingScreen.id);

                         }else{
                           //need to update new selected address
                           updateUser(id: user.uid, number: user.phoneNumber);
                           Navigator.pushReplacementNamed(context, HomeScreen.id);
                         }

                       } else{
                         // user data does not exist
                         // will create new data in db
                         _createUser(id: user.uid,number: user.phoneNumber);
                         Navigator.pushReplacementNamed(context, LandingScreen.id);

                       }
                     });

                   }else{
                     print('Login failed');
                   }

                  } catch(e){
                    this.error =  'Invalid OTP';
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Done'),
            ),
          ],
        );
      }).whenComplete((){
        this.loading=false;
        notifyListeners();
    });
  }

  void _createUser({String id, String number}){
    _userServices.createUser({
      'id':id,
      'number':number,
      'latitude':this.latitude,
      'longitude': this.longitude,
      'address':this.address,
      'location': this.location
    });
  }

 Future<bool>updateUser({String id, String number,}) async {
   try{
     _userServices.createUser({
       'id':id,
       'number':number,
       'latitude':this.latitude,
       'longitude': this.longitude,
       'address':this.address,
       'location': this.location
     });
     this.loading=false;
     notifyListeners();
     return true;
   } catch(e){
     print('Error $e');
     return false;
   }
  }

}