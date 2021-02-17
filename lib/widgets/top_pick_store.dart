import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ndawana_app/providers/store_provider.dart';
import 'package:ndawana_app/screens/welcome_screen.dart';
import 'package:ndawana_app/services/store_service.dart';
import 'package:ndawana_app/services/user_services.dart';
import 'package:provider/provider.dart';

class TopPickStore extends StatefulWidget {
  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreService _storeService = StoreService();


  //need to find user LatLong and calculate the distance



  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUseLocationData(context);

    String getDistance(location){
      var distance = Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeService.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot){
          if(!snapShot.hasData) return CircularProgressIndicator();
//now showing shops in the 1okm radius
          //need to confirm if there are no shops nearby or not
          List shopDistance = [];
          for(int i =0 ; i<=snapShot.data.docs.length-1; i++){
            var distance = Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
            var distanceInKm = distance/1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort(); //this will sort by nearest distance if shop is more than 10km
          if(shopDistance[0]>10){
            return Container(

            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Row(
                  children: [
                    Text('Top Picks for you', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapShot.data.docs.map((DocumentSnapshot document){

                    if(double.parse(getDistance(document['location']))<=10){
                      // show store that are within 10km radius
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width:80,
                                height: 80 ,
                                child: Card(
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4.0),
                                        child: Image.network(document['imageUrl'], fit: BoxFit.cover,))),
                              ),
                              Container(
                                height: 35,
                                child: Text(document['shopName'], style: TextStyle(fontSize: 14),
                                  maxLines: 2, overflow: TextOverflow.ellipsis,),
                              ),
                              Text(
                                '${getDistance(document['location'])}Km', style: TextStyle(
                                  color: Colors.grey, fontSize: 10
                              ),)
                            ],
                          ),
                        ),
                      );
                    } else{
                      //if no stores
                      return Container(

                      );
                    }

                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
