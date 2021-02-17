import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndawana_app/providers/location_provider.dart';
import 'package:ndawana_app/screens/map_screen.dart';
import 'package:ndawana_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location ='';
  String _address ='';

  @override
  void initState() {
    // TODO: implement initState
    getPrefs();
    super.initState();
  }

  getPrefs()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');

    setState(() {
      _location = location;
      _address = address;
    });
  }


  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 0.0,
      leading: Container(),
      title: FlatButton(
        onPressed: (){
          locationData.getCurrentPosition();
          if(locationData.permissionAllowed==true){
            Navigator.pushNamed(context, MapScreen.id);
          }else {
            print('Permissions not allowed');
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: Text(_location==null ? 'Address not set': _location, style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,)),
                Icon(Icons.edit, color: Colors.white, size: 12,),
              ],
            ),
            Flexible(
                child: Text(_address, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 12),),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.power_settings_new,), onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        },),
        IconButton(icon: Icon(Icons.account_circle,), onPressed: (){},),
      ],
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.zero,
                fillColor: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
