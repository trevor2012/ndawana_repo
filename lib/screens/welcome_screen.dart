import 'package:flutter/material.dart';
import 'package:ndawana_app/providers/auth_provider.dart';
import 'package:ndawana_app/providers/location_provider.dart';
import 'package:ndawana_app/screens/map_screen.dart';
import 'package:ndawana_app/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';


class WelcomeScreen extends StatefulWidget {

  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context){
      showModalBottomSheet(
        context: context,
        builder: (context)=> StatefulBuilder(
            builder: (context, StateSetter myState){
              return Container(
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
                      SizedBox(height: 30,),
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
                            myState((){
                              _validPhoneNumber= true;
                            });
                          } else {
                            myState((){
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
//                                color: _validPhoneNumber ? Colors.blueAccent : Colors.grey,
                                onPressed: (){
                                  auth.loading=true;
                                  String number = '+263${_phoneNumberController.text}';
                                  auth.verifyPhone(context:context, number: number).then((value){
                                    _phoneNumberController.clear();
                                    auth.loading=false;
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
              );
            }
        ),
      ).whenComplete((){
        setState(() {
          auth.loading=false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
           Positioned(
             right: 0.0,
             top: 10.0,
             child: FlatButton(
               child: Text('SKIP', style: TextStyle(color: Colors.blueAccent),),
                 onPressed: (){},
             ),
           ),
            Column(
              children: <Widget>[
                Expanded(child: OnBoardingScreen()),
                Text('Ready to order from the nearest shop?'),
                SizedBox(height: 20,),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    await locationData.getCurrentPosition();
                    if(locationData.permissionAllowed==true){
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                    } else {
                      print('Permission not allowed');
                    }
                  },
                  child: Text('SET DELIVERY LOCATION'),
                ),
                SizedBox(height: 20,),
                FlatButton(
                  child: RichText(
                      text: TextSpan(
                        text: 'Already a Customer ? ',style: TextStyle(color: Colors.black), children: [
                        TextSpan(
                            text: 'Login', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)
                        )
                      ],
                      )
                  ),
                  onPressed: (){
                    setState((){
                      auth.screen='login';
                    });
                    showBottomSheet(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
