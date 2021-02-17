import 'package:flutter/material.dart';
import 'package:ndawana_app/providers/auth_provider.dart';
import 'package:ndawana_app/providers/location_provider.dart';
import 'package:ndawana_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Visibility(
                visible: auth.error=='Invalid OTP' ? true:false,
                child: Container(
                  child: Column(
                    children: [
                      Text(auth.error, style: TextStyle(color: Colors.red),),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
              Text('LOGIN', style: TextStyle(fontSize: 18),),
              Text('Enter your phone number to proceed', style: TextStyle(fontSize: 14),),
              SizedBox(height: 2,),
              TextField(
                decoration: InputDecoration(
                  prefixText: '+263',
                  labelText: '9 digit mobile number',
                ),
                autofocus: true,
                keyboardType: TextInputType.phone,
                maxLength: 9,
                controller: _phoneNumberController,
                onChanged: (value){
                  if(value.length == 9){
                    setState((){
                      _validPhoneNumber= true;
                    });
                  } else {
                    setState((){
                      _validPhoneNumber= false;
                    });
                  }
                },
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: _validPhoneNumber ? false:true,
                      child: FlatButton(

                       color: _validPhoneNumber ? Colors.blueAccent : Colors.grey,
                        onPressed: (){
                          setState(() {
                            auth.loading=true;
                            auth.screen='MapScree';
                            auth.latitude= locationData.latitude;
                            auth.longitude= locationData.longitude;
                            auth.address= locationData.selectedAddress.addressLine;
                          });

                          String number = '+263${_phoneNumberController.text}';
                          auth.verifyPhone(
                              context: context,
                              number: number,

                          ).then((value){
                            _phoneNumberController.clear();
                            setState(() {
                              auth.loading= false;
                            });
                            Navigator.pushReplacementNamed(context, HomeScreen.id);
                          });
                        },
                        child: auth.loading? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ) : Text(_validPhoneNumber ? 'CONTINUE' : 'ENTER PHONE NUMBER', style: TextStyle(color: Colors.white), ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
