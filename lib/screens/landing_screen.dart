import 'package:flutter/material.dart';
import 'package:ndawana_app/providers/location_provider.dart';
import 'package:ndawana_app/screens/map_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

//  User user = FirebaseAuth.instance.currentUser;
//  String _location;
//  String _address;

//  @override
//  void initState() {
//    UserServices _userServices = UserServices();
//    _userServices.getUserbyId(user.uid).then((result)async{
//      if(result!=null){
//        if(result.data()['latitude']!=null){
//          getPrefs(result);
//        } else{
//          _locationProvider.getCurrentPosition();
//          if(_locationProvider.permissionAllowed==true){
//            Navigator.pushNamed(context, MapScreen.id);
//          } else {
//            print('Permissions not allowed');
//          }
//        }
//      }
//    });
//    super.initState();
//  }

//  getPrefs(dbResult)async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String location = prefs.getString('location');
//
//    if(location == null){
//      prefs.setString('address', dbResult.data()['location']);
//      prefs.setString('location', dbResult.data()['address']);
//      if(mounted){
//        setState(() {
//
//          _location = dbResult.data()['location'];
//          _address = dbResult.data()['address'];
//        });
//      }
//      Navigator.pushReplacementNamed(context, HomeScreen.id);
//    }
//    Navigator.pushReplacementNamed(context, HomeScreen.id);
//
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Text(_location==null ? '' : _location),
//            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Delivery Address not set'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Please update your delivery location to find nearest stores around you'),
            ),
            Container(child: Image.asset('images/city.png')),


            _loading ? CircularProgressIndicator() : FlatButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });


                  await _locationProvider.getCurrentPosition();

                  if(_locationProvider.selectedAddress==true){
                    Navigator.pushReplacementNamed(context, MapScreen.id);
                  } else{
                   Future.delayed(Duration(seconds: 4),(){
                     if (_locationProvider.permissionAllowed==false){
                       print('Permissions not allowed');
                       setState(() {
                         _loading = false;
                       });
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                         content: Text('Please turn on location to find nearest stores'),
                       ));
                     }
                   });
                  }
                },
              color: Theme.of(context).primaryColor,
                child: Text('Set your location', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}

