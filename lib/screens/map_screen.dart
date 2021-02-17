import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ndawana_app/providers/auth_provider.dart';
import 'package:ndawana_app/providers/location_provider.dart';
import 'package:ndawana_app/screens/landing_screen.dart';
import 'package:ndawana_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map-screen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng currentLocation = LatLng(17.8601,30.9245);

  bool _loggedIn = false;
  User user;
  bool _locating = false;
  
  @override
  void initState() {
    // check user logged in or not while opening map
    getCurrentUser();
    super.initState();
  }
  
  void getCurrentUser(){
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if(user!=null){
      setState(() {
        _loggedIn=true;
      });
    }
  }
  
  @override
  
  Widget build(BuildContext context) {

    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller){
      setState(() {

      });
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation, zoom: 14.4746,
                ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: (CameraPosition position){
                  locationData.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: (){
                locationData.getMoveCamera();
              },

            ),
            
            Center(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(bottom: 40),
                child: Image.asset('images/marker.png'),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _locating ? LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ) : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: FlatButton.icon(
                        onPressed: (){},
                        icon: Icon(Icons.location_searching, color: Theme.of(context).primaryColor,),
                        label: Flexible(
                          child: Text(
                              _locating ? 'Locating....' : locationData.selectedAddress == null ? 'Locating....': locationData.selectedAddress.featureName,
                          overflow: TextOverflow.ellipsis,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(_locating ? '' :locationData.selectedAddress == null? '': locationData.selectedAddress.addressLine),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width-40,
                        child: AbsorbPointer(
                          absorbing: _locating ? true : false,
                          child: FlatButton (
                              onPressed: (){
                                locationData.savePrefs();
                                if(_loggedIn==false){
                                  Navigator.pushNamed(context, LoginScreen.id);
                                } else {
                                  setState(() {
                                    _auth.latitude= locationData.latitude;
                                    _auth.longitude= locationData.longitude;
                                    _auth.address= locationData.selectedAddress.addressLine;
                                    _auth.location = locationData.selectedAddress.featureName;
                                  });
                                  _auth.updateUser(
                                    id: user.uid,
                                    number: user.phoneNumber,
                                  ).then((value) {
                                    if(value == true){
                                      Navigator.pushNamed(context, LandingScreen.id);
                                    }
                                  });

                                }
                              },
                            color: Theme.of(context).primaryColor,
                              child: Text('CONFIRM LOCATION'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
